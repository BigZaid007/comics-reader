import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:epic/Screens/ChaptersScreen.dart';
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

class DCScreen extends StatefulWidget {
  final FirebaseApp app;

  const DCScreen({super.key, required this.app});

  @override
  State<DCScreen> createState() => _DCScreennState();
}

class _DCScreennState extends State<DCScreen> {
  FirebaseDatabase? _database;
  DatabaseReference? _comics;

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instanceFor(app: widget.app);
    _comics = _database!.ref().child('DC');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/dc-heros.jpg'))),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 25)
                        .r,
                    child: Text(
                      'Enjoy the Adventures of DC Heroes!',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24.sp,
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
                      return Center(
                          child: CircularProgressIndicator(
                        strokeWidth: 1,
                        color: Colors.white,
                      ));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Center(child: Text('No comics found'));
                    } else {
                      List<Comic> comics = <Comic>[];
                      snapshot.data.forEach((item) {
                        var comic =
                            Comic.fromjson(json.decode(json.encode(item)));
                        comics.add(comic);
                      });

                      return homeGrid(comics);
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}
