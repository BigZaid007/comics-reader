import 'package:epic/Screens/heroScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Widget charCircle(
    String charImg, Color backgroundColor, String des, FirebaseApp app) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5).r,
    child: GestureDetector(
      onTap: () {
        Get.to(() => HeroScreen(
              img: charImg,
              bgColor: backgroundColor,
              des: des,
              app: app,
            ));
      },
      child: Container(
        alignment: AlignmentDirectional.center,
        child: Stack(
          children: [
            Positioned(
              top: 0.h,
              left: 15.w,
              bottom: 10.h,
              child: Hero(
                tag: charImg,
                child: Image.asset(
                  'assets/images/${charImg}.png',
                  height: 115.h,
                ),
              ),
            ),
          ],
        ),
        height: 95.h,
        width: 95.w,
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
      ),
    ),
  );
}
