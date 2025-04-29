import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'platform_interface.dart';

/// An implementation of [UFUMethodChannelSocialLogin] that uses method channels.
class UFUMethodChannelSocialLogin extends UFUSocialLoginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('social_login_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
