import 'dart:io';

// import 'package:mpc/model/firebase_file.dart';
import 'package:flutter/material.dart';
import 'package:mpc/widget/firebase_download.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';

class FirebaseApi {
  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<FirebaseFile>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();
    // List<Map<String, dynamic>> files = [];
    // for (final ref in result.items) {
    //   final metadata = await ref.getMetadata();
    //   final file = {
    //     // ref: ref,
    //     'name': ref.name,
    //     'upb': metadata.customMetadata?['uploadedBy'] ?? 'unknown',
    //     'url': await ref.getDownloadURL()
    //   };
    //   files.add(file);
    // }
    List<FirebaseFile> files = [];
    for (final ref in result.items) {
      final metadata = await ref.getMetadata();
      final url = await ref.getDownloadURL();
      final file = FirebaseFile(
        ref: ref,
        name: ref.name,
        upb: metadata.customMetadata?['uploadedBy'] ?? 'unknown',
        url: url,
      );
      files.add(file);
    }
    // final urls = await _getDownloadLinks(result.items);

    // return urls
    //     .asMap()
    //     .map((index, url) {
    //       final ref = result.items[index];
    //       final name = ref.name;

    //       final file = FirebaseFile(ref: ref, name: name, url: url);

    //       return MapEntry(index, file);
    //     })
    //     .values
    //     .toList();
    // return files;
    return Future.value(files);
  }

  // static Future downloadFile(
  //     Map<int, double> downloadProgress, int idx, Reference ref) async {
  //   final fileurl = await ref.getDownloadURL();
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.storage,
  //     //add more permission to request here.
  //   ].request();

  //   if (statuses[Permission.storage]!.isGranted) {
  //     var dir = await DownloadsPathProvider.downloadsDirectory;
  //     if (dir != null) {
  //       String savename = ref.name;
  //       String savePath = dir.path + "/$savename";
  //       // print(savePath);
  //       //output:  /storage/emulated/0/Download/banner.png

  //       try {
  //         await Dio().download(fileurl, savePath,
  //             onReceiveProgress: (actualbytes, totalbytes) {
  //           // if (total != -1) {
  //           //   print((received / total * 100).toStringAsFixed(0) + "%");
  //           // }
  //           double progress = actualbytes / totalbytes;

  //           downloadProgress[idx] = progress;
  //           // });
  //         });
  //         // print("File is saved to download folder.");
  //       } on DioError catch (e) {
  //         print(e.message);
  //       }
  //     }
  //   } else {
  //     print("No permission to read and write.");
  //   }
  // }

  // static void setState(Null Function() param0) {}
}
