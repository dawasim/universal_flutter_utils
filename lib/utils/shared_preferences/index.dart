import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UFPrefUtils {

  final String isFirstRun = 'isFirstRun';
  final String isLoggedIn = 'isLoggedIn';
  String isLoggedOut = 'isLoggedOut';
  String authToken = 'authToken';
  String refreshToken = 'refreshToken';
  String selectedLanguage = 'selectedLanguage';
  String rememberMeData = 'rememberMeData';
  String userData = 'userData';
  String skippedAppVersion = 'skippedAppVersion';
  String notificationPayload = "notification_payload";


  Future<void> clearPref() async {
    SharedPreferences mStorage = await getStorage();
    final Iterable<String> mIterable = mStorage.getKeys();
    final keys = mIterable.toList();
    for (var element in keys) {
      if (element != rememberMeData) {
        mStorage.remove(element);
      }
    }
  }

  Future<void> clearPrefExcept({List<String>? keysToKeep}) async {
    SharedPreferences mStorage = await getStorage();
    Set<String>? allKeys = mStorage.getKeys();

    Set<String> keysToRemove = (keysToKeep?.isNotEmpty ?? false)
        ? allKeys.difference(keysToKeep!.toSet())
        : allKeys;

    for (final key in keysToRemove) {
      debugPrint('Removing key: $key');
      mStorage.remove(key);
    }
  }

  Future<void> clearAuthToken() async {
    SharedPreferences mStorage = await getStorage();
    mStorage.remove(authToken);
  }


  Future<void> writeString(String key, String value) async {
    SharedPreferences mStorage = await getStorage();
    mStorage.setString(key, value);
  }

  Future<String?> readString(String key) async {
    SharedPreferences mStorage = await getStorage();
    return mStorage.getString(key);
  }

  Future<void> writeBoolean(String key, bool value) async {
    SharedPreferences mStorage = await getStorage();
    mStorage.setBool(key, value);
  }

  Future<bool> readBoolean(String key) async {
    SharedPreferences mStorage = await getStorage();
    return mStorage.getBool(key) ?? false;
  }

  Future<void> writeObject(String key, dynamic value) async {
    SharedPreferences mStorage = await getStorage();
    mStorage.setString(key, value);
  }

  dynamic readObject(String key) async {
    SharedPreferences mStorage = await getStorage();
    return mStorage.getString(key);
  }

  Future<String> readAuthToken() async {
    SharedPreferences mStorage = await getStorage();
    return mStorage.getString(authToken) ?? '';
  }

  Future<String> readRefreshToken() async {
    SharedPreferences mStorage = await getStorage();
    return mStorage.getString(refreshToken) ?? '';
  }

  Future<String> readSelectedLanguage() async {
    SharedPreferences mStorage = await getStorage();
    return mStorage.getString(selectedLanguage) ?? '';
  }

  Future<bool> readIsUserLoggedIn() async {
    SharedPreferences mStorage = await getStorage();
    return mStorage.getBool(isLoggedIn) ?? false;
  }

  Future<bool> readIsFirstRun() async {
    SharedPreferences mStorage = await getStorage();
    return mStorage.getBool(isFirstRun) ?? true;
  }

  Future<SharedPreferences> getStorage() async {
    return await SharedPreferences.getInstance();
  }
}