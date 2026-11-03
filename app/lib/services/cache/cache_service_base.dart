import 'dart:async';

abstract class CacheServiceBase {
  const CacheServiceBase();

  FutureOr<void> cleanCache();
}
