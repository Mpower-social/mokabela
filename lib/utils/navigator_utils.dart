import 'package:flutter/material.dart';

class NavigatorUtils {
  static void push(BuildContext context, Widget widget) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  static void pushAndListenToOnBack({
    required BuildContext context,
    required Widget widget,
    required Function onBackListener,
  }) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(builder: (context) => widget),
        )
        .then((value) => onBackListener());
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void pushAndRemoveUntil(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (route) => false,
    );
  }
}
