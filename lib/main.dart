import 'dart:io';

import 'package:file_picker/file_picker.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mpc/api/firebase_api.dart';
import 'package:mpc/pages/Loginpage.dart';
import 'package:mpc/pages/homepage.dart';
import 'package:mpc/pages/verifyemailpage.dart';
import 'package:mpc/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:mpc/pages/authpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mpc/pages/utils.dart';
// import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();

  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  static final String title = 'Meghraj';

  @override
  Widget build(BuildContext context) => MaterialApp(
        scaffoldMessengerKey: messengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            appBarTheme: AppBarTheme(
              centerTitle: true,
            )),
        home: Scaffold(
          body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Something went wrong, please try again!'));
              } else if (snapshot.hasData) {
                return verifyEmailPage();
              } else {
                return AuthPage();
              }
            },
          ),
        ),
      );
}
