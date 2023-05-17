import 'package:mpc/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mpc/pages/utils.dart';
import 'package:mpc/pages/forgotpasswordpage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
// import 'package:firebase_auth_email/main.dart';
// import 'packege:firebase_auth_emails/utils/utils.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const LoginWidget({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final LocalAuthentication auth = LocalAuthentication();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 60),
            // FlutterLogo(size: 120),
            ClipOval(
              child: Image.asset(
                'android/assets/logo.png',
                width: 200.0,
                height: 200.0,
                fit: BoxFit.cover,
              ),
            ),
            // Image.asset(
            //   'android/assets/logo.png',
            //   width: 100.0,
            //   height: 100.0,
            // ),
            SizedBox(height: 20),
            Text('Hey There, \n Hello',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 40),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
                shape: CircleBorder(),
                padding: EdgeInsets.all(45),
              ),
              icon: Icon(Icons.fingerprint_rounded, size: 32),
              label: Text(
                'Sign In',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: signIn,
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
                text: 'Did not authenticated your biometric? ',
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignUp,
                    text: 'Sign Up',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            // RichText(
            //   text: TextSpan(
            //     recognizer: TapGestureRecognizer()
            //       ..onTap = widget.onClickedSignUp,
            //     text: 'Sign Up',
            //     style: TextStyle(
            //       decoration: TextDecoration.underline,
            //       color: Theme.of(context).colorScheme.secondary,
            //     ),
            //   ),
            // ),
          ],
        ),
      );
  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    try {
      final authenticated = await auth.authenticate(
        localizedReason: 'Sign in using the fingerprint',
        options: const AuthenticationOptions(
          useErrorDialogs: false,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (authenticated) {
        final userStoredEmail = await storage.read(key: 'email');
        final userStoredPassword = await storage.read(key: 'password');

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userStoredEmail ?? 'default',
          password: userStoredPassword ?? 'default',
        );
      }
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
