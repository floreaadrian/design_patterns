import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;

class DBCreator {
  static const itemTable = 'facts';
  static const id = 'id';
  static const String fact = 'fact';

  DBCreator._privateConstructor() {}

  static final DBCreator instance = DBCreator._privateConstructor();

  Future<void> createItemTable(Database db) async {
    final createSql = '''CREATE TABLE $itemTable 
    (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $fact TEXT
    )''';
    await db.execute(createSql);
  }

  Future<String> getDBPath(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    if (await Directory(dirname(path)).exists()) {
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initDB() async {
    final path = await getDBPath('facts_db');
    db = await openDatabase(path, version: 1, onCreate: onCreate);
    print(db);
  }

  Future<void> onCreate(Database db, int version) async {
    await createItemTable(db);
  }
}
