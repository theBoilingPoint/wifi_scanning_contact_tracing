import 'package:sembast/sembast.dart';
import 'package:wifi_scanning_flutter/services/app_database.dart';
import 'package:wifi_scanning_flutter/models/customised_wifi.dart';

class WifiDao {
  static const String WIFI_DATABASE_NAME = "wifi_list";

  final _wifiStore = intMapStoreFactory.store(WIFI_DATABASE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(CustomisedWifi wifi) async {
    await _wifiStore.add(await _db, wifi.toMap());
  }

  Future update(CustomisedWifi wifi) async {
    final finder = Finder(filter: Filter.byKey(wifi.ssid));
    await _wifiStore.update(
        await _db,
        wifi.toMap(),
        finder: finder
    );
  }

  Future deleteByDatetime(CustomisedWifi wifi) async {
    final finder = Finder(filter: Filter.byKey(wifi.dateTime));
    await _wifiStore.delete(
        await _db,
        finder: finder
    );
  }

  //Delete everything in the database
  Future deleteAll() async {
    await _wifiStore.delete(await _db);
  }

  Future<List<CustomisedWifi>> getAllSortedBy(String field) async {
    final finder = Finder(sortOrders: [
      SortOrder(field)
    ]);
    final recordSnapShots = await _wifiStore.find(
      await _db,
      finder : finder,
    );

    return recordSnapShots.map((snapshot) {
      final wifi = CustomisedWifi.fromMap(snapshot.value);
      print(snapshot.key);
      return wifi;
    }).toList();
  }

  Future<List<CustomisedWifi>> getScansWithin7Days() async {
    String lowerBound = DateTime.now().add(Duration(days: -7)).toString();
    final finder = Finder(
        filter: Filter.greaterThanOrEquals("dateTime", lowerBound)
    );

    final recordSnapShots = await _wifiStore.find(
      await _db,
      finder : finder,
    );

    return recordSnapShots.map((snapshot) {
      final wifi = CustomisedWifi.fromMap(snapshot.value);
      print(snapshot.key);
      return wifi;
    }).toList();
  }
}