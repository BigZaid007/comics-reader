import 'package:epic/Screens/LandingPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  final FirebaseApp app;

  const SplashScreen({super.key, required this.app});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/images/splash.MP4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        Future.delayed(Duration(seconds: 2, milliseconds: 500), () {
          Get.to(LandingPage(
            app: widget.app,
          ));
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
