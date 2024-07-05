import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:epic/Widgets/gridView.dart';
import 'package:epic/helpers/styles.dart';
import 'package:epic/logic/homeController.dart';
import 'package:epic/models/comics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeroListScreen extends StatefulWidget {
  final FirebaseApp app;
  final String title;

  const HeroListScreen({super.key, required this.app, required this.title});

  @override
  State<HeroListScreen> createState() => _HeroListScreenState();
}

class _HeroListScreenState extends State<HeroListScreen> {
  FirebaseDatabase? _database;
  DatabaseReference? _bannerRF;
  DatabaseReference? _comics;
  TextEditingController search = TextEditingController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instanceFor(app: widget.app);
    _bannerRF = _database!.ref().child('ComicBanner');
    _comics = _database!.ref().child(widget.title);
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.title,
            style: meduimStyle,
          ),
          backgroundColor: bgColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: FutureBuilder<List<String>>(
          future: getBanners(_bannerRF),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    child: FutureBuilder<dynamic>(
                      future: getComic(_comics),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return Center(child: Text('No comics found'));
                        } else {
                          List<Comic> comics = <Comic>[];
                          snapshot.data.forEach((item) {
                            var comic =
                                Comic.fromjson(json.decode(json.encode(item)));
                            comics.add(comic);
                          });

                          return HeroView(comics);
                        }
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ));
  }
}
