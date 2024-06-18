import 'package:flutter/material.dart';

AppBar customAppBar(String title , double fontSize)
{
  return AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'RobotoSlab',
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            color: Colors.white
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 157, 130, 203), Color.fromARGB(255, 185, 102, 76)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      
      );
}