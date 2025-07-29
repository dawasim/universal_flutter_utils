
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

import '../AESUtil.dart';

class RequestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Check internet connection
    bool isConnected = await _checkInternetConnection();
    if (!isConnected) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'No Internet connection',
          type: DioExceptionType.connectionError,
        ),
      );
    }

    // Check if this request should skip the interceptor
    if (options.extra["skipInterceptor"] == true) {
      return handler.next(options); // Skip interceptor
    } else if (options.extra["header"] != null) {
      debugPrint('Request: ${options.method} ${options.path}');
      options.headers = options.extra["header"];
      options.extra = {};
      debugPrint('header: ${options.headers}');
      return handler.next(options); // Skip interceptor
    } else {
      String? token = await UFUtils.preferences.readAuthToken();
      options.headers = AESUtil.secKeyEncryptWithHeaderAppKey(token);
      debugPrint('Request: ${options.method} ${options.path}');
      return handler.next(options);
    }
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
