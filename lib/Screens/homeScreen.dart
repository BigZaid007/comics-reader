import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:epic/Screens/ChaptersScreen.dart';
import 'package:epic/Screens/DCScreen.dart';
import 'package:epic/Screens/MarvelScreen.dart';
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
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  final FirebaseApp app;

  const HomeScreen({super.key, required this.app});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseDatabase? _database;
  DatabaseReference? _bannerRF;
  DatabaseReference? _comics;
  TextEditingController search = TextEditingController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instanceFor(app: widget.app);
    _bannerRF = _database!.ref().child('Banners');
    _comics = _database!.ref().child('Comic');
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200.h,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 23, 15, 40),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20).r,
                    bottomRight: Radius.circular(20).r,
                  )),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 25).r,
                child: Text(
                  'Dive into your favorite comics and embark on new adventures!',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 5, bottom: 5).r,
                child: Text(
                  'Vintage Superheros',
                  style: GoogleFonts.josefinSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8).r,
              child: GestureDetector(
                onTap: () {
                  Get.to(() => MarvelScreen(app: widget.app));
                },
                child: Container(
                  height: 180.h,
                  width: 400.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/marvel.jpg')),
                    borderRadius: BorderRadius.circular(25).r,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8).r,
              child: GestureDetector(
                onTap: () {
                  Get.to(() => DCScreen(app: widget.app));
                },
                child: Container(
                  height: 190.h,
                  width: 400.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/dc.jpg')),
                    borderRadius: BorderRadius.circular(25).r,
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 5, bottom: 5).r,
                child: Text(
                  'Recommended',
                  style: GoogleFonts.josefinSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            FutureBuilder<dynamic>(
              future: getComic(_comics),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text('No comics found'));
                } else {
                  List<Comic> comics = <Comic>[];
                  snapshot.data.forEach((item) {
                    var comic = Comic.fromjson(json.decode(json.encode(item)));
                    comics.add(comic);
                  });

                  return homeGrid(comics);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
