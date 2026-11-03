import 'package:core/core.dart';
import 'package:sembast/sembast.dart';

class CacheServiceException extends AppException {
  final StoreRef store;

  const CacheServiceException(
    this.store, {
    super.message,
    super.origin,
    super.stackTrace,
  });

  @override
  String toString() => '${super.toString()}\nStore box: ${store.name}';
}
