import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

 alertDialog(
{
  String title = '',
  String msg = '',
  String confirmText = 'Ok',
  Function? onOkTap,
  Color bgColor = Colors.white
}){
  return Get.defaultDialog(
    contentPadding: EdgeInsets.all(10),
    radius: 10,
    backgroundColor: bgColor,
    barrierDismissible: false,
    title: title,
    middleText: msg,
    onConfirm: ()=>onOkTap!(),
    textConfirm: confirmText,
  );
}