import 'dart:io';
import 'package:dio/dio.dart';
import 'package:m_survey/utils/utils.dart';

class DioException {
  static String getDioException(error) {
    if (error is Exception) {
      try {
        if (error is DioError) {
          switch (error.type) {
            case DioErrorType.cancel:
            case DioErrorType.connectTimeout:
            case DioErrorType.other:
            if (DioErrorType.other is SocketException) {
              return "Cant connect to Server. Please check your Internet connectivity";
            }
            return "Something went wrong. Please try again";
            case DioErrorType.receiveTimeout:
            case DioErrorType.sendTimeout:
              return "Something went wrong. Please try again";
            case DioErrorType.response:
              switch (error.response?.statusCode) {
                case 400:

                  if((error.response?.data["data"]??'').toString().trim() == 'TokenExpiredError: jwt expired'.trim()){
                    Utils.logoutOperation();
                    return "Token expired. Login Again.";
                  }else{
                      return error.response?.data["data"]??error.response?.data["message"]??error.response?.data["details"]??"";
                  }
                case 401:
                  //Utils.logoutOperation();
                  return "Email or password wrong.Try again.";
                case 403:
                  Utils.logoutOperation();
                  return "Token expired. Login Again.";
                case 404:
                case 409:
                case 408:
                case 500:
                case 503:
                  return "Something went wrong. Please try again";
                default:
                  var responseCode = error.response?.statusCode;
                  return "Received invalid status code: $responseCode";
              }
          }
        }
        else if (error is SocketException) {
          return "Cant connect to Server. Please check your Internet connectivity";
        }
        else {
          return "Something went wrong. Please try again";
        }
      } on FormatException {
        return "Something went wrong. Please try again";
      } catch (_) {
        return "Something went wrong. Please try again";
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        return "Something went wrong. Please try again";
      } else {
        return "Something went wrong. Please try again";
      }
    }
  }
}
