import 'package:epic/helpers/styles.dart';
import 'package:epic/logic/homeController.dart';
import 'package:flutter/material.dart';

Widget bottomBar(bottomBarController controller) {
  return BottomNavigationBar(
    backgroundColor: Color.fromARGB(255, 23, 15, 40),
    onTap: (index) {
      controller.currentIndex.value = index;
      print(controller.currentIndex);
    },
    currentIndex: controller.currentIndex.value,
    unselectedItemColor: Colors.grey,
    selectedItemColor: Colors.blue,
    items: [
      BottomNavigationBarItem(
        backgroundColor: bgColor,
        label: 'Home',
        icon: Icon(Icons.home),
      ),
      BottomNavigationBarItem(
        backgroundColor: bgColor,
        label: 'Manga',
        icon: Image.asset(
          'assets/images/manga.png',
          color: controller.currentIndex.value == 1 ? Colors.blue : Colors.grey,
          width: 20,
          height: 20,
        ),
      ),
      BottomNavigationBarItem(
        backgroundColor: bgColor,
        label: 'Comics',
        icon: Image.asset(
          'assets/images/comic.png',
          color: controller.currentIndex.value == 2 ? Colors.blue : Colors.grey,
          width: 20,
          height: 20,
        ),
      ),
      BottomNavigationBarItem(
        backgroundColor: bgColor,
        label: 'Downloads',
        icon: Image.asset(
          'assets/images/down.png',
          color: controller.currentIndex.value == 3 ? Colors.blue : Colors.grey,
          width: 20,
          height: 20,
        ),
      ),
    ],
  );
}
