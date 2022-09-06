import 'package:dio/dio.dart' as dio;
import 'package:m_survey/network/apis.dart';
import 'package:m_survey/repository/auth_repository.dart';
import 'package:m_survey/utils/utils.dart';
class RefreshTokenInterceptor implements dio.InterceptorsWrapper{
  var _dio;
  RefreshTokenInterceptor(this._dio);

  @override
  void onError(dio.DioError err, dio.ErrorInterceptorHandler handler) async{
    print(Apis.refreshToken.toString().trim()==err.requestOptions.uri.toString().trim());
    try{

      AuthRepository authRepository = AuthRepository();
      if((err.response?.statusCode == 403 ||
          err.response?.statusCode == 401)
      ){
        if(err.requestOptions.uri.toString().trim()==Apis.refreshToken.toString().trim()){
          Utils.logoutOperation();
        }else{
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
            print('returned');
            return handler.resolve(req);
          }
        }
      }
    }catch(e){Utils.logoutOperation();}
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