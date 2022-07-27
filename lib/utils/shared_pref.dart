import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  static var userGetStmp = 'userGetTimeStmp';
  static var TOKEN = 'token';
  static var REFRESH_TOKEN = 'refreshToken';
  static var USER_ID = 'userId';
  static var NAME = 'name';
  static var USER_NAME = 'preferred_username';
  static var EMAIL = 'email';
  static var EMAIL_VERIFIED = 'email';
  static var DESIGNATION = 'designation';
  static var ORG_ID = 'org_id';

  static var ALL_FORM_DATE_TIME = 'allFormDateTime';
  static var SUBMITTED_FORM_DATE_TIME = 'submittedFormDateTime';
  static var REVERTED_FORM_DATE_TIME = 'revertedFormDateTime';
  static var PROJECT_DATE_TIME = 'projectDateTime';


  static SharedPreferences? _sharedPreferences;

  static SharedPref sharedPref  = SharedPref();

  init()async{
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }
  Future<void> setString(key,str)async{
    await _sharedPreferences!.setString(key, str);
  }
  Future<String?> getString(key)async{
    return _sharedPreferences!.getString(key);
  }
  Future<void> setBool(key,str)async{
    await _sharedPreferences!.setBool(key, str);
  }
  Future<bool?> getBool(key)async{
    return _sharedPreferences!.getBool(key);
  }

  void clear()async{
    await _sharedPreferences!.clear();
  }
}