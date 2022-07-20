import 'dart:convert';
import 'package:m_survey/models/response/auth_response.dart';
import 'package:m_survey/models/response/user_info_response.dart';
import 'package:m_survey/network/dio_exception.dart';
import 'package:m_survey/widgets/show_toast.dart';
import '../network/apis.dart';
import '../network/base_api_provider.dart';

class AuthServices extends BaseApiProvider{
  ///login operation
  Future<AuthResponse?> loginOperation(username,pass) async {
    try{
      var response = await dio.post(Apis.login,
          data: jsonEncode({"username": username, "password": pass}));
        return AuthResponse.fromJson(response.data);
    }catch(error){
      showToast(msg:DioException.getDioException(error),isError: true);
    }
    return null;
  }

  ///user information by username
  Future<UserInfoResponse?> getUserOperation(username,token) async {
    try{
      dio.options.headers.addAll({'Authorization':'Bearer $token'});
      var response = await dio.get(Apis.getUserByUserName(username));
      return UserInfoResponse.fromJson(response.data);
    }catch(error){
      showToast(msg:DioException.getDioException(error),isError: true);
    }
    return null;
  }


  ///refresh token operation
  Future<AuthResponse?> refreshToken(refreshToken) async {
    try{
      var response = await dio.post(Apis.refreshToken, data: ({"refreshToken":refreshToken}));
      return AuthResponse.fromJson(response.data);
    }catch(error){
      showToast(msg:DioException.getDioException(error),isError: true);
    }
    return null;
  }


}