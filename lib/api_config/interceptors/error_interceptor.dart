import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _handleError(err, handler, () async {
      // Retry logic: Pass the retry functionality as needed
      // handler.next(err); // Continue with the intercepted error

      try {
        // Retry the request
        final retryResponse = await _retryRequest(err.requestOptions);
        handler.resolve(retryResponse); // Return the successful retry response
      } catch (retryError) {
        handler.next(retryError as DioException); // Pass the error if retry fails
      }
    });
  }

  Future<void> _handleError(DioException error, ErrorInterceptorHandler handler, VoidCallback retryCallback) async {
    print("$error");
    String title = 'an_error_occurred'.tr;
    String message = 'something_went_wrong_try_again'.tr;
    bool showRetry = false;

    // Customize message and actions based on error type
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        title = 'request_timed_out'.tr;
        message = 'it_seems_server_is_taking_too_long'.tr;
        showRetry = false;
        break;
      case DioExceptionType.badResponse:
        // Handle server errors (like 4xx and 5xx)
        final statusCode = error.response?.statusCode ?? 0;
        debugPrint("${error.response?.data}");
        switch (statusCode) {
          case 401:
            title = 'unauthorized_access'.tr;
            message = fetchError(error.response?.data, statusCode);
            showRetry = false;
            break;
          case 400:
            final responseData = error.response?.data;
            title = responseData.toString() ?? "${"oops".tr}!!!";
            try {
              final decodedData = responseData != null
                ? jsonDecode(responseData) as Map<String, dynamic>
                : null;
              message = decodedData != null
                ? getFirstErrorMessage(decodedData,
                    () => fetchError(error.response?.data, statusCode))
                  ?? "something_went_wrong".tr
                : "something_went_wrong".tr;
            } catch (e) {
              message = fetchError(error.response?.data, statusCode);
            }
            showRetry = false;
            break;
          default:
            try {
              print(error.response?.data);
              message = (error.response?.data?["errors"] as List).firstOrNull?["message"]
                ?? error.response?.data?["message"]
                ?? '${"server_error".tr} HTTP $statusCode';
              showRetry = false;
            } catch (e) {
              message = "something_went_wrong".tr;
            }

            break;
        }
        break;
      case DioExceptionType.connectionError:
        message = 'no_internet_connection'.tr;
        break;
      default:
        message = error.message ?? message;
        showRetry = false;
        break;
    }

    if (UFUtils.isLoaderVisible()) Get.back();
    if (error.response?.statusCode == 401) {
      await UFUtils.preferences.clearPref();
      final String mTitle;
      final String errorMessage;
      final String btnText;
      if (message.contains("blocked")) {
        errorMessage = message;
        btnText = "ok".tr;
        mTitle = "account_blocked".tr;
      } else {
        errorMessage = "your_session_has_expired_please_login_again".tr;
        btnText = "login".tr;
        mTitle = title;
      }
      if(UFUtils.isTokenExpiredVisible()) return;

      if(error.response?.realUri.path.contains("logout") ?? false) {
        Get.offAndToNamed(UFUtils.startDestination);
        return;
      }

      await Get.bottomSheet(
        UFUConfirmationDialog(
          key: UFUtils.ufuTokenExpireKey,
          title: mTitle,
          subTitle: errorMessage,
          type: UFUConfirmationDialogType.alert,
          prefixBtnText: btnText,
          prefixBtnColorType: UFUButtonColorType.primary,
          onTapSuffix: () {
            Get.back();
            retryCallback();
          },
          onTapPrefix: () async {
            if (UFUtils.startDestination.isNotEmpty) {
              Get.offAndToNamed(UFUtils.startDestination);
            } else {
              Get.back();
            }
          },
        ),
        isDismissible: false
      );
      handler.reject(error);
    } else {
      UFUToast.showToast(message);
      handler.reject(error);
    }
  }

  String fetchError(dynamic data, int statusCode) {
    try {
      final errors = data?["errors"];
      final message = (errors is List && errors.isNotEmpty && errors.first is Map)
          ? errors.first["message"]
          : data?["message"];

      return message is String ? message : '${"server_error".tr} HTTP $statusCode';
    } catch (_) {
      return "something_went_wrong".tr;
    }
  }


  String? getFirstErrorMessage(
    Map<String, dynamic> response,
    Function() callback,
  ) {
    try {
      if (response['status'] == 'error' &&
          response['errors'] is List &&
          (response['errors'] as List).isNotEmpty &&
          (response['errors'][0] is Map<String, dynamic>) &&
          response['errors'][0].containsKey('message')) {
        return response['errors'][0]['message'] as String?;
      }
      return response['message'];
    } catch (e) {
      callback.call();
    }
  }

  Future<dynamic> _retryRequest(RequestOptions requestOptions) async {
    final dio = Dio(); // Use your Dio instance
    dio.options.headers = requestOptions.headers; // Copy headers
    return await dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
      ),
    );
  }
}
