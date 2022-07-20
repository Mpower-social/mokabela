import 'package:dio/dio.dart' as dio;
import 'package:m_survey/network/base_api_provider.dart';
import 'package:m_survey/repository/auth_repository.dart';
class RefreshTokenInterceptor extends BaseApiProvider implements dio.InterceptorsWrapper{
  @override
  void onError(dio.DioError err, dio.ErrorInterceptorHandler handler) {
    AuthRepository authRepository = AuthRepository();
    if(err.response?.statusCode == 403){
      authRepository.refreshTokenOperation()
      .then((value){
        if(value.isNotEmpty){
          err.requestOptions.headers = {'Authorization':'Bearer $value'};
          final options = new dio.Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
          );
          return this.dio.request<dynamic>(err.requestOptions.path,
              data: err.requestOptions.data,
              queryParameters: err.requestOptions.queryParameters,
              options: options);
        }
      });
    }
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