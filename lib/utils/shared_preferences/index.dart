import 'package:shared_preferences/shared_preferences.dart';

class UFPrefUtils {

  final String isLoggedIn = 'isLoggedIn';
  String authToken = 'authToken';
  String rememberMeData = 'rememberMeData';
  String userData = 'userData';
  String skippedAppVersion = 'skippedAppVersion';

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
    return await mStorage.getString(authToken) ?? '';
  }

  Future<bool> readIsUserLoggedIn() async {
    SharedPreferences mStorage = await getStorage();
    return mStorage.getBool(isLoggedIn) ?? false;
  }

  getStorage() async {
    return await SharedPreferences.getInstance();
  }
}