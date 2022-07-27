import 'package:m_survey/constans/table_column.dart';
import 'package:sqflite/sqflite.dart';

int dbVersion = 1;
class DatabaseProvider{
  static final DatabaseProvider dbProvider = DatabaseProvider();
  Database? _database;
  Future<Database?> get database async{
    if(_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async{
    return await openDatabase(
      'mSurvey.db',
      version: dbVersion,
      onCreate: initDb,
      onUpgrade:onUpgrade
    );
  }

  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {
    }
  }


  void initDb(Database database,int version) async{

    //project list table
    await database.execute(
        'CREATE TABLE IF NOT EXISTS $TABLE_NAME_PROJECT ($PROJECT_ID INTEGER PRIMARY KEY,'
            '$PROJECT_NAME TEXT,'
            '$PROJECT_NO_OF_FORMS TEXT,'
            '$PROJECT_START_DATE TEXT,'
            '$PROJECT_END_DATE TEXT,'
            '$PROJECT_STATUS TEXT)',
    );

    //submitted form table
    await database.execute(
      'CREATE TABLE IF NOT EXISTS $TABLE_NAME_SUBMITTED_FORM ($SUBMITTED_ID INTEGER PRIMARY KEY,'
          '$SUBMITTED_FORM_NAME TEXT,'
          '$SUBMITTED_FORM_ID_STRING TEXT,'
          '$SUBMITTED_PROJECT_ID INTEGER,'
          '$SUBMITTED_DATE_CREATED TEXT,'
          '$SUBMITTED_BY_ID INTEGER,'
          '$SUBMITTED_BY_USERNAME TEXT,'
          '$SUBMITTED_BY_FIRST_NAME TEXT,'
          '$SUBMITTED_BY_LAST_NAME TEXT,'
          '$SUBMITTED_XML TEXT)',
    );


    //all form table
    await database.execute(
      'CREATE TABLE IF NOT EXISTS $TABLE_NAME_All_FORM ($All_FORM_ID INTEGER PRIMARY KEY,'
          '$All_FORM_X_FORM_ID TEXT,'
          '$All_FORM_TITLE TEXT,'
          '$All_FORM_ID_STRING TEXT,'
          '$All_FORM_CREATED_AT TEXT,'
          '$All_FORM_TARGET INTEGER,'
          '$All_FORM_PROJECT_ID INTEGER,'
          '$All_FORM_PROJECT_NAME TEXT,'
          '$All_FORM_STATUS TEXT,'
          '$All_FORM_PROJECT_DES TEXT)',
    );

    //deleted submitted form table
    await database.execute(
      'CREATE TABLE IF NOT EXISTS $TABLE_NAME_DELETED_SUBMITTED_FORM ($DELETED_SUBMITTED_FORM_ID INTEGER PRIMARY KEY)',
    );

    //reverted form table
    await database.execute(
      'CREATE TABLE IF NOT EXISTS $TABLE_NAME_REVERTED_FORM ($REVERTED_FORM_ID INTEGER PRIMARY KEY,'
          '$REVERTED_FORM_PROJECT_ID INTEGER,'
          '$REVERTED_FORM_INSTANCE_ID TEXT,'
          '$REVERTED_FORM_FEEDBACK TEXT,'
          '$REVERTED_FORM_CREATED_AT TEXT,'
          '$REVERTED_FORM_UPDATED_AT TEXT)',
    );
  }
}