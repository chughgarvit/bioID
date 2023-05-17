// import 'package:mpc/main.dart';
// import 'package:mpc/pages/authpage.dart';
// import 'package:flutter/material.dart';

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           title: Text(MyApp.title),
//         ),
//         body: Padding(
//           padding: EdgeInsets.all(32),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Home',
//                   style: TextStyle(fontSize: 40),
//                 ),
//                 SizedBox(height: 48),
//                 buildLogoutButton(context)
//               ],
//             ),
//           ),
//         ),
//       );

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mpc/api/firebase_api.dart';
import 'package:mpc/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:mpc/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mpc/pages/authpage.dart';
import 'package:mpc/pages/homepage.dart';

class UploadPage extends StatelessWidget {
  static final String title = 'Meghraj';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  UploadTask? task;
  File? file;

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    // final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text(MyApp.title),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                text: 'Select File',
                icon: Icons.attach_file,
                onClicked: selectFile,
              ),
              SizedBox(height: 8),
              Text(
                fileName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 48),
              ButtonWidget(
                text: 'Upload File',
                icon: Icons.cloud_upload_outlined,
                onClicked: uploadFile,
              ),
              SizedBox(height: 70),
              task != null ? buildUploadStatus(task!) : Container(),
              // buildLogoutButton(context),
              SizedBox(height: 70),
              buildBackButton(context)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildLogoutButton(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromRGBO(75, 0, 130, 1),
          minimumSize: Size.fromHeight(50),
        ),
        child: Text(
          'Logout',
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () => FirebaseAuth.instance.signOut(),
      );

  @override
  Widget buildBackButton(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.deepPurple,
          minimumSize: Size.fromHeight(50),
        ),
        child: Text(
          'Back',
          style: TextStyle(fontSize: 20),
        ),
        // onPressed: () => Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (context) => HomePage()),
        // ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      );

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final em = user?.email ?? "empty";
    print(em);
    if (file == null) return;
    final metadata = SettableMetadata(
      customMetadata: {
        'uploadedBy': user?.email ?? 'unknown',
      },
    );
    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!, metadata);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    // print('Download-Link: $urlDownload');
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(1);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
}
