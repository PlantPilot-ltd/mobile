import 'dart:async';

import 'package:app/services/index.dart';
import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as bl;

class BluetoothDeviceService with Store {
  final LogService _logger;

  final BluetoothConfigurationModel config;

  final void Function(BluetoothConnectionModel) onConnectionChange;
  final void Function(BluetoothDataModel?) onBluetoothData;

  late BluetoothConnectionModel _connection;

  /// Characteristic for receiving data from [device]
  bl.BluetoothCharacteristic? _deviceReceiveChar;

  /// Characteristic for sending data to [device]
  bl.BluetoothCharacteristic? _deviceSendChar;

  Timer? _dataListenerTimer;
  StreamSubscription? _deviceConnectionStateSubscription;

  BluetoothDeviceService({
    required this._logger,
    required this.config,
    required BluetoothDeviceModel device,
    required this.onConnectionChange,
    required this.onBluetoothData,
  }) {
    _init(device);
  }

  void _init(BluetoothDeviceModel device) {
    final blDevice = device.toBlModel();
    final initState = blDevice.isConnected
        ? bl.BluetoothConnectionState.connected
        : bl.BluetoothConnectionState.disconnected;
    _connection = BluetoothConnectionModel(
      device: device,
      state: BluetoothConnectionStateExtension.fromBlModel(initState),
    );

    _initDeviceConnectionListener(blDevice);
    _onDeviceConnectionStateChange(initState, initCall: true);
  }

  void dispose() {
    _deviceConnectionStateSubscription?.cancel();
  }

  /// Connect to [device]
  Future<VoidThrowableResponse> connect({bool autoConnect = true}) async {
    try {
      await disconnect();
      final blDevice = _connection.device.toBlModel();

      onConnectionChange(
        BluetoothConnectionModel.connecting(_connection.device),
      );

      _initDeviceConnectionListener(blDevice);

      await blDevice.connect(
        // TODO: Check
        license: .nonprofit,
        timeout: config.connectionTimeout,
        autoConnect: autoConnect,
        mtu: null,
      );
      return const VoidThrowableResponse.success();
    } catch (e, s) {
      return _logException(AppException.fromException(e, s));
    }
  }

  void _initDeviceConnectionListener(bl.BluetoothDevice blDevice) {
    _deviceConnectionStateSubscription?.cancel();
    _deviceConnectionStateSubscription = blDevice.connectionState.listen(
      _onDeviceConnectionStateChange,
    );
    if (_deviceConnectionStateSubscription != null) {
      blDevice.cancelWhenDisconnected(
        _deviceConnectionStateSubscription!,
        delayed: true,
        next: true,
      );
    }
  }

  Future<VoidThrowableResponse> _setupConnection(
    bl.BluetoothDevice blDevice,
  ) async {
    try {
      await blDevice.discoverServices();
      _deviceReceiveChar = _getCharacteristics(
        blDevice,
        config.receiveCharacteristicUUID,
      );
      _deviceSendChar = _getCharacteristics(
        blDevice,
        config.sendCharacteristicUUID,
      );

      _startDataListener();
      return const VoidThrowableResponse.success();
    } catch (e, s) {
      return _logException(AppException.fromException(e, s));
    }
  }

  /// Disconnect from [device]
  Future<VoidThrowableResponse> disconnect() async {
    try {
      final blDevice = _connection.device.toBlModel();
      await blDevice.disconnect();
      _processDisconnection();
      return const VoidThrowableResponse.success();
    } catch (e, s) {
      return _logException(AppException.fromException(e, s));
    }
  }

  void _processDisconnection() {
    _stopDataListener();
    _deviceConnectionStateSubscription?.cancel();
    _deviceReceiveChar = null;
    _deviceSendChar = null;
    _connection = _connection.copyWith(
      state: const Optional(BluetoothConnectionStateModel.disconnected),
    );

    onConnectionChange(_connection);
  }

  /// Send data to device
  ///
  /// Maximum size of data is 512 bytes
  Future<VoidThrowableResponse> sendData<T>({
    required T model,
    required BluetoothEncoder<T> encoder,
    int timeout = 15,
  }) async {
    try {
      final blDevice = _connection.device.toBlModel();

      _deviceSendChar ??= _getCharacteristics(
        blDevice,
        config.sendCharacteristicUUID,
      );
      if (_deviceSendChar == null) {
        return _logException(
          BluetoothNoCharacteristicError(config.sendCharacteristicUUID),
        );
      }

      await _deviceSendChar!.write(encoder(model), timeout: timeout);
      return const VoidThrowableResponse.success();
    } catch (e, s) {
      return _logException(AppException.fromException(e, s));
    }
  }

  bl.BluetoothCharacteristic? _getCharacteristics(
    bl.BluetoothDevice device,
    String uuid,
  ) {
    for (var service in device.servicesList) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString() == uuid) {
          return characteristic;
        }
      }
    }
    return null;
  }

  void _onDeviceConnectionStateChange(
    bl.BluetoothConnectionState state, {
    bool initCall = false,
  }) {
    final newState = BluetoothConnectionStateExtension.fromBlModel(state);
    final oldState = _connection.state;

    if (!initCall && oldState == newState) {
      return;
    }

    _connection = _connection.copyWith(state: Optional(newState));
    onConnectionChange(_connection);

    /// If device is connected, start data listener
    if (newState == BluetoothConnectionStateModel.connected) {
      _setupConnection(_connection.device.toBlModel());
    }

    /// If device is disconnected, process disconnection
    if (newState == BluetoothConnectionStateModel.disconnected) {
      connect();
      return;
    }
  }

  void _startDataListener() {
    _stopDataListener();
    _dataListenerTimer = Timer.periodic(
      config.dataReceiveTick,
      (_) => _onDataCaptureTick(),
    );
  }

  void _stopDataListener() {
    _dataListenerTimer?.cancel();
    _dataListenerTimer = null;
  }

  Future<void> _onDataCaptureTick() async {
    try {
      final blDevice = _connection.device.toBlModel();
      _deviceReceiveChar ??= _getCharacteristics(
        blDevice,
        config.sendCharacteristicUUID,
      );
      if (_deviceReceiveChar == null) {
        _stopDataListener();
        return;
      }
      final data = await _deviceReceiveChar!.read();
      onBluetoothData(
        BluetoothDataModel(data: data, timeStamp: DateTime.now()),
      );
    } catch (e, s) {
      _logException(AppException.fromException(e, s));
    }
  }

  VoidThrowableResponse _logException(AppException e) {
    _logger.logException(e, e.stackTrace);
    return VoidThrowableResponse.failure(e);
  }
}
