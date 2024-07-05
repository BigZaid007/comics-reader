import 'dart:io';
import 'package:epic/helpers/styles.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:preload_page_view/preload_page_view.dart';

class DownloaderReaderScreen extends StatelessWidget {
  final List<String> images;
  final String name;

  DownloaderReaderScreen({required this.images, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          this.name,
          style: meduimStyle,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: PreloadPageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return PhotoView(
            imageProvider: FileImage(File(images[index])),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            initialScale: PhotoViewComputedScale.contained,
            basePosition: Alignment.center,
            enableRotation: false,
            backgroundDecoration: BoxDecoration(color: Colors.black),
          );
        },
      ),
    );
  }
}
