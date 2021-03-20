import 'package:sqflite/sqflite.dart';
import 'package:submission1_fundamental/data/remote/response/restaurant_response.dart';

class DatabaseHelper {
  static Database _database;
  static DatabaseHelper _databaseHelper;
  String _tableName = "restaurants";

  DatabaseHelper._createDatabase();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createDatabase();
    }

    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      var path = await getDatabasesPath();
      _database = await openDatabase("$path/restaurant_db.db",
          onCreate: (db, version) async {
        await db.execute(''' CREATE TABLE $_tableName (
              id TEXT PRIMARY KEY,
              name TEXT,
              description TEXT,
              pictureId TEXT,
              city TEXT,
              rating REAL
            )''');
      }, version: 1);
    }

    return _database;
  }

  Future<void> insertRestaurant(Restaurants restaurants) async {
    final db = await database;
    await db.insert(_tableName, restaurants.toJson());
  }

  Future<List<Restaurants>> getRestaurants() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(_tableName);

    return result.map((e) => Restaurants.fromJson(e)).toList();
  }

  Future<Restaurants> getRestaurant(String id) async {
    final db = await database;
    List<Map<String, dynamic>> result =
        await db.query(_tableName, where: 'id = ?', whereArgs: [id]);

    return result.map((e) => Restaurants.fromJson(e)).first;
  }

  Future<void> deleteRestaurant(String id) async {
    final db = await database;

    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
