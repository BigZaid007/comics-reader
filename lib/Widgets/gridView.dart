import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:epic/Screens/ChaptersScreen.dart';
import 'package:epic/helpers/styles.dart';
import 'package:epic/models/comics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

Widget homeGrid(List<Comic> comics) {
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: (comics.length / 2).ceil(),
    itemBuilder: (context, index) {
      final int firstIndex = index * 2;
      final int secondIndex = firstIndex + 1;

      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                comics[firstIndex].chapterts != null
                    ? Get.to(() => ChaptersScreen(
                          chapters: comics[firstIndex].chapterts!,
                          comicTitle: comics[firstIndex].name!,
                        ))
                    : showNoChapters(context);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0)
                        .r,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20).r,
                  ),
                  shadowColor: Colors.black54,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20).r,
                    child: CachedNetworkImage(
                      width: 300.w,
                      height: 300.h,
                      imageUrl: comics[firstIndex].image!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (secondIndex < comics.length)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  comics[secondIndex].chapterts != null
                      ? Get.to(() => ChaptersScreen(
                            chapters: comics[secondIndex].chapterts!,
                            comicTitle: comics[secondIndex].name!,
                          ))
                      : showNoChapters(context);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0)
                          .r,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20).r,
                    ),
                    shadowColor: Colors.black54,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20).r,
                      child: CachedNetworkImage(
                        width: 300.w,
                        height: 300.h,
                        imageUrl: comics[secondIndex].image!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: Container(), // Empty container to balance the row
            ),
        ],
      );
    },
  );
}

Widget comicsGrid(List<Comic> comics) {
  return SizedBox(
    child: GridView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.5,
        crossAxisSpacing: 5,
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
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15).r,
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: bgColor.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  )
                ]),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              shadowColor: Colors.black45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10).r),
                      child: CachedNetworkImage(
                        imageUrl: comic.image!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(
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
                      style: lowStyleDark,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0).r,
                    child: Text(
                      comic.name!,
                      style: meduimStyleDark,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
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

Widget comicsGridHome(List<Comic> comics) {
  // Shuffle the comics list to display items in random order
  comics.shuffle(Random());

  return StaggeredGridView.countBuilder(
    crossAxisCount: 1,
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
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: Colors.black38,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: comic.image!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ),
              errorWidget: (context, url, error) =>
                  Icon(Icons.error, color: Colors.red),
            ),
          ),
        ),
      );
    },
    staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
    mainAxisSpacing: 10.0,
    crossAxisSpacing: 10.0,
    padding: EdgeInsets.all(10),
  );
}

Widget HeroView(List<Comic> comics) {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 1,
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
                padding: EdgeInsets.all(8.0).r,
                child: Text(
                  comic.name!,
                  style: mainStyleDark,
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
