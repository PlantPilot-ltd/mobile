import 'package:app/entities/index.dart';
import 'package:app/presentation/index.dart';
import 'package:app/repositories/index.dart';
import 'package:app/services/index.dart';
import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';

part 'greenhouse_add_store.g.dart';

class GreenhouseAddStore = _GreenhouseAddStore with _$GreenhouseAddStore;

abstract class _GreenhouseAddStore extends VPDDataStore with Store {
  final BluetoothDeviceEntity _device;

  final LogService _logger;
  final BluetoothRepository _bluetoothRepository;
  final GreenhousesListRepository _greenhousesRepository;
  final PlantsHttpServiceBase _plantsHttpService;
  final ConfigHttpServiceBase _configHttpService;

  @observable
  late String name = _device.advName;

  @observable
  ControllerConfigEntity? controllerConfig;

  @observable
  bool isLoading = true;

  @observable
  List<PlantEntity> plants = [];

  @observable
  List<PlantEntity> selectedPlants = [];

  @computed
  BluetoothScanResultEntity? get scannedDevice => _bluetoothRepository
      .lastScanResults
      .firstWhereOrNull((e) => e.device.remoteId == _device.remoteId);

  _GreenhouseAddStore(GreenhouseAddDependencies dependencies)
    : _device = dependencies.device,
      _logger = dependencies.logger,
      _bluetoothRepository = dependencies.bluetoothRepository,
      _greenhousesRepository = dependencies.greenhousesRepository,
      _plantsHttpService = dependencies.plantsHttpService,
      _configHttpService = dependencies.configHttpService;

  @action
  Future<void> fetchData() async {
    isLoading = true;
    await Future.wait([_fetchConfig(), _fetchPlants()]);
    isLoading = false;
  }

  @action
  Future<void> _fetchConfig() async {
    final version = _bluetoothRepository.getDeviceVersionFrom(_device);
    final response = await _configHttpService.controllerConfig(version);
    if (response.isFailed) {
      _logger.logException(response.failure!);
    } else {
      controllerConfig = ControllerConfigEntity.fromHttpModel(response.result!);
    }
  }

  @action
  Future<void> _fetchPlants() async {
    final response = await _plantsHttpService.plants();
    if (response.isFailed) {
      _logger.logException(response.failure!);
    } else {
      plants = response.result!.map(PlantEntity.fromHttpModel).toList();
    }
  }

  @action
  void selectPlant(PlantEntity plant) {
    if (controllerConfig == null) {
      return;
    }
    final newPlants = List<PlantEntity>.from(selectedPlants);
    if (newPlants.contains(plant)) {
      newPlants.remove(plant);
    } else {
      if (newPlants.length >= controllerConfig!.plantsCount) {
        return;
      }
      newPlants.add(plant);
    }
    selectedPlants = newPlants;
  }

  @action
  void changeName(String name) {
    this.name = name;
  }

  Future<VoidThrowableResponse> addGreenhouse() {
    return _greenhousesRepository.addGreenhouse(
      GreenhouseEntity(
        remoteId: _device.remoteId,
        name: name,
        plants: selectedPlants,
      ),
    );
  }
}
