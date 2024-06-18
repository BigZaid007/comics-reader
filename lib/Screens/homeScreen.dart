import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:epic/Widgets/customAppBar.dart';
import 'package:epic/logic/homeController.dart';
import 'package:epic/models/comics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  TextEditingController search=TextEditingController();

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
      appBar: customAppBar('Epic Comics', 22.0),
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
                Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                controller: search,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  suffixIcon: search.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.amber),
                          onPressed: () {
                            search.clear();
                          },
                        )
                      : null,
                  hintText: 'Search Comics',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
                      ),
                      
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: CarouselSlider(
                
                    items: snapshot.data!.map((e) {
                      return Builder(
                        builder: (context) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5.0,
                                  spreadRadius: 1.0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: CachedNetworkImage(
                                imageUrl: e,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(
                                  strokeWidth: 1,
                                  color: Colors.black,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          );
                        },
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
                          var comic = Comic.fromjson(
                              json.decode(json.encode(item)));
                          comics.add(comic);
                        });
                        
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: comics.length,
                          itemBuilder: (context, index) {
                            final comic = comics[index];
                            return Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              shadowColor: Colors.black45,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(15)),
                                      child: CachedNetworkImage(
                                        imageUrl: comic.image!,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(
                                          strokeWidth: 1,
                                          color: Colors.black,
                                        ),
                                        errorWidget:
                                            (context, url, error) =>
                                                Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5.0),
                                    child: Text(
                                      comic.category ?? 'General',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      comic.name!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}



