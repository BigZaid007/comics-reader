import 'package:cached_network_image/cached_network_image.dart';
import 'package:epic/logic/comicController.dart';
import 'package:epic/logic/readerTranslateController.dart';
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
    final TranslateImageController translateImageController =
        Get.put(TranslateImageController());

    final RxString translatedText = ''.obs;

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
          IconButton(
            icon: Icon(Icons.translate),
            onPressed: () async {
              final currentImageUrl =
                  links[controller.currentPage.value]; // Get current image URL
              print('Current image URL: $currentImageUrl');
              final extractedText =
                  await translateImageController.extractText(currentImageUrl);
              if (extractedText.isNotEmpty) {
                translatedText.value =
                    await translateImageController.translateText(extractedText);
              } else {
                translatedText.value = 'No text found';
              }
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
                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: PhotoView(
                                  imageProvider:
                                      CachedNetworkImageProvider(links[index]),
                                  minScale: PhotoViewComputedScale.contained,
                                  maxScale: PhotoViewComputedScale.covered * 2,
                                  initialScale:
                                      PhotoViewComputedScale.contained,
                                  basePosition: Alignment.center,
                                  enableRotation: false,
                                  backgroundDecoration:
                                      BoxDecoration(color: Colors.black),
                                ),
                              ),
                              Obx(() {
                                if (translatedText.value.isNotEmpty) {
                                  return Positioned(
                                    bottom: 10,
                                    left: 10,
                                    right: 10,
                                    child: Container(
                                      color: Colors.black.withOpacity(0.5),
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        translatedText.value.replaceAll(
                                            '\n', ' '), // Remove line breaks
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12, // Smaller font size
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              }),
                            ],
                          );
                        },
                        itemCount: links.length,
                        onPageChanged: (index) {
                          controller.currentPage.value = index;
                          translatedText.value =
                              ''; // Clear translated text when page changes
                        },
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
