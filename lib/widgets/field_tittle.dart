import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget title({String title = '', double wp = 0, Color color = Colors.black}) {
  return wp == 0
      ? Text(title,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15, color: color))
      : SizedBox(
          width: wp,
          child: Text(
            title,
            style: TextStyle(fontSize: 15, color: color),
          ));
}
