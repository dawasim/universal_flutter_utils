import 'dart:async';
import 'dart:convert';
import 'dart:io' as dart_io;

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../utils/index.dart';
import 'interceptors/interceptor_manager.dart';
import 'interceptors/logging_interceptor.dart';

/// Socket.IO client used by apps via:
/// ```dart
/// final socket = await UFSocket.initialize();
/// socket.listen('event_name', (data) { ... }, (error) { ... });
/// socket.emit('event_name', payload, (response) { ... }, (error) { ... });
/// ```
class UFSocket {
  UFSocket._();

  static UFSocket? _instance;
  static Socket? _socket;
  static _PollingClient? _polling;

  static final SocketInterceptorManager interceptors =
      SocketInterceptorManager();
  static bool _loggingAttached = false;

  final Map<String, StreamController<dynamic>> _listeners = {};

  bool get isConnected => _polling?.isConnected == true;

  static Socket? get rawSocket => _socket;

  static ({String origin, String namespace}) _socketTarget() {
    final raw = UFUtils.socketBaseUrl.trim();
    final uri = Uri.parse(raw);
    final origin = uri.origin;
    var namespace = uri.path;
    if (namespace.isEmpty || namespace == '/') {
      namespace = '/';
    } else if (namespace.endsWith('/')) {
      namespace = namespace.substring(0, namespace.length - 1);
    }
    if (!namespace.startsWith('/')) {
      namespace = '/$namespace';
    }
    return (origin: origin, namespace: namespace);
  }

  static Future<UFSocket> initialize() async {
    _instance ??= UFSocket._();

    if (_polling?.isConnected == true) {
      return _instance!;
    }

    _polling?.dispose();
    _polling = null;
    _socket?.dispose();
    _socket = null;

    final token = await UFUtils.preferences.readAuthToken();
    final target = _socketTarget();

    debugPrint('Connecting socket...');
    debugPrint('Socket URL: ${target.origin}');
    debugPrint('Socket namespace: ${target.namespace}');
    debugPrint('Socket transport: polling');
    debugPrint('Socket path: /socket.io/');
    debugPrint(
      'Socket authentication configured: ${token.isNotEmpty}',
    );

    if (!_loggingAttached) {
      interceptors.add(SocketLoggingInterceptor());
      _loggingAttached = true;
    }

    final polling = _PollingClient(
      origin: target.origin,
      namespace: target.namespace,
      token: token,
      onEvent: _instance!._dispatchEvent,
      onError: _instance!._onTransportError,
      onConnect: () {
        debugPrint('🟢 Socket connected successfully.');
      },
      onDisconnect: (reason) {
        debugPrint('🔴 Socket disconnected: $reason');
        interceptors.onError('disconnect', reason);
      },
    );
    _polling = polling;

    try {
      await polling.connect().timeout(const Duration(seconds: 20));
    } catch (error) {
      debugPrint('🔴 Socket connection error: $error');
      interceptors.onError('connect_error', error);
      polling.dispose();
      if (identical(_polling, polling)) {
        _polling = null;
      }
      rethrow;
    }

    return _instance!;
  }

  void _dispatchEvent(String event, dynamic data) {
    interceptors.onReceive(event, data);
    final controller = _listeners[event];
    if (controller != null && !controller.isClosed) {
      controller.add(data);
    }
  }

  void _onTransportError(dynamic error) {
    debugPrint('🔴 Socket error: $error');
    interceptors.onError('error', error);
    _addErrorToListeners(error);
  }

  void _addErrorToListeners(dynamic error) {
    for (final controller in _listeners.values) {
      if (!controller.isClosed) controller.addError(error);
    }
  }

  Stream<dynamic> listen({
    required String event,
    void Function(dynamic data)? onData,
    void Function(dynamic error)? onError,
  }) {
    final controller = _listeners.putIfAbsent(
      event,
      () => StreamController<dynamic>.broadcast(),
    );

    if (onData != null || onError != null) {
      controller.stream.listen(
        onData,
        onError: onError == null ? null : (Object e, StackTrace _) => onError(e),
      );
    }

    return controller.stream;
  }

  void emit({
    required String event,
    dynamic? data,
    void Function(dynamic response)? onResponse,
    void Function(dynamic error)? onError,
  }) {
    interceptors.onSend(event, data);

    final polling = _polling;
    if (polling == null || !polling.isConnected) {
      onError?.call('Socket is not initialized');
      return;
    }

    try {
      polling.emit(event, data, onResponse: onResponse);
    } catch (e) {
      interceptors.onError(event, e);
      onError?.call(e);
    }
  }

  void off(String event) {
    final controller = _listeners.remove(event);
    if (controller != null && !controller.isClosed) {
      controller.close();
    }
  }

  void disconnect() {
    _polling?.disconnect();
  }

  void dispose() {
    for (final controller in _listeners.values) {
      if (!controller.isClosed) controller.close();
    }
    _listeners.clear();
    _polling?.dispose();
    _polling = null;
    _socket?.dispose();
    _socket = null;
    _instance = null;
  }
}

class UFSocketConfig {
  static SocketInterceptorManager get interceptors => UFSocket.interceptors;

  static Socket? getSocket() => UFSocket.rawSocket;

  static Future<UFSocket> initializeSocket({
    Function({
      required Socket socket,
      required void Function(String event, Function(dynamic data)) on,
    })?
    initListeners,
  }) async {
    final socket = await UFSocket.initialize();
    final raw = UFSocket.rawSocket;
    if (raw != null) {
      initListeners?.call(
        socket: raw,
        on: (event, callback) => socket.listen(event: event, onData: callback),
      );
    }
    return socket;
  }

  static void send(String event, dynamic data) {
    UFSocket._instance?.emit(event: event, data: data);
  }

  static void on(String event, Function(dynamic) callback) {
    UFSocket._instance?.listen(event: event, onData: callback);
  }
}

/// Native `socket_io_client` 3.x has no HTTP polling transport. This server
/// (Apache) rejects WebSocket upgrades with Engine.IO code 3, while polling
/// handshake succeeds — same path Firecamp uses.
class _PollingClient {
  _PollingClient({
    required this.origin,
    required this.namespace,
    required this.token,
    required this.onEvent,
    required this.onError,
    required this.onConnect,
    required this.onDisconnect,
  });

  final String origin;
  final String namespace;
  final String token;
  final void Function(String event, dynamic data) onEvent;
  final void Function(dynamic error) onError;
  final void Function() onConnect;
  final void Function(dynamic reason) onDisconnect;

  final dart_io.HttpClient _http = dart_io.HttpClient();
  final Map<int, void Function(dynamic)> _acks = {};

  String? _sid;
  bool _connected = false;
  bool _closed = false;
  int _ackId = 0;
  int pingInterval = 25000;
  Completer<void>? _ready;

  bool get isConnected => _connected && !_closed;

  Future<void> connect() async {
    _ready = Completer<void>();
    await _handshake();
    unawaited(_pollLoop());
    return _ready!.future;
  }

  Uri _url({Map<String, String> extra = const {}}) {
    return Uri.parse('$origin/socket.io/').replace(
      queryParameters: {
        'EIO': '4',
        'transport': 'polling',
        if (_sid != null) 'sid': _sid!,
        ...extra,
      },
    );
  }

  String get _nspPrefix {
    if (namespace.isEmpty || namespace == '/') return '';
    return '$namespace,';
  }

  Map<String, String> _headers() {
    final headers = <String, String>{
      'Accept': '*/*',
      'Content-Type': 'text/plain;charset=UTF-8',
    };
    if (UFUtils.xPortal.isNotEmpty) {
      headers['x-portal'] = UFUtils.xPortal;
    }
    if (token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<String> _read(dart_io.HttpClientResponse response) async {
    final bytes = await response.fold<List<int>>(<int>[], (p, e) {
      p.addAll(e);
      return p;
    });
    return utf8.decode(bytes);
  }

  Future<String> _get(Uri uri) async {
    final request = await _http.getUrl(uri);
    _headers().forEach(request.headers.set);
    final response = await request.close().timeout(
      Duration(milliseconds: pingInterval + 20000),
    );
    final body = await _read(response);
    if (response.statusCode >= 400) {
      throw StateError('Socket poll HTTP ${response.statusCode}: $body');
    }
    return body;
  }

  Future<void> _post(String body) async {
    final request = await _http.postUrl(_url());
    _headers().forEach(request.headers.set);
    request.add(utf8.encode(body));
    final response = await request.close().timeout(const Duration(seconds: 20));
    final responseBody = await _read(response);
    if (response.statusCode >= 400) {
      throw StateError('Socket post HTTP ${response.statusCode}: $responseBody');
    }
    if (responseBody.isNotEmpty && responseBody != 'ok') {
      for (final packet in responseBody.split(String.fromCharCode(30))) {
        _handleEnginePacket(packet);
      }
    }
  }

  Future<void> _handshake() async {
    final body = await _get(_url());
    final packets = body.split(String.fromCharCode(30));
    for (final packet in packets) {
      _handleEnginePacket(packet);
    }
    if (_sid == null) {
      throw StateError('Socket.IO handshake did not return a sid');
    }
    // Socket.IO CONNECT: default `/` is `40`, namespace `/chat` is `40/chat,`.
    final authJson = token.isEmpty ? '' : jsonEncode({'token': token});
    await _post('40$_nspPrefix$authJson');
  }

  Future<void> _pollLoop() async {
    while (!_closed) {
      try {
        final body = await _get(_url());
        if (_closed) return;
        final packets = body.split(String.fromCharCode(30));
        for (final packet in packets) {
          _handleEnginePacket(packet);
        }
      } catch (e) {
        if (_closed) return;
        onError(e);
        if (_ready != null && !_ready!.isCompleted) {
          _ready!.completeError(e);
        }
        await Future<void>.delayed(const Duration(seconds: 2));
        if (_closed) return;
        try {
          _sid = null;
          _connected = false;
          await _handshake();
        } catch (retryError) {
          onError(retryError);
        }
      }
    }
  }

  void _handleEnginePacket(String packet) {
    if (packet.isEmpty) return;
    final type = packet[0];
    final data = packet.length > 1 ? packet.substring(1) : '';

    switch (type) {
      case '0':
        final open = jsonDecode(data) as Map<String, dynamic>;
        _sid = open['sid']?.toString();
        pingInterval = (open['pingInterval'] as num?)?.toInt() ?? 25000;
        debugPrint(
          'Socket handshake sid received, upgrades=${open['upgrades']}',
        );
        break;
      case '1':
        _connected = false;
        onDisconnect('transport close');
        break;
      case '2':
        unawaited(_post('3'));
        break;
      case '3':
        break;
      case '4':
        _handleSocketPacket(data);
        break;
      default:
        break;
    }
  }

  void _handleSocketPacket(String packet) {
    if (packet.isEmpty) return;
    final type = packet[0];
    var rest = packet.substring(1);

    if (rest.startsWith('/')) {
      final comma = rest.indexOf(',');
      if (comma == -1) return;
      rest = rest.substring(comma + 1);
    }

    if (type == '0') {
      _connected = true;
      if (_ready != null && !_ready!.isCompleted) {
        _ready!.complete();
      }
      onConnect();
      return;
    }
    if (type == '1') {
      _connected = false;
      onDisconnect('io server disconnect');
      return;
    }
    if (type == '4') {
      onError(rest.isEmpty ? 'connect_error' : rest);
      if (_ready != null && !_ready!.isCompleted) {
        _ready!.completeError(rest);
      }
      return;
    }
    if (type == '2' || type == '3') {
      String ackId = '';
      while (rest.isNotEmpty &&
          rest.codeUnitAt(0) >= 48 &&
          rest.codeUnitAt(0) <= 57) {
        ackId += rest[0];
        rest = rest.substring(1);
      }
      dynamic payload;
      try {
        payload = rest.isEmpty ? null : jsonDecode(rest);
      } catch (_) {
        payload = rest;
      }
      if (type == '3') {
        final id = int.tryParse(ackId);
        if (id != null) {
          _acks.remove(id)?.call(payload);
        }
        return;
      }
      if (payload is List && payload.isNotEmpty) {
        final event = payload.first.toString();
        final data = payload.length > 1
            ? (payload.length == 2 ? payload[1] : payload.sublist(1))
            : null;
        onEvent(event, data);
      }
    }
  }

  void emit(
    String event,
    dynamic data, {
    void Function(dynamic response)? onResponse,
  }) {
    final payload = data == null ? [event] : [event, data];
    if (onResponse != null) {
      final id = _ackId++;
      _acks[id] = onResponse;
      unawaited(_post('42$_nspPrefix$id${jsonEncode(payload)}'));
    } else {
      unawaited(_post('42$_nspPrefix${jsonEncode(payload)}'));
    }
  }

  void disconnect() {
    if (_closed) return;
    if (_sid != null) {
      unawaited(_post('41$_nspPrefix'));
    }
    dispose();
    onDisconnect('io client disconnect');
  }

  void dispose() {
    _closed = true;
    _connected = false;
    _acks.clear();
    _http.close(force: true);
  }
}
