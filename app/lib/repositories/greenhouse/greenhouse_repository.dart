import 'dart:convert';

import 'package:app/entities/index.dart';
import 'package:app/services/index.dart';
import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';

part 'greenhouse_repository.g.dart';

class GreenhouseRepository = _GreenhousesRepository with _$GreenhouseRepository;

abstract class _GreenhousesRepository extends VPDDataStore with Store {
  final LogService _logger;

  /// Connection state of [device]
  @observable
  late BluetoothConnectionEntity connection;

  @observable
  GreenhouseStateEntity state = const GreenhouseStateEntity.empty();

  late final BluetoothDeviceService _bluetoothDeviceService;

  _GreenhousesRepository({
    required this._logger,
    required BluetoothConfigurationModel config,
    required BluetoothDeviceEntity device,
  }) {
    _bluetoothDeviceService = BluetoothDeviceService(
      logger: _logger,
      config: config,
      device: device.toModel(),
      onConnectionChange: _onConnectionChange,
      onBluetoothData: _onBluetoothData,
    );
  }

  @override
  void dispose() {
    _bluetoothDeviceService.dispose();
  }

  void _onConnectionChange(BluetoothConnectionModel connection) {
    this.connection = BluetoothConnectionEntity.fromModel(connection);
  }

  void _onBluetoothData(BluetoothDataModel? connectionData) {
    if (connectionData == null) {
      state = const GreenhouseStateEntity.empty();
      return;
    }
    try {
      state = GreenhouseStateEntity(data: utf8.decode(connectionData.data));
    } catch (e, s) {
      _logger.logException(e, s);
    }
  }

  void connect() {
    if (connection.state.isConnected) return;
    _bluetoothDeviceService.connect();
  }

  void disconnect() {
    if (connection.state.isDisconnected) return;
    _bluetoothDeviceService.disconnect();
  }

  void turnOnLED() {
    try {
      _bluetoothDeviceService.sendData(
        model: '1',
        encoder: (m) => utf8.encode(m),
      );
    } catch (e, s) {
      _logger.logException(e, s);
    }
  }

  void turnOffLED() {
    try {
      _bluetoothDeviceService.sendData(
        model: '0',
        encoder: (m) => utf8.encode(m),
      );
    } catch (e, s) {
      _logger.logException(e, s);
    }
  }
}
