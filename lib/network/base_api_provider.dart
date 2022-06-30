import 'package:dio/dio.dart';
import 'dio_client.dart';

class BaseApiProvider {
  late DioClient _dioClient;

  BaseApiProvider() {
    var dio = Dio();
    _dioClient = DioClient(dio);
  }

  Dio get dio => _dioClient.clientDio!;
}
