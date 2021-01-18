import 'package:sqflite/sqflite.dart';

import '../restaurant_element.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  DatabaseHelper._createObject();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createObject();
    }

    return _databaseHelper;
  }

  static const String _tblFavorite = 'favorite';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/restaurant.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblFavorite (
          id TEXT PRIMARY KEY,
          name TEXT,
          description TEXT,
          pictureId TEXT,
          city TEXT,
          rating DOUBLE
          )''');
      },
      version: 1
    );

    return db;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initializeDb();
    }

    return _database;
  }

  Future<void> insertFavorite(RestaurantElement element) async {
    final db = await database;
    await db.insert(_tblFavorite, element.toJson());
  }

  // Mendapatkan semua data restaurant berkategori favorite
  Future<List<RestaurantElement>> getFavorites() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(_tblFavorite);

    return result.map((res) => RestaurantElement.fromJson(res)).toList();
  }

  // Menunjukan list restaurant favorite berdasarkan restaurant_id
  Future<Map> getFavoriteById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(
      _tblFavorite,
      where: 'id = ?',
      whereArgs: [id]
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  // Me-remove favorite dari list
  Future<void> removeFavorite(String id) async {
    final db = await database;

    await db.delete(
      _tblFavorite,
      where: 'id = ?',
      whereArgs: [id]
    );
  }
}