import 'dart:async';

import 'package:app/services/index.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_utils/shared_utils.dart';

typedef FromCacheFactory<T> = T Function(Map<String, Object?>);
typedef IntMapStore = StoreRef<int, Map<String, Object?>>;

mixin CacheService {
  Database get database;

  FutureOr<void> cleanCache();

  ///  Remove item from [store] by key [item.key] and insert new [item]
  Future<void> addOrUpdateItem<T extends CacheableObject>(
    IntMapStore store,
    T item,
  ) async {
    try {
      await store.record(item.key).delete(database);
      await store.record(item.key).add(database, item.toMap());
    } catch (e, stackTrace) {
      throw CacheServiceException(
        store,
        message: 'Failed to add or update an item in cache',
        origin: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Remove [item] from [store] by key [item.key]
  Future<void> removeItem<T extends CacheableObject>(
    IntMapStore store,
    T item,
  ) async {
    try {
      await store.record(item.key).delete(database);
    } catch (e, stackTrace) {
      throw CacheServiceException(
        store,
        message: 'Failed to remove an item from cache',
        origin: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Remove item from [store] by key [key]
  Future<void> removeItemByKey(IntMapStore store, int key) async {
    try {
      await store.record(key).delete(database);
    } catch (e, stackTrace) {
      throw CacheServiceException(
        store,
        message: 'Failed to remove an item from cache',
        origin: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<List<T>> fetchItems<T extends CacheableObject?>(
    IntMapStore store,
    FromCacheFactory<T> factory, {
    Filter? filter,
    List<SortOrder<Object?>>? sortOrders,
    int? limit,
    int? offset,
    Boundary? start,
    Boundary? end,
  }) async {
    try {
      final records = await store.find(
        database,
        finder: Finder(
          filter: filter,
          sortOrders: sortOrders,
          limit: limit,
          offset: offset,
          start: start,
          end: end,
        ),
      );
      return ListParser.parseIgnoring(
        records,
        (e) => factory((e as RecordSnapshot<int, Map<String, Object?>>).value),
      );
    } catch (e, stackTrace) {
      throw CacheServiceException(
        store,
        message: 'Failed to fetch items from cache',
        origin: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<T?> fetchItemByKey<T extends CacheableObject>(
    int key,
    IntMapStore store,
    FromCacheFactory<T> factory,
  ) async {
    try {
      final record = await store.record(key).get(database);
      return record == null ? null : factory(record);
    } catch (e, stackTrace) {
      throw CacheServiceException(
        store,
        message: 'Failed to fetch item by key from cache',
        origin: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Clears all data in [store] and insert new [items].
  Future<void> updateStore<T extends CacheableObject>(
    IntMapStore store,
    Iterable<T> items,
  ) async {
    try {
      // Clean cache
      await store.delete(database);
      // Add items
      await addAll(store, items);
    } catch (e, stackTrace) {
      throw CacheServiceException(
        store,
        message: 'Failed update store',
        origin: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> addAll<T extends CacheableObject>(
    IntMapStore store,
    Iterable<T> items,
  ) async {
    try {
      await database.transaction((txn) async {
        for (final item in items) {
          await store.record(item.key).add(txn, item.toMap());
        }
      });
    } catch (e, stackTrace) {
      throw CacheServiceException(
        store,
        message: 'Failed to add items in cache',
        origin: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> removeAll<T extends CacheableObject>(
    IntMapStore store,
    Iterable<T> items,
  ) async {
    try {
      await database.transaction((txn) async {
        for (final item in items) {
          await store.record(item.key).delete(txn);
        }
      });
    } catch (e, stackTrace) {
      throw CacheServiceException(
        store,
        message: 'Failed to add items in cache',
        origin: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Clears all data in [store]
  Future<void> cleanStore(StoreRef store) async {
    try {
      await store.delete(database);
    } catch (e, stackTrace) {
      throw CacheServiceException(
        store,
        message: 'Failed to clean store',
        origin: e,
        stackTrace: stackTrace,
      );
    }
  }
}
