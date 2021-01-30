import 'package:sembast/sembast.dart';
import 'package:wifi_scanning_flutter/data/app_database.dart';
import 'package:wifi_scanning_flutter/models/customised_user.dart';

class UserDao {
  static const String USER_STORE_NAME = "user_info";

  final _userStore = intMapStoreFactory.store(USER_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(CustomisedUser user) async {
    await _userStore.add(await _db, user.toMap());
  }

  Future update(CustomisedUser user) async {
    final finder = Finder(filter: Filter.byKey(user.uid));
    await _userStore.update(
        await _db,
        user.toMap(),
        finder: finder
    );

    Future delete(CustomisedUser user) async {
      final finder = Finder(filter: Filter.byKey(user.uid));
      await _userStore.delete(
        await _db,
        finder: finder
      );
    }
  }

}