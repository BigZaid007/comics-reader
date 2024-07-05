import 'package:dio/dio.dart';
import 'package:epic/Screens/DownloadsFile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive_io.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:preload_page_view/preload_page_view.dart';

class ComicReaderController extends GetxController {
  final List<String> links;
  final String name;

  ComicReaderController({required this.links, required this.name});

  var currentPage = 0.obs;
  var isLoading = false.obs;
  var progress = 0.0.obs; // Added for progress tracking
  late PreloadPageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PreloadPageController();
    pageController.addListener(() {
      currentPage.value = pageController.page?.round() ?? 0;
    });
  }

  Future<void> downloadAndZipImages() async {
    isLoading.value = true;
    progress.value = 0.0;
    try {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        Get.snackbar('Permission Denied',
            'Storage permission is required to download images.');
        return;
      }

      // Get the downloads directory
      final directory = await getExternalStorageDirectory();
      final imagesDir = Directory('${directory!.path}/$name');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      // Download all images with progress
      List<File> imageFiles = [];
      Dio dio = Dio();
      for (int i = 0; i < links.length; i++) {
        String imageUrl = links[i];
        String imagePath = '${imagesDir.path}/image_$i.jpg';
        await dio.download(
          imageUrl,
          imagePath,
          onReceiveProgress: (received, total) {
            progress.value =
                (received / total) / links.length + (i / links.length);
          },
        );
        imageFiles.add(File(imagePath));
      }

      // Create a zip file
      final zipFile = File('${directory.path}/$name.zip');
      var encoder = ZipFileEncoder();
      encoder.create(zipFile.path);
      for (var file in imageFiles) {
        encoder.addFile(file);
      }
      encoder.close();

      isLoading.value = false;

      // Show dialog
      Get.dialog(
        AlertDialog(
          title: Text('Download Complete'),
          content: Text(
            'You Can Enjoy Reading Offline!',
            style: GoogleFonts.lato(color: Colors.grey, fontSize: 13.sp),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.to(() => DownloadsScreen());
              },
              child: Text('Go to Download Screen'),
            ),
          ],
        ),
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
          'Download Failed', 'An error occurred while downloading images.');
      print(e);
    }
  }
}
