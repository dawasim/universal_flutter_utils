import 'dart:convert';
import 'dart:developer';
import 'dart:math' show Random;

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

import 'platform_interface.dart';

class UFUSocialLogin {

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleSignInAccount;
      try {
        googleSignInAccount = await googleSignIn.signIn().catchError((onError) {
          onError.printError();
          throw Exception(onError.toString());
        });
      } catch (e) {
        rethrow;
      }

      if (googleSignInAccount != null) {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await GoogleSignIn().signOut();
        return await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } catch (e) {
      if (UFUtils.isLoaderVisible()) Get.back();
      e.printError();
      rethrow;
    }
    return null;
  }

  Future<Map<String, dynamic>?> signInWithApple(String clientId) async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName
        ],
        webAuthenticationOptions: GetPlatform.isIOS
            ? null
            : WebAuthenticationOptions(
            clientId: clientId,
            redirectUri: Uri.parse(
                'https://grizzled-zippy-cactus.glitch.me/callbacks/sign_in_with_apple')),
        nonce: GetPlatform.isIOS ? nonce : null,
      ).catchError((error) {
        error.toString().printError();
        throw Exception(error.toString());
      });

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      String displayName = "";

      if (appleCredential.givenName?.isNotEmpty ?? false) {
        displayName = appleCredential.givenName ?? "";
      }

      if (appleCredential.familyName?.isNotEmpty ?? false) {
        displayName = displayName.isNotEmpty
            ? " ${appleCredential.familyName}"
            : appleCredential.familyName ?? "";
      }

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final mUser = await FirebaseAuth.instance.signInWithCredential(
          oauthCredential);

      return {
        "displayName": displayName,
        "user": mUser
      };
    } catch (e) {
      if (UFUtils.isLoaderVisible()) Get.back();
      // showSnackBar(e.toString());
      // try {
      //   UserCredential await FirebaseAuth.instance.signInWithPopup(AppleAuthProvider());
      // }
      rethrow;
    }
  }

  String generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<Map<String, dynamic>?> signInWithFacebook(int socialType) async {
    try {
      // Create an instance of FacebookLogin
      final fb = FacebookLogin();

      // Log in
      final res = await fb.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ]);

      // Check result status
      switch (res.status) {
        case FacebookLoginStatus.success:
        // Logged In
          final accessToken = res.accessToken?.token;
          final profile = await fb.getUserProfile();
          final name = profile?.name;
          final userID = profile?.userId;
          final imageUrl = await fb.getProfileImageUrl(width: 100);
          final email = await fb.getUserEmail();
          fb.logOut();

          final Map<String, dynamic> mData = {
            'socialId': userID,
            'email': email,
            'fullName': name,
            'image': imageUrl,
            'socialType': socialType,
          };

          return mData;
        case FacebookLoginStatus.cancel:
        // User cancel log in
          throw Exception("Login has been cancelled");
          return null;
        case FacebookLoginStatus.error:
        // Log in failed
          throw Exception("${FacebookLoginStatus.error}");
          return null;
      }
    } catch (e) {
      rethrow;
    }
  }

}

void displayError(dynamic error) {
  log("Error: $error");
  UFUToast.showToast("An error occurred: ${error.toString()}");
}