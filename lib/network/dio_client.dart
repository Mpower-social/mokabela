import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:m_survey/network/apis.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';


const _defaultConnectTimeout = Duration.millisecondsPerMinute;
const _defaultReceiveTimeout = Duration.millisecondsPerMinute;

class DioClient {
  late Dio? clientDio;

  final List<Interceptor>? interceptors;

  DioClient(
    Dio dio, {
    this.interceptors,
  }) {
    clientDio = dio;
    clientDio!
      ..options.baseUrl = Apis.baseUrl
      ..options.connectTimeout = _defaultConnectTimeout
      ..options.receiveTimeout = _defaultReceiveTimeout
      ..httpClientAdapter
      ..options.headers = {'Content-Type': 'application/json; charset=UTF-8'};
    if (interceptors?.isNotEmpty ?? false) {
      clientDio?.interceptors.addAll(interceptors!);
    }
    if (kDebugMode) {
      clientDio?.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90));
    }
  }
}
