import 'package:biometrics_demo/localization/app_localization.dart';
import 'package:biometrics_demo/resources/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';

class BiometricHelper {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> isBiometricSupported() async {
    return await _auth.isDeviceSupported();
  }

  static Future<List<BiometricType>> getAvailableBiometrics() async {
    return await _auth.getAvailableBiometrics();
  }

  static Future<bool> authenticate(BuildContext context) async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: context.tr(AppStrings.authenticateToAccessNotes),
        options: const AuthenticationOptions(biometricOnly: true),
      );
      return didAuthenticate;
    } catch (e) {
      Fluttertoast.showToast(msg: context.tr(AppStrings.biometricFailed));
      return false;
    }
  }
}
