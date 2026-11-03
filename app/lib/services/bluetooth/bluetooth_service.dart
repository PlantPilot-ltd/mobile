import 'dart:async';
import 'dart:io';

import 'package:app/services/index.dart';
import 'package:app_settings/app_settings.dart';
import 'package:core/core.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as bl;

class BluetoothService {
  final LogService _logger;

  final BluetoothConfigurationModel config;

  final void Function(BluetoothStateModel) onBluetoothStateChange;
  final void Function(BluetoothScanningStateModel) onScanningStateChange;
  final void Function(List<BluetoothScanResultModel>) onScanResultsChange;

  BluetoothService({
    required this._logger,
    required this.config,
    required this.onBluetoothStateChange,
    required this.onScanningStateChange,
    required this.onScanResultsChange,
  }) {
    _init();
  }

  void _init() {
    _bluetoothStateSubscription = bl.FlutterBluePlus.adapterState.listen(
      _onBluetoothStateChange,
    );
    _scanningStateSubscription = bl.FlutterBluePlus.isScanning.listen(
      _onScanningStateChange,
    );
    _scanResultsSubscription = bl.FlutterBluePlus.scanResults.listen(
      _onScanResultsChange,
    );
    _onBluetoothStateChange(bl.FlutterBluePlus.adapterStateNow);
    _onScanningStateChange(bl.FlutterBluePlus.isScanningNow);
  }

  void dispose() {
    _bluetoothStateSubscription.cancel();
    _scanningStateSubscription.cancel();
    _scanResultsSubscription.cancel();
  }

  ///
  /// Status listeners
  ///

  late final StreamSubscription _bluetoothStateSubscription;
  late final StreamSubscription _scanningStateSubscription;
  late final StreamSubscription _scanResultsSubscription;

  void _onBluetoothStateChange(bl.BluetoothAdapterState state) {
    final newState = BluetoothStateExtension.fromBlModel(state);
    onBluetoothStateChange(newState);
  }

  void _onScanningStateChange(bool state) {
    onScanningStateChange(
      state
          ? BluetoothScanningStateModel.scanning
          : BluetoothScanningStateModel.idle,
    );
  }

  void _onScanResultsChange(List<bl.ScanResult> results) {
    onScanResultsChange(
      results.map(BluetoothScanResultModel.fromBlModel).toList(),
    );
  }

  ///
  /// General bluetooth actions
  ///

  List<BluetoothDeviceModel> getConnectedDevices() {
    return bl.FlutterBluePlus.connectedDevices
        .map(BluetoothDeviceModel.fromBlModel)
        .toList();
  }

  /// Try turn on Bluetooth
  Future<VoidThrowableResponse> tryTurnOnBluetooth() async {
    try {
      final bool isSupported = await bl.FlutterBluePlus.isSupported;
      if (isSupported == false) {
        onBluetoothStateChange(BluetoothStateModel.unknown);
        return _logException(const BluetoothNotSupportedError());
      }

      if (bl.FlutterBluePlus.adapterStateNow == bl.BluetoothAdapterState.on) {
        return const VoidThrowableResponse.success();
      }
      if (Platform.isAndroid) {
        await bl.FlutterBluePlus.turnOn();
      } else {
        AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
      }
    } catch (e, s) {
      return _logException(AppException.fromException(e, s));
    }

    if (bl.FlutterBluePlus.adapterStateNow == bl.BluetoothAdapterState.on) {
      return const VoidThrowableResponse.success();
    } else {
      return _logException(const BluetoothDisabledError());
    }
  }

  /// Start scanning for devices
  VoidThrowableResponse startScanningForDevices() {
    switch (bl.FlutterBluePlus.adapterStateNow) {
      case bl.BluetoothAdapterState.on:
      case bl.BluetoothAdapterState.turningOn:
        break;
      default:
        return _logException(const BluetoothDisabledError());
    }
    try {
      bl.FlutterBluePlus.startScan(withServices: [bl.Guid(config.serviceUUID)]);
      return const VoidThrowableResponse.success();
    } catch (e, s) {
      return _logException(AppException.fromException(e, s));
    }
  }

  /// Stop scanning for devices
  VoidThrowableResponse stopScanningForDevices() {
    try {
      bl.FlutterBluePlus.stopScan();
      return const VoidThrowableResponse.success();
    } catch (e, s) {
      return _logException(AppException.fromException(e, s));
    }
  }

  VoidThrowableResponse _logException(AppException e) {
    _logger.logException(e, e.stackTrace);
    return VoidThrowableResponse.failure(e);
  }
}
