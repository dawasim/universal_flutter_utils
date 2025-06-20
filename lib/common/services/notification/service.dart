import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:universal_flutter_utils/utils/index.dart';


class UFNotificationUtils {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static Function(Map<String, dynamic>)? handleNotificationTap;

  static Future<void> initialize({Function(Map<String, dynamic>)? notificationTap}) async {
    handleNotificationTap = notificationTap;
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings());

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Foreground notification tapped: ${response.payload}');

        if (response.payload == null || (response.payload?.isEmpty ?? true)) {
          return;
        }

        handleNotificationTap?.call(jsonDecode(makeValidJson(response.payload ?? "")));
      },
      onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Received message: ${message.notification}');
      RemoteNotification? notification = message.notification;

      if (notification != null) {
        _showNotification(
          notification.title ?? "No Title",
          notification.body ?? "No Body",
          message.data,
        );
      }

      // handleNotificationTap?.call(jsonDecode(makeValidJson(message.data.toString())));

    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await requestNotificationPermission();
  }

  @pragma('vm:entry-point')
  static void onDidReceiveBackgroundNotificationResponse(NotificationResponse response) {
    debugPrint('Background notification tapped: ${response.payload}');

    if (response.payload == null || (response.payload?.isEmpty ?? true)) {
      return;
    }

    handleNotificationTap?.call(jsonDecode(makeValidJson(response.payload ?? "")));
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    debugPrint('Handling a background message: ${message.messageId}');
    FlutterAppBadgeControl.isAppBadgeSupported().then((value) async {
      if(value) {
        UFUtils.preferences.readString("unreadNotification").then((response) {
          int count = int.parse(response ?? "0");
          FlutterAppBadgeControl.updateBadgeCount(count + 1);
        });
      }
    });
  }

  // Show Notification
  static Future<void> _showNotification(String title, String body, Map<String, dynamic> data) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notification.',
      importance: Importance.high,
      channelShowBadge: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title, body, platformChannelSpecifics,
      payload: data.toString(), // Add payload for notification tap handling
    );
  }

  // Handle Notification Tap

  // static Future<void> handleNotificationTap(payload) async {
  //   debugPrint("Notification tapped with payload: $payload");
  //
  //   if (payload == null && payload is! Map<String, dynamic>) {
  //     return;
  //   }
  //
  //   try {
  //     // final mapData = NotificationsPayload.fromJson(payload);
  //     /*
  //
  //     1 => message, 2 => Status Update, 3 => location, 4 => direct_payment,
  //     5 => subscription, 6 => admin_notification, 7 => 'Add Item',
  //     8 => 'Add Group', 9 => 'add New Member', 10 => 'Payment'
  //
  //     */
  //
  //     if (await UFUtils.preferences.readIsUserLoggedIn()) {
  //       // switch (mapData.type) {
  //       //   case 2:
  //       //     // navigateToIssueDetails(mapData);
  //       //     break;
  //       //   default:
  //       //     // navigateToNotification(mapData);
  //       //     break;
  //       // }
  //     }
  //   } on FormatException catch (e) {
  //     debugPrint('JSON FormatException: $e');
  //   } catch (e) {
  //     debugPrint('Unexpected error: $e');
  //   }
  // }


  static String makeValidJson(String input) {
    // Replace 'undefined' with null
    input = input.replaceAll(RegExp(r'\bundefined\b'), 'null');

    // Add double quotes around keys, ignoring URLs (http: or https:)
    input = input.replaceAllMapped(
      RegExp(r'(\b(?!http|https)[a-zA-Z0-9_]+)(?=:)', multiLine: true),
      (match) => '"${match.group(0)}"',
    );

    // Add double quotes around string values while ignoring URLs
    input = input.replaceAllMapped(
      RegExp(r':\s*([^"{\[\],\s][^,}\]]*)'),
      (match) {
        final value = match.group(1);
        // If value starts with http or https, don't wrap it in quotes
        if (value != null &&
            (value.startsWith('http:') || value.startsWith('https:'))) {
          return ':"$value"'; // Don't add quotes for URLs
        }
        // Otherwise, quote it normally
        return ': "$value"';
      },
    );

    try {
      // Parse to ensure it's valid JSON
      final jsonObject = jsonDecode(input);
      return const JsonEncoder.withIndent('  ').convert(jsonObject); // Pretty-printed JSON
    } on FormatException catch (e) {
      return 'FormatException: ${e.toString()}';
    } on Exception catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  static Future<void> requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }
}
