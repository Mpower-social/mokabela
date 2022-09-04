import 'package:dio/dio.dart';
import 'package:m_survey/network/interceptors/refresh_token_interceptor.dart';
import 'dio_client.dart';

class BaseApiProvider {
  late DioClient _dioClient;

  BaseApiProvider() {
    var dio = Dio();
    _dioClient = DioClient(dio,interceptors: [RefreshTokenInterceptor(dio)]);
  }

  Dio get dio => _dioClient.clientDio!;
}
