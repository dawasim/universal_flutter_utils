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
            message = 'You are not authorized to access';
            showRetry = false;
            break;
/*          case 400:
            final responseData = error.response?.data;
            title = responseData.toString() ?? "Oops!!!";
            try {
              final decodedData = responseData != null ? jsonDecode(responseData) as Map<String, dynamic> : null;
              message = decodedData != null ? getFirstErrorMessage(decodedData) ?? "Something Went Wrong!" : "Something Went Wrong!";
            } catch (e) {
              message = "Invalid error response format!";
            }
            showRetry = false;
            break;*/
          default:
            try {
              print(error.response?.data);
              message = error.response?.data?["message"] ?? 'Server error: HTTP $statusCode';
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

    // Display error using Get.bottomSheet
/*
    await ShowUFUConfirmationDialog(
      title: title,
      subTitle: message,
      suffixBtnText: showRetry ? "Retry" : null,
      onTapSuffix: showRetry ? () {
        Get.back();
        retryCallback();
      } : null,
      onTapPrefix: error.response?.statusCode == 401 ? () async {
        await UFUtils.preferences.clearPref();
        Get.back();
      } : null,
    );
*/

    if (UFUtils.isLoaderVisible()) Get.back();
    if (error.response?.statusCode == 401) {
       await Get.bottomSheet(
        UFUConfirmationDialog(
          title: title,
          subTitle: "Your session has expired! Please login again",
          type: UFUConfirmationDialogType.alert,
          prefixBtnText: "Login",
          prefixBtnColorType: UFUButtonColorType.primary,
          onTapSuffix: () {
            Get.back();
            retryCallback();
          },
          onTapPrefix: () async {
            await UFUtils.preferences.clearPref();
            if (UFUtils.startDestination.isNotEmpty) {
              Get.offAndToNamed(UFUtils.startDestination);
            } else {
              Get.back();
            }
          },
        ),
      );
       handler.reject(error);
    } else {
      UFUToast.showToast(message);
      // Ensure the error is thrown so the calling function can catch it
      handler.reject(error);
      // Future.delayed(const Duration(milliseconds: 1000), () => handler.reject(error));
    }


    // Ensure the error is thrown so the calling function can catch it
    // handler.reject(error);

    // Get.bottomSheet(
    //   UFUConfirmationDialog(
    //     title: title,
    //     subTitle: message,
    //     type: showRetry ? UFUConfirmationDialogType.message : UFUConfirmationDialogType.alert,
    //     suffixBtnText: "Retry",
    //     onTapSuffix: () {
    //       Get.back();
    //       retryCallback();
    //     },
    //     onTapPrefix: error.response?.statusCode == 401 ? () async {
    //       await UFUtils.preferences.clearPref();
    //       Get.back();
    //     } : null,
    //
    //   ),
    //   // _buildErrorBottomSheet(title, message, showRetry, retryCallback),
    //   backgroundColor: AppTheme.themeColors.base,
    //   isScrollControlled: true,
    //   shape: const RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    //   ),
    // );
  }

  String? getFirstErrorMessage(Map<String, dynamic> response) {
    if (response['status'] == 'error' &&
        response['errors'] is List &&
        (response['errors'] as List).isNotEmpty &&
        (response['errors'][0] is Map<String, dynamic>) &&
        response['errors'][0].containsKey('message')) {
      return response['errors'][0]['message'] as String?;
    }
    return response['message'];
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
