import 'package:app/services/index.dart';
import 'package:core/core.dart';

abstract class GreenhousesCacheServiceBase extends CacheServiceBase {
  Future<ThrowableResponse<List<GreenhouseCacheModel>>> getGreenhouses();

  Future<VoidThrowableResponse> addGreenhouse(GreenhouseCacheModel model);

  Future<VoidThrowableResponse> removeGreenhouse(GreenhouseCacheModel model);
}
