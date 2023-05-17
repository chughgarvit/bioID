import 'package:local_auth/local_auth.dart';
import 'package:mpc/main.dart';
import 'package:mpc/pages/Loginpage.dart';
import 'package:mpc/pages/authpage.dart';
import 'package:mpc/pages/downloadpage.dart';
import 'package:flutter/material.dart';
import 'package:mpc/pages/utils.dart';
import 'package:mpc/widget/button_widget.dart';
import 'package:mpc/pages/uploadpage.dart';
import 'package:mpc/pages/Loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title),
        ),
        body: Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Hello ,'),
                Text(user.email!),
                SizedBox(height: 30),
                uploadButton(context),
                SizedBox(height: 30),
                downloadButton(context),
                SizedBox(height: 30),
                buildLogoutButton(context),
              ],
            ),
          ),
        ),
      );

  @override
  Widget uploadButton(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(50),
        ),
        child: Text(
          'Upload',
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => UploadPage()),
        ),
      );
  @override
  Widget downloadButton(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(50),
        ),
        child: Text(
          'Download',
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => DownloadPage()),
        ),
      );
  @override
  Widget buildLogoutButton(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(50),
        ),
        child: Text(
          'Logout',
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () {
          FirebaseAuth auth = FirebaseAuth.instance;
          auth.signOut();
          //.then((res) {
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(builder: (context) => AuthPage()),
          //   );
          // });
        },
      );
  // Future signOut(context) async {
  //   try {
  //     FirebaseAuth auth = FirebaseAuth.instance;
  //         return auth.signOut().then((res) {
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(builder: (context) => AuthPage()),
  //           );
  //         });
  //   } catch (e) {
  //     print(e);
  //     Utils.showSnackBar(e.toString());
  //     return null;
  //   }
}
// }
