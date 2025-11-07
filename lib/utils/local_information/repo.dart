import 'package:dio/dio.dart';

import '../../api_config/interceptors/error_interceptor.dart';
import '../../api_config/interceptors/request_interceptor.dart';
import '../../api_config/interceptors/response_interceptor.dart';
import '../../models/local_info.dart';

class UFULocalRepo {
  Future<UFULocalInfoModel?> getLocal({Map<String, dynamic>? params}) async {
    try {
      final Dio dio = Dio();

      dio.options
        ..baseUrl = "http://ip-api.com"
        ..connectTimeout = const Duration(seconds: 10)
        ..receiveTimeout = const Duration(seconds: 10);

      // Add interceptors
      dio.interceptors.add(RequestInterceptor());
      dio.interceptors.add(ResponseInterceptor());
      dio.interceptors.add(ErrorInterceptor());

      final uri = Uri.parse("http://ip-api.com/json");

      final response = await dio.getUri(uri);
      if (response.data != null) {
        return UFULocalInfoModel.fromJson(response.data);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

}