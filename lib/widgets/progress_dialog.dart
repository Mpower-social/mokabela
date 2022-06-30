import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

progressDialog(){
  return Get.dialog(
      Center(
        key: ValueKey(2),
        child: Container(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(

          ),
        ),
      ),
    barrierDismissible:false,
  );
}