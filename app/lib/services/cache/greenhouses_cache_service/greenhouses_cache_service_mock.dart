import 'package:app/services/index.dart';
import 'package:core/core.dart';

class GreenhousesCacheServiceMock extends GreenhousesCacheServiceBase {
  final List<GreenhouseCacheModel> _list = [];

  GreenhousesCacheServiceMock();

  @override
  Future<void> cleanCache() async {
    _list.clear();
  }

  @override
  Future<ThrowableResponse<List<GreenhouseCacheModel>>> getGreenhouses() =>
      Future.syncValue(ThrowableResponse.success(_list));

  @override
  Future<VoidThrowableResponse> addGreenhouse(
    GreenhouseCacheModel model,
  ) async {
    _list.add(model);
    return const VoidThrowableResponse.success();
  }

  @override
  Future<VoidThrowableResponse> removeGreenhouse(
    GreenhouseCacheModel model,
  ) async {
    _list.remove(model);
    return const VoidThrowableResponse.success();
  }
}
