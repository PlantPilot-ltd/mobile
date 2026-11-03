import 'package:app/entities/index.dart';
import 'package:app/services/index.dart';
import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';

part 'greenhouses_list_repository.g.dart';

class GreenhousesListRepository = _GreenhousesListRepository
    with _$GreenhousesListRepository;

abstract class _GreenhousesListRepository extends VPDDataStore with Store {
  final LogService _logger;
  final GreenhousesCacheServiceBase _cacheService;

  @observable
  bool isLoading = true;

  @observable
  List<GreenhouseEntity> greenhouses = [];

  _GreenhousesListRepository({
    required this._logger,
    required this._cacheService,
  });

  @action
  Future<void> fetchData() async {
    isLoading = true;
    await _fetchLocalData();
    isLoading = false;
  }

  @action
  Future<void> _fetchLocalData() async {
    final result = await _cacheService.getGreenhouses();
    if (result.failure != null) {
      _logger.logException(result.failure!);
      return;
    }
    transaction(() {
      greenhouses = result.result!.map(GreenhouseEntity.fromCache).toList();
    });
  }

  @action
  Future<VoidThrowableResponse> addGreenhouse(
    GreenhouseEntity greenhouse,
  ) async {
    final result = await _cacheService.addGreenhouse(greenhouse.toCache());
    if (result.isFailed) _logger.logException(result.failure!);
    greenhouses = [...greenhouses, greenhouse];
    return const VoidThrowableResponse.success();
  }
}
