import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget commonButton(
    {required String text,
    required Color bg,
    Color? textColor,
    required Function? tap,
    required double width,
    required double height,
    var isLoading = false}) {
  return Container(
    constraints: BoxConstraints(minHeight: height, minWidth: width),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.transparent,
    ),
    child: ElevatedButton(
      onPressed: tap != null ? () => tap() : null,
      style: ElevatedButton.styleFrom(
          primary: bg,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: isLoading?const CircularProgressIndicator():Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 15,
        ),
      ),
    ),
  );
}