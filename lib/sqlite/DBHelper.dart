import 'package:sqflite/sqflite.dart';
import 'package:todolist/model/items.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DbHelper {
  static Database? _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String COMPLATED = 'complated';
  static const String DATE = 'dateCreated';

  static const String TABLE = 'Todo';
  static const String DB_NAME = 'Todo.db';

  Future<Database> initializedDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, DB_NAME),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $NAME TEXT,$COMPLATED BOOLEAN,$DATE DATE)",
        );
      },
    );
  }

  // Future<Database?> get db async {
  //   if (_db != null) {
  //     return _db;
  //   }
  //   _db = await initDb();
  //   return _db;
  // }

  // initDb() async {
  //   //init db
  //   io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
  //   String path = join(documentsDirectory.path, DB_NAME);
  //   var db = await openDatabase(path, version: 1, onCreate: _onCreate);
  //   return db;
  // }

  // _onCreate(Database db, int version) async {
  //   //tạo database
  //   await db.execute(
  //     "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $NAME TEXT,$COMPLATED BOOLEAN,$DATE DATE)",
  //   );
  // }

  // retrieve data
  Future<List<DataItems>> retrievePlanets() async {
    final Database db = await initializedDB();
    final List<Map<String, Object?>> queryResult = await db.query(DB_NAME);
    return queryResult.map((e) => DataItems.fromMap(e)).toList();
  }

// insert data
  Future<int> insertPlanets(List<DataItems> planets) async {
    int result = 0;
    final Database db = await initializedDB();
    for (var planet in planets) {
      result = await db.insert(DB_NAME, planet.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    return result;
  }

  // Future<List<DataItems>> getEmployees() async {
  //   //get list employees đơn giản
  //   var dbClient = await db;
  //   List<Map> maps =
  //       await dbClient!.query(TABLE, columns: [ID, NAME, COMPLATED, DATE]);
  //   //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
  //   List<DataItems> employees = [];
  //   if (maps.isNotEmpty) {
  //     for (int i = 0; i < maps.length; i++) {
  //       employees.add(DataItems.fromMap(maps.first));
  //     }
  //   }
  //   return employees;
  // }

  // Future<DataItems> insert(DataItems todo) async {
  //   todo.id = (await _db.insert(TABLE, todo.toMap())) as String?;
  //   return todo;
  // }

  // Future<DataItems> save(DataItems dataItems) async {
  //   // insert employee vào bảng đơn giản
  //   var dbClient = await db;
  //   dataItems.id =
  //       (await dbClient?.insert(TABLE, dataItems.toMap())) as String?;
  //   return dataItems;
  // }
}
