import 'dart:io';

import 'package:app/services/index.dart';
import 'package:core/core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

final class AppCacheProvider {
  final Database _database;

  final GreenhousesCacheServiceBase greenhouses;

  const AppCacheProvider._(this._database, {required this.greenhouses});

  static Future<AppCacheProvider> fromEnvironment(EnvironmentType? envType) =>
      switch (envType) {
        .production => AppCacheProvider.prod(),
        .development => AppCacheProvider.dev(),
        .mock => Future.sync(() => AppCacheProvider.mock()),
        _ => AppCacheProvider.dev(),
      };

  static Future<AppCacheProvider> mock() async => AppCacheProvider._(
    await _createDatabase('plantpilot_mock.db'),
    greenhouses: GreenhousesCacheServiceMock(),
  );

  static Future<AppCacheProvider> dev() async {
    final db = await _createDatabase('plantpilot_dev.db');
    return AppCacheProvider._(db, greenhouses: GreenhousesCacheService(db));
  }

  static Future<AppCacheProvider> prod() async {
    final db = await _createDatabase('plantpilot.db');
    return AppCacheProvider._(db, greenhouses: GreenhousesCacheService(db));
  }

  static Future<Database> _createDatabase(String name) async {
    final directory = await getApplicationDocumentsDirectory();
    await directory.create(recursive: true);
    final dbPath = '${directory.path}${Platform.pathSeparator}$name';
    return databaseFactoryIo.openDatabase(dbPath);
  }

  void cleanAllCache() {
    greenhouses.cleanCache();
  }

  void dispose() {
    _database.close();
  }
}
