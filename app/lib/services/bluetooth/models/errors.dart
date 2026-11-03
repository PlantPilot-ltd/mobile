import 'package:core/core.dart';

class BluetoothNotSupportedError extends AppException {
  const BluetoothNotSupportedError({super.stackTrace, super.origin})
    : super(message: 'Bluetooth not supported by this device');
}

class BluetoothDisabledError extends AppException {
  const BluetoothDisabledError({super.stackTrace, super.origin})
    : super(message: 'Bluetooth is currently disabled');
}

class BluetoothNoConnectionError extends AppException {
  const BluetoothNoConnectionError({super.stackTrace, super.origin})
    : super(message: 'Bluetooth device is not connected');
}

class BluetoothNoCharacteristicError extends AppException {
  final String uuid;
  const BluetoothNoCharacteristicError(
    this.uuid, {
    super.stackTrace,
    super.origin,
  }) : super(
         message:
             'Bluetooth device doesn\'t have the required characteristic with uuid: $uuid',
       );
}
