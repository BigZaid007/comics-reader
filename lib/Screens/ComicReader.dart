// comic_reader.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:epic/logic/comicController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:photo_view/photo_view.dart';

class ComicReader extends StatelessWidget {
  final List<String> links;
  final String name;

  const ComicReader(this.links, this.name);

  @override
  Widget build(BuildContext context) {
    final ComicReaderController controller = Get.put(
      ComicReaderController(links: links, name: name),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          name,
          softWrap: true,
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              controller.downloadAndZipImages();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(value: controller.progress.value),
                SizedBox(height: 20),
                Text(
                    '${(controller.progress.value * 100).toStringAsFixed(2)}%'),
              ],
            ),
          );
        } else {
          return links.isNotEmpty
              ? Column(
                  children: [
                    Obx(() => LinearProgressIndicator(
                          value:
                              (controller.currentPage.value + 1) / links.length,
                        )),
                    Expanded(
                      child: PreloadPageView.builder(
                        controller: controller.pageController,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PhotoView(
                              imageProvider:
                                  CachedNetworkImageProvider(links[index]),
                              minScale: PhotoViewComputedScale.contained,
                              maxScale: PhotoViewComputedScale.covered * 2,
                              initialScale: PhotoViewComputedScale.contained,
                              basePosition: Alignment.center,
                              enableRotation: false,
                              backgroundDecoration:
                                  BoxDecoration(color: Colors.black),
                            ),
                          );
                        },
                        itemCount: links.length,
                      ),
                    ),
                    Obx(() => Text(
                          '${controller.currentPage.value + 1} of ${links.length}',
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                )
              : Center(
                  child: Text('Coming soon'),
                );
        }
      }),
    );
  }
}
