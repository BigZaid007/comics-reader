import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:epic/Widgets/gridView.dart';
import 'package:epic/logic/homeController.dart';
import 'package:epic/models/comics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class mangaScreen extends StatefulWidget {
  final FirebaseApp app;

  const mangaScreen({super.key, required this.app});

  @override
  State<mangaScreen> createState() => _mangaScreenState();
}

class _mangaScreenState extends State<mangaScreen> {
  FirebaseDatabase? _database;
  DatabaseReference? _bannerRF;
  DatabaseReference? _comics;
  TextEditingController search = TextEditingController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instanceFor(app: widget.app);
    _bannerRF = _database!.ref().child('MangaBanner');
    _comics = _database!.ref().child('Manga');
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: CarouselSlider(
                  items: snapshot.data!.map((e) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: CachedNetworkImage(
                        imageUrl: e,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(
                          strokeWidth: 1,
                          color: Colors.black,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    viewportFraction: 1,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<dynamic>(
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
                        var comic =
                            Comic.fromjson(json.decode(json.encode(item)));
                        comics.add(comic);
                      });

                      return comicsGrid(comics);
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
