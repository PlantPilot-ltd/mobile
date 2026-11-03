import 'package:flutter_blue_plus/flutter_blue_plus.dart' as bl;

enum BluetoothStateModel {
  unknown,
  unavailable,
  unauthorized,
  turningOn,
  on,
  turningOff,
  off,
}

extension BluetoothStateExtension on BluetoothStateModel {
  static BluetoothStateModel fromBlModel(bl.BluetoothAdapterState model) {
    return switch (model) {
      (bl.BluetoothAdapterState.unknown) => BluetoothStateModel.unknown,
      (bl.BluetoothAdapterState.unavailable) => BluetoothStateModel.unavailable,
      (bl.BluetoothAdapterState.unauthorized) =>
        BluetoothStateModel.unauthorized,
      (bl.BluetoothAdapterState.turningOn) => BluetoothStateModel.turningOn,
      (bl.BluetoothAdapterState.on) => BluetoothStateModel.on,
      (bl.BluetoothAdapterState.turningOff) => BluetoothStateModel.turningOff,
      (bl.BluetoothAdapterState.off) => BluetoothStateModel.off,
    };
  }
}

enum BluetoothScanningStateModel { idle, scanning }

enum BluetoothConnectionStateModel { connecting, disconnected, connected }

extension BluetoothConnectionStateExtension on BluetoothConnectionStateModel {
  static BluetoothConnectionStateModel fromBlModel(
    bl.BluetoothConnectionState model,
  ) {
    return switch (model) {
      bl.BluetoothConnectionState.connected =>
        BluetoothConnectionStateModel.connected,
      _ => BluetoothConnectionStateModel.disconnected,
    };
  }
}
