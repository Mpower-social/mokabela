import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const String DATABASE_NAME = "app_builder.db";
const String TABLE_NAME_USER = "User";
const String TABLE_NAME_APP_LOG = "AppLog";
const String TABLE_NAME_FORM_ITEM = "FormItem";
const String TABLE_NAME_LIST_ITEM = "ListItem";
const String TABLE_NAME_DATA_ITEM = "DataItem";
const String TABLE_NAME_CATCHMENT = "catchment";
const String TABLE_NAME_MODULE_ITEM = "ModuleItem";

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
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, DATABASE_NAME);
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
    );
  }

  Future createTable({required String query}) async {
    Database db = await instance.database;
    db.execute(query);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $TABLE_NAME_APP_LOG(time INTEGER)',
    );

    await db.execute(
      'CREATE TABLE $TABLE_NAME_USER( user_id INTEGER PRIMARY KEY, username TEXT NOT NULL, pass TEXT NOT NULL)',
    );

    await db.execute(
      'CREATE TABLE $TABLE_NAME_MODULE_ITEM( app_id INTEGER PRIMARY KEY, app_name TEXT NOT NULL, definition TEXT NOT NULL)',
    );

    await db.execute(
      'CREATE TABLE $TABLE_NAME_FORM_ITEM( id INTEGER PRIMARY KEY, name TEXT NOT NULL, form_definition TEXT NOT NULL, choice_list TEXT, form_uuid TEXT, table_mapping TEXT, field_names TEXT )',
    );

    await db.execute(
      'CREATE TABLE $TABLE_NAME_LIST_ITEM( id INTEGER PRIMARY KEY, list_name TEXT NOT NULL, list_header TEXT, datasource TEXT, filter_definition TEXT, column_definition TEXT)',
    );

    await db.execute(
      'CREATE TABLE $TABLE_NAME_CATCHMENT( id INTEGER PRIMARY KEY, division TEXT, division_label TEXT, district TEXT, dist_label TEXT, upazila TEXT, upazila_label TEXT)',
    );

    await db.execute(
      'CREATE TABLE $TABLE_NAME_DATA_ITEM( id INTEGER PRIMARY KEY, xform_id INTEGER NOT NULL, json TEXT NOT NULL, xml TEXT, status INTEGER, updated_at INTEGER)',
    );
  }
}
