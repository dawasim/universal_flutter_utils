import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class UFUBiometricRecognition {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Checks whether biometric authentication is supported on the device.
  Future<bool> isBiometricSupported() async {
    try {
      bool canCheckBiometrics = await _auth.canCheckBiometrics;
      bool isDeviceSupported = await _auth.isDeviceSupported();
      return canCheckBiometrics && isDeviceSupported;
    } catch (e) {
      debugPrint('Error checking biometric support: $e');
      return false;
    }
  }

  /// Prompts the user for biometric authentication and returns success status.
  Future<bool> validateBiometric() async {
    try {
      // Optional: You can call isBiometricSupported() here if needed
      List<BiometricType> availableBiometrics = await _auth.getAvailableBiometrics();

      if (availableBiometrics.isEmpty) {
        return false;
      }

      bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      return didAuthenticate;
    } catch (e) {
      debugPrint('Biometric authentication error: $e');
      return false;
    }
  }
}
