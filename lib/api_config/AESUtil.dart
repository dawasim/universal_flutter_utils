import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:encrypt/encrypt.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class AESUtil {
  static const SEK = "sek";
  static const HASH = "hash";
  static const DATE_KEY = "date";
  static const DEVICE_TYPE_KEY = "devicetype";
  static const ACCOUNT_TYPE = "x-portal";

  // static var ENCRYPTION_IV = UFUtils.encryptionIV;
  // static final iv = IV.fromUtf8(ENCRYPTION_IV);

  static Map<String, dynamic>? secKeyEncryptWithBodyAppKey(
      Map<String, dynamic> mParams) {
    try {
      final iv = IV.fromUtf8(UFUtils.encryptionIV);
      print("TESTING ------- ${UFUtils.encryptionIV}");
      final key = Key.fromSecureRandom(32).bytes;
      final encrypter = Encrypter(AES(Key(key), mode: AESMode.cbc));
      final randomString = jsonEncode(mParams);
      final encrypted = encrypter.encrypt(randomString, iv: iv);
      final result = {SEK: hex.encode(encrypted.bytes), HASH: hex.encode(key)};
      return result;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Map<String, String>? secKeyEncryptWithHeaderAppKey(String auth) {
    try {
      print('Token ---- $auth');
      final iv = IV.fromUtf8(UFUtils.encryptionIV);
      final key = Key.fromSecureRandom(32).bytes;
      final appKeyData = DateTime.now().toUtc().toString();
      final jsonMap = {DATE_KEY: appKeyData, ACCOUNT_TYPE: "user"};
      if (auth.isNotEmpty) jsonMap['Authorization'] = "Bearer $auth";
      final encrypter = Encrypter(AES(Key(key), mode: AESMode.cbc));
      final randomString = jsonEncode(jsonMap);
      final encrypted = encrypter.encrypt(randomString, iv: iv);
      final result = {
        SEK: hex.encode(encrypted.bytes),
        HASH: hex.encode(key),
        DEVICE_TYPE_KEY: 'android',
      };
      return result;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static String? secKeyDecryptedWithSek(Map<String, dynamic> hashMap) {
    try {
      final iv = IV.fromUtf8(UFUtils.encryptionIV);
      final key = hexStringToByteArray(hashMap[HASH] as String);
      final toDecode = hexStringToByteArray(hashMap[SEK] as String);
      final encrypter = Encrypter(AES(Key(key), mode: AESMode.cbc));
      final decrypted = encrypter.decryptBytes(Encrypted(toDecode), iv: iv);
      return utf8.decode(decrypted);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Uint8List hexStringToByteArray(String hex) {
    final len = hex.length;
    final data = Uint8List(len ~/ 2);
    for (int i = 0; i < len; i += 2) {
      data[i ~/ 2] = ((int.parse(hex[i], radix: 16) << 4) +
          int.parse(hex[i + 1], radix: 16));
    }
    return data;
  }
}
