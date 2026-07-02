/// A Flutter UI toolkit and utilities package for faster app development.
///
/// Includes reusable [widgets], [Dio](https://pub.dev/packages/dio) API helpers,
/// [Firebase](https://pub.dev/packages/firebase_core) authentication, file pickers,
/// form validators, themes, [socket.io](https://pub.dev/packages/socket_io_client)
/// configuration, maps, OTP input, bottom sheets, shimmer loading, multi-select,
/// social login, biometric auth, and cross-platform utilities.
///
/// ## Quick import
///
/// ```dart
/// import 'package:universal_flutter_utils/universal_flutter_utils.dart';
/// ```
///
/// ## Key features
///
/// - **Widgets**: `UFUButton`, `UFUInputBox`, `UFUOtpInputBox`, `UFUMultiSelect`,
///   `ShowUFULoader`, `ShowUFUBottomSheet`, `UFUShimmer`, `UFUVideoPlayer`, and more
/// - **Networking**: Dio HTTP client with AES encryption and interceptors
/// - **Authentication**: Firebase, Google, Apple, Facebook, and biometric login
/// - **Utilities**: validators, file picker, shared preferences, permissions, themes
library;

export 'common/index.dart';
export 'utils/index.dart';
export 'utils/biometric_recognition/index.dart';
export 'widgets/index.dart';
export 'theme/index.dart';
export 'models/index.dart';
export 'extensions/index.dart';
export 'socket_config/socket_config.dart';
