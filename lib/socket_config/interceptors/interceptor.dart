abstract class SocketInterceptor {
  void onSend(String event, dynamic data) {}
  void onReceive(String event, dynamic data) {}
  void onError(String event, dynamic error) {}
}