import 'package:app/services/index.dart';
import 'package:core/core.dart';
import 'package:sembast/sembast.dart';

class GreenhousesCacheService extends GreenhousesCacheServiceBase
    with CacheService {
  @override
  final Database database;

  IntMapStore get _listStore => IntMapStore.main();

  GreenhousesCacheService(this.database);

  @override
  Future<void> cleanCache() async {
    await cleanStore(_listStore);
  }

  @override
  Future<ThrowableResponse<List<GreenhouseCacheModel>>> getGreenhouses() async {
    try {
      final result = await fetchItems(_listStore, GreenhouseCacheModel.fromMap);
      return ThrowableResponse.success(result);
    } catch (e, stackTrace) {
      return ThrowableResponse.failure(
        AppException.fromException(e, stackTrace),
      );
    }
  }

  @override
  Future<VoidThrowableResponse> addGreenhouse(
    GreenhouseCacheModel model,
  ) async {
    try {
      await addOrUpdateItem(_listStore, model);
      return const VoidThrowableResponse.success();
    } catch (e, stackTrace) {
      return VoidThrowableResponse.failure(
        AppException.fromException(e, stackTrace),
      );
    }
  }

  @override
  Future<VoidThrowableResponse> removeGreenhouse(
    GreenhouseCacheModel model,
  ) async {
    try {
      await removeItem(_listStore, model);
      return const VoidThrowableResponse.success();
    } catch (e, stackTrace) {
      return VoidThrowableResponse.failure(
        AppException.fromException(e, stackTrace),
      );
    }
  }
}
