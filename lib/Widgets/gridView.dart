import 'package:cached_network_image/cached_network_image.dart';
import 'package:epic/Screens/ChaptersScreen.dart';
import 'package:epic/models/comics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget comicsGrid(List<Comic> comics) {
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.65,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
    ),
    itemCount: comics.length,
    itemBuilder: (context, index) {
      final comic = comics[index];
      return GestureDetector(
        onTap: () {
          comic.chapterts != null
              ? Get.to(() => ChaptersScreen(
                    chapters: comic.chapterts!,
                    comicTitle: comic.name!,
                  ))
              : showNoChapters(context);
        },
        child: Card(
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  child: CachedNetworkImage(
                    imageUrl: comic.image!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(
                      strokeWidth: 1,
                      color: Colors.black,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
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
        ),
      );
    },
  );
}

showNoChapters(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Stay tunned'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('No Chapters found yet in this comic')],
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('Ok'))
          ],
        );
      });
}
