import 'dart:io';
import 'package:epic/Screens/downloaderReaderScreen.dart';
import 'package:epic/helpers/styles.dart';
import 'package:epic/logic/downloadReaderController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';

class DownloadsScreen extends StatelessWidget {
  final DownloadReaderController controller =
      Get.put(DownloadReaderController());

  void _openFile(String filePath, String name) async {
    final images = await controller.extractImages(filePath);
    Get.to(() => DownloaderReaderScreen(
          images: images,
          name: name,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 23, 15, 40),
        body: Column(
          children: [
            Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding: const EdgeInsets.all(8.0).r,
                  child: Text('Download List', style: mainStyle),
                )),
            SizedBox(
              height: 15.h,
            ),
            Expanded(
              child: Obx(() {
                if (controller.downloadedFiles.isEmpty) {
                  return Center(child: Text('No downloads found'));
                } else {
                  return ListView.builder(
                    itemCount: controller.downloadedFiles.length,
                    itemBuilder: (context, index) {
                      final file = controller.downloadedFiles[index];
                      return Dismissible(
                        key: Key(file.path),
                        background: Container(
                          color: Colors.red,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await controller.confirmDelete(
                              context, file.path);
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 3)
                                  .r,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15).r,
                                border: Border.all(color: Colors.white),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  )
                                ]),
                            child: Card(
                              color: bgColor,
                              child: ListTile(
                                title: Text(
                                  file.path
                                      .split('/')
                                      .last
                                      .replaceAll('.zip', ''),
                                  style: meduimStyle,
                                  softWrap: true,
                                ),
                                onTap: () => _openFile(
                                  file.path,
                                  file.path
                                      .split('/')
                                      .last
                                      .replaceAll('.zip', ''),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ));
  }
}
