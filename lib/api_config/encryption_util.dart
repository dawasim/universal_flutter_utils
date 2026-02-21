import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart' show debugPrint;
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class EncryptionUtil {
  static const sek = "sek";
  static const hash = "hash";
  static const dataKey = "date";
  static const deviceTypeKey = "deviceType";
  static const accountType = "x-portal";

  // static var ENCRYPTION_IV = UFUtils.encryptionIV;
  // static final iv = IV.fromUtf8(ENCRYPTION_IV);

  static Map<String, dynamic>? secKeyEncryptWithBodyAppKey(Map<String, dynamic> mParams) {
    try {
      final iv = IV.fromUtf8(UFUtils.encryptionIV);
      final key = Key.fromSecureRandom(32).bytes;
      final encrypter = Encrypter(AES(Key(key), mode: AESMode.cbc));
      final randomString = jsonEncode(mParams);
      final encrypted = encrypter.encrypt(randomString, iv: iv);
      final result = {
        sek: hex.encode(encrypted.bytes),
        hash: hex.encode(key)
      };
      return result;
    } catch (e) {
      return null;
    }
  }

  static Map<String, String>? secKeyEncryptWithHeaderAppKey(String auth, Map<String, dynamic>? jsonDecode) {
    try {
      final iv = IV.fromUtf8(UFUtils.encryptionIV);
      final key = Key.fromSecureRandom(32).bytes;
      final appKeyData = DateTime.now().toUtc().toString();
      final jsonMap = {dataKey: appKeyData, accountType: UFUtils.xPortal};
      if (auth.isNotEmpty) jsonMap['authorization'] = "Bearer $auth";
      if (jsonDecode != null) {
        jsonDecode.forEach((key, value) {
          jsonMap[key] = "$value";
        });
      }
      debugPrint("Headers ----------- $jsonMap");
      final encrypter = Encrypter(AES(Key(key), mode: AESMode.cbc));
      final randomString = jsonEncode(jsonMap);
      final encrypted = encrypter.encrypt(randomString, iv: iv);

      final result = UFUtils.applyEncryption
        ? {
            sek: hex.encode(encrypted.bytes),
            hash: hex.encode(key),
            deviceTypeKey: 'android',
          } : jsonMap;
      return result;
    } catch (e) {
      return null;
    }
  }

  static String? secKeyDecryptedWithSek(Map<String, dynamic> hashMap) {
    try {
      final iv = IV.fromUtf8(UFUtils.encryptionIV);
      final key = hexStringToByteArray(hashMap[hash] as String);
      final toDecode = hexStringToByteArray(hashMap[sek] as String);
      final encrypter = Encrypter(AES(Key(key), mode: AESMode.cbc));
      final decrypted = encrypter.decryptBytes(Encrypted(toDecode), iv: iv);
      return utf8.decode(decrypted);
    } catch (e) {
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
