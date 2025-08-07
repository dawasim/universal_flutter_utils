import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log response details
    debugPrint('Response: ${response.statusCode} ${response.data}');
    handler.next(response); // Pass the response to the next handler
  }
}
