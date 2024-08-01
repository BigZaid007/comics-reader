import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar customAppBar(String title, double fontSize) {
  return AppBar(
    iconTheme: IconThemeData(color: Colors.white),
    leading: Container(),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 5).r,
        child: Container(
          width: 40.0.r, // Set the width and height to your desired size
          height: 40.0.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            "assets/images/logo-app.png",
            fit: BoxFit.cover, // Ensures the image covers the container
          ),
        ),
      ),
    ],
    title: Text(
      title,
      style: GoogleFonts.robotoMono(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          color: Colors.white,
          letterSpacing: 2),
    ),
    centerTitle: true,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 23, 15, 40),
      ),
    ),
  );
}

AppBar customAppBarChapter(String title, double fontSize) {
  return AppBar(
    iconTheme: IconThemeData(color: Colors.white),
    leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Icon(Icons.arrow_back)),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 5).r,
        child: Container(
          width: 40.0.r, // Set the width and height to your desired size
          height: 40.0.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            "assets/images/logo-app.png",
            fit: BoxFit.cover, // Ensures the image covers the container
          ),
        ),
      ),
    ],
    title: Text(
      title,
      style: GoogleFonts.robotoMono(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          color: Colors.white,
          letterSpacing: 2),
    ),
    centerTitle: true,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 23, 15, 40),
      ),
    ),
  );
}
