

import 'interceptor.dart';

class SocketInterceptorManager {
  final List<SocketInterceptor> _interceptors = [];

  void add(SocketInterceptor interceptor) {
    _interceptors.add(interceptor);
  }

  void clear() {
    _interceptors.clear();
  }

  void onSend(String event, dynamic data) {
    for (final interceptor in _interceptors) {
      interceptor.onSend(event, data);
    }
  }

  void onReceive(String event, dynamic data) {
    for (final interceptor in _interceptors) {
      interceptor.onReceive(event, data);
    }
  }

  void onError(String event, dynamic error) {
    for (final interceptor in _interceptors) {
      interceptor.onError(event, error);
    }
  }
}
