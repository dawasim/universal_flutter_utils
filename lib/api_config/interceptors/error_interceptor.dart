import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

import 'retry.dart';

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
        handler
            .next(retryError as DioException); // Pass the error if retry fails
      }
    });
  }

  Future<void> _handleError(DioException error, ErrorInterceptorHandler handler,
      VoidCallback retryCallback) async {
    print("$error");
    String title = 'An Error Occurred';
    String message = 'Something went wrong. Please try again.';
    bool showRetry = false;

    // Customize message and actions based on error type
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        title = 'Request Timed Out';
        message = 'It seems the server is taking too long to respond.';
        showRetry = false;
        break;
      case DioExceptionType.badResponse:
      // Handle server errors (like 4xx and 5xx)
        final statusCode = error.response?.statusCode ?? 0;
        debugPrint("${error.response?.data}");
        switch (statusCode) {
          case 401:
            title = 'Unauthrizer Access';
            message = fetchError(error.response?.data, statusCode);
            showRetry = false;
            break;
          case 400:
            final responseData = error.response?.data;
            title = responseData.toString() ?? "Oops!!!";
            try {
              final decodedData = responseData != null
                  ? jsonDecode(responseData) as Map<String, dynamic>
                  : null;
              message = decodedData != null
                  ? getFirstErrorMessage(decodedData,
                      () => fetchError(error.response?.data, statusCode)) ??
                  "Something Went Wrong!"
                  : "Something Went Wrong!";
            } catch (e) {
              message = fetchError(error.response?.data, statusCode);
            }
            showRetry = false;
            break;
          default:
            try {
              print(error.response?.data);
              message = (error.response?.data?["errors"] as List)
                  .firstOrNull?["message"] ??
                  error.response?.data?["message"] ??
                  'Server error: HTTP $statusCode';
              showRetry = false;
            } catch (e) {
              message = "Something went wrong!";
            }

            break;
        }
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection.';
        break;
      default:
        message = error.message ?? message;
        showRetry = false;
        break;
    }

    if (UFUtils.isLoaderVisible()) Get.back();
    if (error.response?.statusCode == 401) {

      // if (UFUtils.refreshToken != null) {
      //   Retry.execute(() => UFUtils.refreshToken?.call(), delay: const Duration(seconds: 4));
      //   // await UFUtils.refreshToken?.call();
      //   Get.offAndToNamed(UFUtils.refreshDestination);
      // } else {
      //   await showSessionTimeoutError(
      //     message: message,
      //     title: title,
      //     error: error,
      //     retryCallback: retryCallback);
      // }
      handler.reject(error);
    } else {
      UFUToast.showToast(message);
      handler.reject(error);
    }
  }

  String fetchError(dynamic data, int statusCode) {
    try {
      final errors = data?["errors"];
      final message =
      (errors is List && errors.isNotEmpty && errors.first is Map)
          ? errors.first["message"]
          : data?["message"];

      return message is String ? message : 'Server error: HTTP $statusCode';
    } catch (_) {
      return "Something went wrong!";
    }
  }

  String? getFirstErrorMessage(Map<String, dynamic> response,
      Function() callback,) {
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

  bool isManageTokenAPI(String path) {
    final hasPath = path.contains("manageSession");
    print("Path -------- $hasPath");

    return path.contains("manageSession");
  }

  Future<void> showSessionTimeoutError({
    required String message,
    required String title,
    required DioException error,
    required VoidCallback retryCallback,
  }) async {
    await UFUtils.preferences.clearPref();
    final String mTitle;
    final String errorMessage;
    final String btnText;
    if (message.contains("blocked")) {
      errorMessage = message;
      btnText = "Ok";
      mTitle = "Account Blocked";
    } else {
      errorMessage = "Your session has expired! Please login again";
      btnText = "Login";
      mTitle = title;
    }
    if (UFUtils.isTokenExpiredVisible()) return;

    if (error.response?.realUri.path.contains("logout") ?? false) {
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
        isDismissible: false);
  }
}
