import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:m_survey/utils/check_network_conn.dart';

class NetworkConnectionInterceptor implements dio.InterceptorsWrapper {
  @override
  void onError(dio.DioError err, dio.ErrorInterceptorHandler handler) {
    return handler.next(err);
  }

  @override
  Future<void> onRequest(
      dio.RequestOptions options, dio.RequestInterceptorHandler handler) async {
    if (!await CheckNetwork.checkNetwork.check()) {
      throw NetworkConnException();
    }
    return handler.next(options);
  }

  @override
  void onResponse(
      dio.Response response, dio.ResponseInterceptorHandler handler) {
    return handler.next(response);
  }
}

class NetworkConnException implements dio.DioError {
  @override
  get error => 'no_internet_conn'.tr;

  @override
  late dio.RequestOptions requestOptions;

  @override
  dio.Response? response;

  @override
  StackTrace? stackTrace;

  @override
  dio.DioErrorType type = dio.DioErrorType.cancel;

  @override
  set error(_error) {
    'no_internet_conn'.tr;
  }

  @override
  String get message => 'no_internet_conn'.tr;

  @override
  dio.DioError copyWith({
    dio.RequestOptions? requestOptions,
    dio.Response? response,
    dio.DioErrorType? type,
    Object? error,
    StackTrace? stackTrace,
    String? message,
  }) =>
      dio.DioError(
          requestOptions: requestOptions ?? this.requestOptions,
          response: response ?? this.response,
          type: type ?? this.type,
          error: error ?? this.error,
          stackTrace: stackTrace ?? this.stackTrace,
          message: message ?? this.message);
}
