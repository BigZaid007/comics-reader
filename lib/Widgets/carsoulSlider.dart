import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';

Widget carouselSlider() {
  List<String> images = [
    'https://i.pinimg.com/564x/b0/66/48/b06648601ea122a054f4f15d3e1f167c.jpg',
    'https://i.pinimg.com/564x/f5/72/d2/f572d2cb2b693e52af5f0210ae722c54.jpg',
    'https://i.pinimg.com/564x/e2/a4/44/e2a444134fa031c1e2fdcc1de41d66c1.jpg',
    'https://i.pinimg.com/564x/a1/9e/16/a19e164915a0655edee0a49d5f6a5ee1.jpg'
  ];
  return CarouselSlider.builder(
    itemCount: images.length,
    itemBuilder: (context, index, realIndex) {
      return AspectRatio(
        aspectRatio: 16 / 9, // Adjust this aspect ratio as needed
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(images[index]),
              fit: BoxFit.cover, // Ensures the image covers the space
            ),
          ),
        ),
      );
    },
    options: CarouselOptions(
      autoPlay: true,
      aspectRatio: 16 / 9, // Adjust this aspect ratio as needed
      enlargeCenterPage: true, // Optional: to highlight the current item
    ),
  );
}
