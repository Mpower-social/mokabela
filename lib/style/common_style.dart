import 'package:flutter/material.dart';

class CommonStyle {
  ///textfield style
  static InputDecoration textFieldStyle({
    String labelTextStr = "",
    String hintTextStr = "",
    double verPadding = 0.0,
    double horPadding = 0.0,
    Color fillColor = Colors.white,
    Color borderColor = Colors.grey,
    InputBorder inputBorder = InputBorder.none,

  }) {
    return InputDecoration(
      border: inputBorder,
      alignLabelWithHint: true,
      fillColor: fillColor,
      hintText: hintTextStr,
      hintStyle: TextStyle(
        color: borderColor
      ),
      suffixStyle: TextStyle(
        color: borderColor
      ),

      contentPadding: EdgeInsets.symmetric(
          vertical: verPadding, horizontal: horPadding),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide:  BorderSide(color:  borderColor)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide:  BorderSide(color: borderColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide:  BorderSide(color: borderColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide:  BorderSide(color: borderColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: borderColor),
      ),
    );
  }
  static InputDecoration textFieldStyleWithHint({
    String hintTextStr = "",
    double verPadding = 0.0,
    double horPadding = 0.0,
  }) {
    return InputDecoration(
      border: InputBorder.none,
      alignLabelWithHint: true,
      fillColor: Colors.white,
      hintText: hintTextStr,
      filled: true,
      contentPadding: EdgeInsets.symmetric(
          vertical: verPadding, horizontal: horPadding),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.grey)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.grey),
      ),
    );
  }
  ///textfield style date picker
  static InputDecoration textFieldStyleDatePicker({
    String labelTextStr = "",
    String hintTextStr = "",
    double verPadding = 0.0,
    double horPadding = 0.0,
  }) {
    return InputDecoration(
        border: InputBorder.none,
        alignLabelWithHint: true,
        fillColor: Colors.white,
        hintText: hintTextStr,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: verPadding, horizontal: horPadding),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.grey)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        suffixIcon: const Icon(Icons.date_range));
  }



  ///text field style date picker
  static InputDecoration textFieldStyleSearch({
    String labelTextStr = "",
    String hintTextStr = "",
    double verPadding = 0.0,
    double horPadding = 0.0,
  }) {
    return InputDecoration(
        border: InputBorder.none,
        fillColor: Colors.white,
        hintText: hintTextStr,
        hintStyle: const TextStyle(
          color: Colors.grey
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: verPadding, horizontal: horPadding),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.grey)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        prefixIcon: const Icon(Icons.search));
  }

  ///border radius five with white bg
  static BoxDecoration decorationWithRadiusFive() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(5),
    );
  }
  static BoxDecoration decorationWithRadiusTen() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.blueAccent
    );
  }
}
