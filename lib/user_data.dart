/*Database uses singleton design pattern so there will only be 1 local database
  in the application
*/
import 'package:sqflite/sqflite.dart';
import 'package:wifi_scanning_flutter/models/customised_user.dart';

final String tableName = "user_info";
final String columnId = "id";
final String columnState = "infection_state";
final String columnDate = "date";
final String columnTime = "time";
final String columnSsid = "ssid";
final String columnRssi = "rssi";


class UserData {
  static Database _database;
  static UserData _userData;

  Future<Database> get database async {
    if(_database == null) {
      _database = await initialiseDatabase();
    }
    return _database;
  }

  Future<Database> initialiseDatabase() async {
    //get the address of the database
    var dir = await getDatabasesPath();
    var path = dir + "user_data.db";
    
    var database = await openDatabase(path,
        version: 1,
        onCreate: (db, version) {
          db.execute(''' 
          create table $tableName (
          $columnId text primary key autoincrement,
          $columnState integer not null
          )
          ''');
        }
        );

    return database;
  }

  void insertUserInfo(CustomisedUser userInfo) async {
    var db = await this.database;
    var result = db.insert(tableName, userInfo.toMap());
    print('Store Result: $result');
  }

  // Future<List<CustomisedUser>> getUsers() async {
  //   var db = await this.database;
  //   var result = await db.query(tableName);
  //   return result;
  // }
}