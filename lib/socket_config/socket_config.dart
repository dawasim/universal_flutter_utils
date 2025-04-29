import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../utils/index.dart';
import 'interceptors/interceptor_manager.dart';
import 'interceptors/logging_interceptor.dart';

class UFSocketConfig {
  static Socket? _socket;
  static final SocketInterceptorManager interceptors = SocketInterceptorManager();

  static Socket? getSocket() => _socket;

  static initializeSocket({Function({required Socket socket, required void Function(String event, Function(dynamic data)) on,})? initListeners}) async {
    if (_socket?.connected == true) {
      _socket?.disconnect();
    }

    final token = await UFUtils.preferences.readAuthToken();
    _socket = io(
        UFUtils.socketBaseUrl,
        OptionBuilder()
            .setTransports(['websocket'])
            .enableReconnection()
            .enableForceNew()
            .setExtraHeaders({'token': token})
            .setQuery({'EIO': '4', 'transport': 'websocket'})
            .build()
    );

    // Add logging interceptor
    interceptors.add(SocketLoggingInterceptor());

    setDefaultListeners();
    listenErrorEvents();

    debugPrint("Connecting socket...");
    _socket!.connect();
    initListeners?.call(socket: _socket!, on: on,);
  }

  static void send(String event, dynamic data) {
    interceptors.onSend(event, data);
    _socket?.emit(event, data);
  }

  static void on(String event, Function(dynamic) callback) {
    _socket?.on(event, (data) {
      interceptors.onReceive(event, data);
      callback(data);
    });
  }

  static void listenErrorEvents() {
    _socket?.onError((error) {
      interceptors.onError('error', error);
    });
    _socket?.onDisconnect((reason) {
      interceptors.onError('disconnect', reason);
    });
  }

  static void setDefaultListeners() {
    _socket?.onConnect((_) {
      debugPrint('🟢 Socket connected successfully.');
    });

    _socket?.onConnectError((data) {
      debugPrint('🔴 Socket connection error: $data');
    });

    _socket?.onDisconnect((data) {
      debugPrint('🔴 Socket disconnected: $data');
    });

    _socket?.onError((data) {
      debugPrint('🔴 Socket error: $data');
    });

    _socket?.onclose((data) {
      debugPrint('🔴 Socket closed: $data');
    });
  }


}
