import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:epic/Screens/DownloadsFile.dart';
import 'package:epic/Screens/comicScreen.dart';
import 'package:epic/Screens/homeScreen.dart';
import 'package:epic/Screens/mangaScreen.dart';
import 'package:epic/Widgets/bottomBar.dart';
import 'package:epic/Widgets/customAppBar.dart';
import 'package:epic/Widgets/gridView.dart';
import 'package:epic/logic/homeController.dart';
import 'package:epic/models/comics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LandingPage extends StatefulWidget {
  final FirebaseApp app;

  const LandingPage({super.key, required this.app});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final controller = Get.put(bottomBarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () => bottomBar(controller),
      ),
      appBar: customAppBar('Geekz', 22.0.sp),
      body: Obx(
        () {
          if (controller.currentIndex.value == 0) {
            return HomeScreen(app: widget.app);
          } else if (controller.currentIndex.value == 1) {
            return mangaScreen(
              app: widget.app,
            );
          } else if (controller.currentIndex.value == 2) {
            return comicScreen(
              app: widget.app,
            );
          } else {
            return DownloadsScreen();
          }
        },
      ),
    );
  }
}
