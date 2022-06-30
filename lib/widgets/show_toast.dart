import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast({msg, isError = false}) {

  return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: isError == false ? Colors.green : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}