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

    //customer table
    await database.execute(
        'CREATE TABLE IF NOT EXISTS $TABLE_NAME_PROJECT ($PROJECT_ID INTEGER PRIMARY KEY,'
            '$PROJECT_NAME TEXT,'
            '$PROJECT_NO_OF_FORMS TEXT,'
            '$PROJECT_START_DATE TEXT,'
            '$PROJECT_END_DATE TEXT,'
            '$PROJECT_STATUS TEXT)',
    );

  }
}