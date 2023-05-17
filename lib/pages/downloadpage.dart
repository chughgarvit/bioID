import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mpc/api/firebase_download_api.dart';
import 'package:mpc/widget/firebase_download.dart';
import 'package:flutter/material.dart';
import 'package:mpc/pages/homepage.dart';
import 'package:mpc/pages/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';

const Map<int, Color> colorMap = {
  50: Color.fromRGBO(147, 205, 72, .1),
  100: Color.fromRGBO(147, 205, 72, .2),
  200: Color.fromRGBO(147, 205, 72, .3),
  300: Color.fromRGBO(147, 205, 72, .4),
  400: Color.fromRGBO(147, 205, 72, .5),
  500: Color.fromRGBO(147, 205, 72, .6),
  600: Color.fromRGBO(147, 205, 72, .7),
  700: Color.fromRGBO(147, 205, 72, .8),
  800: Color.fromRGBO(147, 205, 72, .9),
  900: Color.fromRGBO(147, 205, 72, 1),
};

class DownloadPage extends StatelessWidget {
  static final String title = 'Download';
  // final clr = Color.fromRGBO(75, 0, 130, 1);

  MaterialColor customColor = MaterialColor(0xFF4B0082, colorMap);
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
  late Future<List<FirebaseFile>> futureFiles;
  // late List<Future<Map<String, dynamic>>> fileDetails;
  var uploadedby;
  Map<int, double> downloadProgress = {};

  @override
  void initState() {
    super.initState();

    futureFiles = FirebaseApi.listAll('files/');
    // fileDetails=widget.futureFiles.map((url)=>getMetadataAndUrl(url));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(DownloadPage.title),
          centerTitle: true,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              );
            },
          ),
        ),
        body: FutureBuilder<List<FirebaseFile>>(
          future: futureFiles,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('Some error occurred!'));
                } else {
                  final files = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildHeader(files.length),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: files.length,
                          itemBuilder: (context, index) {
                            final file = files[index];
                            // get_metdata(file);
                            double? progress = downloadProgress[index];

                            // return buildFile(context, file);
                            return ListTile(
                              title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          file.name,
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        // if (uploadedby != null)
                                        Text(
                                          'Uploaded by: ${file.upb}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                              // Text(file.name),
                              subtitle: progress != null
                                  ? LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor: Colors.black26,
                                    )
                                  : null,
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.download,
                                  color: Colors.black,
                                ),
                                onPressed: () async {
                                  await downloadFile(index, file.ref);

                                  final snackBar = SnackBar(
                                    content: Text('Downloaded ${file.name}'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
            }
          },
        ),
      );

  // Widget buildFile(BuildContext context, FirebaseFile file) => ListTile(
  //       leading: ClipOval(
  //         child: Image.network(
  //           file.url,
  //           width: 52,
  //           height: 52,
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //       title: Text(
  //         file.name,
  //         style: TextStyle(
  //           fontWeight: FontWeight.bold,
  //           decoration: TextDecoration.underline,
  //           color: Colors.black,
  //         ),
  //       ),
  //       onTap: () => Navigator.of(context).push(MaterialPageRoute(
  //         builder: (context) => ImagePage(file: file),
  //       )),
  //     );

  Widget buildHeader(int length) => ListTile(
        tileColor: Color.fromRGBO(75, 0, 130, 1),
        leading: Container(
          width: 52,
          height: 52,
          child: Icon(
            Icons.file_copy,
            color: Colors.white,
          ),
        ),
        title: Text(
          '$length Files',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      );
  // ignore: non_constant_identifier_names
  // Future get_metdata(FirebaseFile file) async {
  //   final metadata = await file.ref.getMetadata();
  //   if (mounted) {
  //     setState(() {
  //       uploadedby = metadata.customMetadata?['uploadedBy'] ?? 'unknown';
  //     });
  //   }

  //   // print(uploadedby);
  // }

  Future downloadFile(int idx, Reference ref) async {
    final fileurl = await ref.getDownloadURL();
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      //add more permission to request here.
    ].request();

    if (statuses[Permission.storage]!.isGranted) {
      var dir = await DownloadsPathProvider.downloadsDirectory;
      if (dir != null) {
        String savename = ref.name;
        String savePath = dir.path + "/$savename";
        // print(savePath);
        //output:  /storage/emulated/0/Download/banner.png

        try {
          await Dio().download(fileurl, savePath,
              onReceiveProgress: (actualbytes, totalbytes) {
            // if (total != -1) {
            //   print((received / total * 100).toStringAsFixed(0) + "%");
            // }
            double progress = actualbytes / totalbytes;

            setState(() {
              downloadProgress[idx] = progress;
            });
          });
          // print("File is saved to download folder.");
        } on DioError catch (e) {
          Utils.showSnackBar(e.message);
        }
      }
    } else {
      Utils.showSnackBar("No permission to read and write.");
      // print();
    }
  }
}
