import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class homeScreen extends StatefulWidget {

  final FirebaseApp app;

  const homeScreen({super.key, required this.app});

  

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {

FirebaseDatabase? _database;
DatabaseReference? _bannerRF;

@override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instanceFor(app: widget.app);
    _bannerRF = _database!.ref().child('Banners');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test'),),
      body: FutureBuilder<List<String>>(
        future: _getBanners(_bannerRF),
        builder: (context, snapshot) {
          
          if(snapshot.connectionState == ConnectionState.waiting)
          {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else
          {
            return Column(
              children: [
                CarouselSlider(items: snapshot.data!.map((e) => Builder(
                  builder: (context)
                  {
                      return Image.network(e,fit: BoxFit.cover,);
                  }
                  
                
                
                )).toList(), options: CarouselOptions(
                  autoPlay: true,
                  viewportFraction: 1
                ))

              ],
            );
          }
         
        },
      )
    );
  }
}

Future<List<String>> _getBanners(DatabaseReference? bannerRF) async {
  if (bannerRF == null) {
    return [];
  }

  try {
    DatabaseEvent event = await bannerRF.once();
    DataSnapshot snapshot = event.snapshot;
    
    if (snapshot.value == null) {
      return [];
    }

    if (snapshot.value is List) {
      return (snapshot.value as List).map((e) => e.toString()).toList();
    } else if (snapshot.value is Map) {
      return (snapshot.value as Map).values.map((e) => e.toString()).toList();
    } else {
      return [snapshot.value.toString()];
    }
  } catch (e) {
    print("Error fetching banners: $e");
    return [];
  }
}