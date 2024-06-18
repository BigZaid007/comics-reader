import 'package:firebase_database/firebase_database.dart';

Future<List<String>> getBanners(DatabaseReference? bannerRF) async {
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


Future<dynamic> getComic(DatabaseReference? comics) async {
  if (comics == null) {
    return null;
  }

  try {
    DatabaseEvent event = await comics.once();
    DataSnapshot snapshot = event.snapshot;

    return snapshot.value;
  } catch (e) {
    print("Error fetching comics: $e");
    return null;
  }
}