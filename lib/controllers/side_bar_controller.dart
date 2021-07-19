import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideBarController extends GetxController
    with SingleGetTickerProviderMixin {
  final animationDuration = const Duration(milliseconds: 500);
  late AnimationController animationController;
  var isSideBarOpened = false.obs;

  @override
  void onInit() {
    super.onInit();
    animationController =
        AnimationController(vsync: this, duration: animationDuration);
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void onIconPressed() {
    final animationStatus = animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSideBarOpened.value = false;
      animationController.reverse();
    } else {
      isSideBarOpened.value = true;
      animationController.forward();
    }
  }
}
