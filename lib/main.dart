import 'dart:io';

import 'package:epic/Screens/LandingPage.dart';
import 'package:epic/Screens/SplashScreen.dart';
import 'package:epic/Screens/homeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:riverpod/riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp(
      name: 'epic_comic',
      options: Platform.isIOS || Platform.isMacOS
          ? FirebaseOptions(
              apiKey: "AIzaSyAv69T1VYnQYpEP0cL-ttubE6ii0TJLtKY",
              appId: "1:348132926457:ios:95f0794d5f2c9ac500d328",
              messagingSenderId: '348132926457',
              projectId: "epic-a1e45")
          : FirebaseOptions(
              apiKey: "AIzaSyAv69T1VYnQYpEP0cL-ttubE6ii0TJLtKY",
              appId: "1:348132926457:android:2ffd27432ae5cd9400d328",
              messagingSenderId: '348132926457',
              projectId: "epic-a1e45"));
  runApp(ProviderScope(child: MyApp(app)));
}

class MyApp extends StatelessWidget {
  final FirebaseApp app;

  const MyApp(this.app);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child) {
          return GetMaterialApp(
              debugShowCheckedModeBanner: false, home: SplashScreen(app: app));
        });
  }
}
