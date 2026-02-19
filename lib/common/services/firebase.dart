import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb; // Add this
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../universal_flutter_utils.dart';

class UFFirebaseUtils {
  // Helper to check support
  bool get _supportsFirebaseMessaging => kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS;

  Future<void> initFirebase({Function(Map<String, dynamic>)? notificationTap, FirebaseOptions? options}) async {
    ///   Initialize firebase
    await Firebase.initializeApp(options: options);
    /// Initialize Notification Service
    await UFNotificationUtils.initialize(notificationTap: notificationTap);
  }


  void initFCMToken() async {
    // Check support before accessing instance
    if (!_supportsFirebaseMessaging) return;

    try {
      FirebaseMessaging instance = FirebaseMessaging.instance;
      // Get FCM Token
      UFUtils.fcmToken = await getFCMToken(instance: instance) ?? "";
      // Listen for Token Refresh
      instance.onTokenRefresh.listen((newToken) {
        UFUtils.fcmToken = newToken;
        debugPrint("New FCM Token: $newToken");
      });
    } catch (e) {
      debugPrint("FCM Token Init Error: $e");
    }
  }

  Future<String?> getFCMToken({FirebaseMessaging? instance}) async {
    // Check support before proceeding
    if (!_supportsFirebaseMessaging) return null;

    try {
      instance ??= FirebaseMessaging.instance;

      // APNS check is only valid for Apple platforms
      if (!kIsWeb && (Platform.isIOS || Platform.isMacOS)) {
        var apns = await instance.getAPNSToken();
        debugPrint('FCM APNS Token: $apns ');
      }

      var firebase = await instance.getToken();
      debugPrint('FCM Token: $firebase');
      return firebase;
    } catch (e) {
      debugPrint("Error getting FCM Token: $e");
      return null;
    }
  }
}