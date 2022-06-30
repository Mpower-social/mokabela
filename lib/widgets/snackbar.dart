import 'package:flutter/material.dart';
import 'package:get/get.dart';
 showSnackbar({msg, isError = false}) {
  // return Get.showSnackbar(GetBar(
  //   title: isError == false ? "Alert" : "Error",
  //   message: msg,
  //   isDismissible: false,
  //   backgroundColor: isError == false ? Colors.green : Colors.red,
  //   duration: Duration(seconds: 2),
  // ));
  return Get.snackbar(isError == false ? "Alert" : "Error", msg,
      backgroundColor: isError == false ? Colors.green : Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM);
}
