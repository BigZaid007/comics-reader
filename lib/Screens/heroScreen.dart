import 'package:epic/Screens/HeroComicScreen.dart';
import 'package:epic/helpers/styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HeroScreen extends StatelessWidget {
  final String img;
  final Color bgColor;
  final String des;
  final FirebaseApp app;

  const HeroScreen({
    super.key,
    required this.img,
    required this.bgColor,
    required this.des,
    required this.app,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: this.bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            Hero(
              tag: this.img,
              child: Image.asset(
                'assets/images/${this.img}.png',
                fit: this.img == 'spider' ? BoxFit.contain : BoxFit.cover,
                width: MediaQuery.of(context).size.width / 2.5,
                height: MediaQuery.of(context).size.height / 2.5,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 23, 15, 40),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25).r,
                  topLeft: Radius.circular(25).r,
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              child: Padding(
                  padding: const EdgeInsets.only(left: 14, top: 10).r,
                  child: Column(
                    children: [
                      Text(
                        this.des,
                        softWrap: true,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 13.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      GestureDetector(
                          onTap: () {
                            Get.to(() =>
                                HeroListScreen(app: this.app, title: this.img));
                          },
                          child: Container(
                            alignment: AlignmentDirectional.center,
                            width: 140.w,
                            height: 55.h,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 23, 15, 40),
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
                            child: Text(
                              'Read Now',
                              style: mainStyle,
                            ),
                          ))
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
