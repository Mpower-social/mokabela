import 'package:animator/animator.dart';
import 'package:app_builder/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatelessWidget {
  final splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Animator<double>(
          duration: Duration(seconds: 1),
          cycles: 0,
          builder: (context, animatorState, child) => FadeTransition(
            opacity: animatorState.controller,
            child: Image.asset(
              "assets/images/ic_app_icon.png",
              width: 300,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}
