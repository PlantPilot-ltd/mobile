import 'package:app/presentation/index.dart';
import 'package:core_ui/core_ui.dart';

import 'package:app/presentation/screens/greenhouse_add/greenhouse_add_store.dart';
import 'package:flutter/widgets.dart';

class GreenhouseAddPresenter extends VPDPresenter<GreenhouseAddStore> {
  final AppRouter appRouter;

  final TextEditingController nameController;

  GreenhouseAddPresenter(GreenhouseAddDependencies dependencies)
    : appRouter = dependencies.appRouter,
      nameController = TextEditingController(text: dependencies.device.advName),
      super(dataStore: GreenhouseAddStore(dependencies)) {
    nameController.addListener(_onTextChanged);
  }

  @override
  void initState() {
    super.initState();
    dataStore.fetchData();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void _onTextChanged() => dataStore.changeName(nameController.text);

  void onBackTap() => appRouter.router.pop();

  Future<void> onApplyTap() async {
    final result = await dataStore.addGreenhouse();
    if (result.isSuccess) {
      appRouter.router.goGreenhousesList();
    }
  }
}
