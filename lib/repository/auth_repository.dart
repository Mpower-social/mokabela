import 'package:m_survey/models/response/auth_response.dart';
import 'package:m_survey/services/login_services.dart';
import 'package:m_survey/utils/shared_pref.dart';

class AuthRepository{
  final LoginServices _loginServices = LoginServices();

  Future<bool> loginOperation(username,pass)async{
    AuthResponse? loginResponse = await _loginServices.loginOperation(username, pass);
    if(loginResponse!=null){
      var userInfo = await _loginServices.getUserOperation(loginResponse.content?.preferredUsername.toString(),loginResponse.token);
      if(userInfo?.data?.attributes?.organization?.id!=null){
        SharedPref.sharedPref.setString(SharedPref.TOKEN, loginResponse.token);
        SharedPref.sharedPref.setString(SharedPref.NAME, loginResponse.content?.name.toString());
        SharedPref.sharedPref.setString(SharedPref.USER_NAME, loginResponse.content?.preferredUsername.toString());
        SharedPref.sharedPref.setString(SharedPref.EMAIL, loginResponse.content?.email.toString());
        SharedPref.sharedPref.setBool(SharedPref.EMAIL_VERIFIED, loginResponse.content?.emailVerified);
        SharedPref.sharedPref.setString(SharedPref.ORG_ID, userInfo?.data?.attributes?.organization?.id.toString());
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

}