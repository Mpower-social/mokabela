import 'package:flutter/material.dart';

class PageUtils {
  static double getPageHeight(
      {required BuildContext context,
      double? appBarSize,
      double bottomNavigationBarSize = 0}) {
    var _pageSize = MediaQuery.of(context).size.height;
    var _notifySize = MediaQuery.of(context).padding.top;
    var _paddingBottom = MediaQuery.of(context).padding.bottom;
    var _appBarSize = appBarSize ?? AppBar().preferredSize.height;
    return _pageSize -
        _appBarSize -
        _notifySize -
        _paddingBottom -
        bottomNavigationBarSize;
  }

  static double getPageWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static removeFocus(BuildContext context) => hideKeyboard(context);
}
