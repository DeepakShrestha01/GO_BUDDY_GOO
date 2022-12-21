import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../configs/backendUrl.dart';

class DioHttpService {
  Dio getDioClient() {
    Dio dio =
        Dio(BaseOptions(baseUrl: backendServerUrl, connectTimeout: 20 * 1000));
    dio.interceptors.add(
      PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true),
    );
    return dio;
  }

  Future<Response> handleGetRequest(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    Dio dio = getDioClient();
    try {
      return await dio.get(
        path,
        options: options,
        cancelToken: cancelToken,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.other) {
        // showToast(text: "No internet connection.", time: 10);
        Get.offNamedUntil('/errorPage', (route) => false);
      }
      return Response(
        data: {
          'status': e.error,
          'message': e.message,
          'data': e.response?.data,
        },
        statusCode: e.response?.statusCode,
        requestOptions: RequestOptions(path: path),
      );
    }
  }

  Future<Response> handlePostRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    Dio dio = getDioClient();
    try {
      return await dio.post(
        path,
        data: data,
        options: options,
        cancelToken: cancelToken,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.other) {
        Get.offNamedUntil('/errorPage', (route) => false);

        // showToast(text: "No internet connection.", time: 10);
      }
      return Response(
        data: {
          "status": e.error,
          'message': e.message,
          'data': e.response?.data,
        },
        requestOptions: RequestOptions(path: path),
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<Response> handlePuttRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    Dio dio = getDioClient();
    try {
      return await dio.put(
        path,
        data: data,
        options: options,
        cancelToken: cancelToken,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.other) {
        // showToast(text: "No internet connection.", time: 10);
        Get.offNamedUntil('/errorPage', (route) => false);
      }
      return Response(
        data: {
          "status": e.error,
          'message': e.message,
          'data': e.response?.data,
        },
        requestOptions: RequestOptions(path: path),
        statusCode: e.response?.statusCode,
      );
    }
  }
}
