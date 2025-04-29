import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../universal_flutter_utils.dart';

class UFFirebaseUtils {
  Future<void> initFirebase({Function(Map<String, dynamic>)? notificationTap}) async {
    ///   Initialize firebase
    await Firebase.initializeApp();
    /// Initialize Notification Service
    await UFNotificationUtils.initialize(notificationTap: notificationTap);
  }


  void initFCMToken() async {
    FirebaseMessaging instance = FirebaseMessaging.instance;
    // Get FCM Token
    UFUtils.fcmToken = await getFCMToken(instance: instance) ?? "";
    // Listen for Token Refresh
    instance.onTokenRefresh.listen((newToken) {
      UFUtils.fcmToken = newToken;
      debugPrint("New FCM Token: $newToken");
    });
  }

  Future<String?> getFCMToken({FirebaseMessaging? instance}) async {
    instance ??= FirebaseMessaging.instance;
    if (Platform.isIOS) {
      var apns = await instance.getAPNSToken();
      debugPrint('FCM APNS Token: $apns ');
    }

    var firebase = await instance.getToken();

    debugPrint('FCM Token: $firebase');
    return firebase;
  }
}