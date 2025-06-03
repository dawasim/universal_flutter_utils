import 'package:dio/dio.dart';

class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log response details
    print('Response: ${response.statusCode} ${response.data}');
    handler.next(response); // Pass the response to the next handler
  }
}
