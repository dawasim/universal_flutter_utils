import 'dart:developer' as developer;

import 'interceptor.dart';

class SocketLoggingInterceptor extends SocketInterceptor {
  @override
  void onSend(String event, dynamic data) {
    developer.log('🔵 [SOCKET SEND] Event: $event | Data: ${data.toString()}');
  }

  @override
  void onReceive(String event, dynamic data) {
    developer.log(
      '🟢 [SOCKET RECEIVE] Event: $event | Data: ${data.toString()}',
    );
  }

  @override
  void onError(String event, dynamic error) {
    developer.log(
      '🔴 [SOCKET ERROR] Event: $event | Error: ${error.toString()}',
    );
  }
}
