import 'package:sembast/sembast.dart';
import 'package:wifi_scanning_flutter/models/customised_result.dart';

import 'app_database.dart';

class ResultDao {
  static const String RESULT_DATABASE_NAME = "result_list";

  final _resultStore = intMapStoreFactory.store(RESULT_DATABASE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(CustomisedResult result) async {
    await _resultStore.add(await _db, result.toMap());
  }

  Future deleteAll() async {
    await _resultStore.delete(await _db);
  }

  Future<List<CustomisedResult>> getAllSortedBy(String field) async {
    final finder = Finder(sortOrders: [
      SortOrder(field)
    ]);
    final recordSnapShots = await _resultStore.find(
      await _db,
      finder : finder,
    );

    return recordSnapShots.map((snapshot) {
      final result = CustomisedResult.fromMap(snapshot.value);
      print(snapshot.key);
      return result;
    }).toList();
  }
}