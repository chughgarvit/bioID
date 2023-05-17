import 'package:mpc/api/local_auth_api.dart';
import 'package:mpc/pages/homepage.dart';
import 'package:mpc/main.dart';
import 'package:mpc/pages/uploadpage.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mpc/pages/Loginpage.dart';
import 'package:mpc/pages/signuppage.dart';
// class AuthPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser!;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(MyApp.title),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(32),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // buildAvailability(context),
//               Text(
//                 'Signed In as',
//                 style: TextStyle(fontSize: 16),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 user.email!,
//                 style: TextStyle(fontSize: 20),
//               ),
//               SizedBox(height: 24),
//               buildAuthenticate(context),
//               SizedBox(height: 30),
//               ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: Size.fromHeight(50),
//                 ),
//                 icon: Icon(Icons.arrow_back, size: 32),
//                 label: Text(
//                   'Sign Out',
//                   style: TextStyle(fontSize: 24),
//                 ),
//                 onPressed: () => FirebaseAuth.instance.signOut(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildAuthenticate(BuildContext context) => buildButton(
//         text: 'Authenticate',
//         icon: Icons.lock_open,
//         onClicked: () async {
//           final isAuthenticated = await LocalAuthApi.authenticate();

//           if (isAuthenticated) {
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (context) => HomePage()),
//             );
//           }
//         },
//       );

//   Widget buildButton({
//     required String text,
//     required IconData icon,
//     required VoidCallback onClicked,
//   }) =>
//       ElevatedButton.icon(
//         style: ElevatedButton.styleFrom(
//           minimumSize: Size.fromHeight(50),
//         ),
//         icon: Icon(icon, size: 26),
//         label: Text(
//           text,
//           style: TextStyle(fontSize: 20),
//         ),
//         onPressed: onClicked,
//       );
// }

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(onClickedSignUp: toggle)
      : SignUpWidget(onClickedSignIn: toggle);
  void toggle() => setState(() => isLogin = !isLogin);
}
