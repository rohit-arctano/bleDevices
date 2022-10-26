import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class AuthUserLogin {
  FirebaseAuth auth = FirebaseAuth.instance;
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
      await auth.sendSignInLinkToEmail(email: email, actionCodeSettings: acs);
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
