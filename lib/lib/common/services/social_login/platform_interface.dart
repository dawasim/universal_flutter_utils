import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel.dart';

abstract class UFUSocialLoginPlatform extends PlatformInterface {
  /// Constructs a UFUSocialLoginPlatform.
  UFUSocialLoginPlatform() : super(token: _token);

  static final Object _token = Object();

  static UFUSocialLoginPlatform _instance = UFUMethodChannelSocialLogin();

  /// The default instance of [UFUSocialLoginPlatform] to use.
  ///
  /// Defaults to [MethodChannelSocialLoginPlugin].
  static UFUSocialLoginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [UFUSocialLoginPlatform] when
  /// they register themselves.
  static set instance(UFUSocialLoginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
