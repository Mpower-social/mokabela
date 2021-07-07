import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null)
      return _database!;
    else
      _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'app_builder.db');
    return await openDatabase(path, version: 1);
  }

  Future createTable({required String query}) async {
    Database db = await instance.database;
    db.execute(query);
  }
}
