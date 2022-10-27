import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../model/model.dart';

class AuthUserLogin {
  /// Returns UserCredential on successful sign in
  ///
  /// Returns SignInException on failure
  Future<dynamic> signInWithEmailAndPassword(
      {required String emailAddress, required String password}) async {
    try {
      return await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Debug.printing('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Debug.printing('Wrong password provided for that user.');
      }
      return SignInExceptions.values
          .firstWhere((element) => _enumToErrorCode(element) == e.code);
    }
  }

  String _enumToErrorCode(SignInExceptions se) {
    return se.name.replaceAll(RegExp(r'_'), '-');
  }

  Future<void> sendEmailLink({required String email}) async {
    ActionCodeSettings acs = ActionCodeSettings(
        // URL you want to redirect back to. The domain (www.example.com) for this
        // URL must be whitelisted in the Firebase Console.
        url: 'https://bledevicelogin.page.link/V9Hh?email=$email',
        // This must be true
        handleCodeInApp: true,
        iOSBundleId: 'com.example.bldeviceConnection',
        androidPackageName: "com.example.bldevice_connection",
        // installIfNotAvailable
        androidInstallApp: true,
        androidMinimumVersion: '12');

    try {
      developer.log('sendEmailLink[$email]');
      await FirebaseAuth.instance
          .sendSignInLinkToEmail(email: email, actionCodeSettings: acs);
      print("suceesfully send the email $email");
      FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
        developer.log('sendEmailLink[$email]');
      }).onError((error) {
        developer.log('onLink.onError[$error]');
      });
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }

    // return AppResponse

    Future getDynamicLink({required bool checkdynamiclink}) async {
      final dynamicLinkData =
          await FirebaseDynamicLinks.instance.getInitialLink();
      if (FirebaseAuth.instance
          .isSignInWithEmailLink(dynamicLinkData.toString())) {
        try {
          // The client SDK will parse the code from the link for you.
          final userCredential = await FirebaseAuth.instance
              .signInWithEmailLink(
                  email: email, emailLink: dynamicLinkData.toString());

          // You can access the new user via userCredential.user.
          final emailAddress = userCredential.user?.email;

          print('Successfully signed in with email link!');
        } catch (error) {
          print('Error signing in with email link.');
        }
      }
    }
  }
}
