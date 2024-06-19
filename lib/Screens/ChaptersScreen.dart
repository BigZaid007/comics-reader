import 'package:epic/Screens/ComicReader.dart';
import 'package:epic/Widgets/customAppBar.dart';
import 'package:epic/Widgets/gridView.dart';
import 'package:epic/models/chapterts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChaptersScreen extends StatefulWidget {
  final List<Chapters> chapters;
  final String comicTitle;

  const ChaptersScreen(
      {super.key, required this.chapters, required this.comicTitle});

  @override
  State<ChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {
  late Future<List<Chapters>> futureChapters;

  @override
  void initState() {
    futureChapters = Future.value(widget.chapters);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(widget.comicTitle, 20),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                  future: futureChapters,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                          strokeWidth: 1,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('${snapshot.error}'),
                      );
                    } else {
                      var chapter = snapshot.data!;

                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                            itemCount: snapshot.data!.length - 1,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  if (chapter[index].links != null) {
                                    Get.to(() => ComicReader(
                                        chapter[index].links!,
                                        chapter[index].name!));
                                  } else {
                                    showNoChapters(context);
                                  }
                                },
                                child: Card(
                                  child: ListTile(
                                    title:
                                        Text(chapter[index].name ?? 'no name'),
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                  })
            ],
          ),
        ));
  }
}
