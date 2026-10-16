import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shopsphere/core/network/api_endpoints.dart';

/// Builds the single [Dio] instance used by every remote data source.
abstract final class DioClient {
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  static Dio create({List<Interceptor> interceptors = const []}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        contentType: Headers.jsonContentType,
      ),
    );

    dio.interceptors.addAll(interceptors);

    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(requestBody: true));
    }

    return dio;
  }
}
