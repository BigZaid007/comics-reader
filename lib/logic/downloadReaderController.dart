import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';

class DownloadReaderController extends GetxController {
  var downloadedFiles = <FileSystemEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDownloadedFiles();
  }

  Future<void> fetchDownloadedFiles() async {
    final directory = await getExternalStorageDirectory();
    final downloadDir = Directory(directory!.path);
    downloadedFiles.value = downloadDir
        .listSync()
        .where((file) => file.path.endsWith('.zip'))
        .toList();
  }

  Future<List<String>> extractImages(String zipFilePath) async {
    final bytes = File(zipFilePath).readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    final directory = await getTemporaryDirectory();
    final zipFileName = zipFilePath.split('/').last.split('.').first;
    final extractDir = Directory('${directory.path}/extracted/$zipFileName');

    if (extractDir.existsSync()) {
      extractDir.deleteSync(recursive: true);
    }

    extractDir.createSync(recursive: true);

    final images = <String>[];

    for (var file in archive) {
      if (file.isFile) {
        final filename = file.name;
        final data = file.content as List<int>;
        final filePath = '${extractDir.path}/$filename';
        File(filePath).writeAsBytesSync(data);
        images.add(filePath);
      }
    }

    return images;
  }

  Future<void> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
      fetchDownloadedFiles();
    }
  }

  Future<bool> confirmDelete(BuildContext context, String filePath) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm Delete'),
              content: Text('Are you sure you want to delete this file?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    deleteFile(filePath);
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
