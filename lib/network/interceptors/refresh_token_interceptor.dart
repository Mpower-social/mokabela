import 'package:dio/dio.dart' as dio;
import 'package:m_survey/network/base_api_provider.dart';
import 'package:m_survey/repository/auth_repository.dart';
class RefreshTokenInterceptor implements dio.InterceptorsWrapper{
  var _dio = dio.Dio();
  @override
  void onError(dio.DioError err, dio.ErrorInterceptorHandler handler) async{
    try{
      AuthRepository authRepository = AuthRepository();
      if(err.response?.statusCode == 403 ||
          err.response?.statusCode == 401){
        var value = await authRepository.refreshTokenOperation();
        if((value??'').isNotEmpty){
          err.requestOptions.headers = {'Authorization':'Bearer $value'};
          final options = new dio.Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
          );
          var req = await this._dio.request(err.requestOptions.path,
              data: err.requestOptions.data,
              queryParameters: err.requestOptions.queryParameters,
              options: options);
          return handler.resolve(req);
        }
      }
    }catch(e){}
    return handler.next(err);
  }

  @override
  Future<void> onRequest(dio.RequestOptions options, dio.RequestInterceptorHandler handler) async {
    return handler.next(options);
  }

  @override
  void onResponse(dio.Response response, dio.ResponseInterceptorHandler handler) {
    return handler.next(response);
  }


}