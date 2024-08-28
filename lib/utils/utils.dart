import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:m_survey/utils/shared_pref.dart';
import 'package:m_survey/views/login_type_screen.dart';

import '../views/login_screen.dart';

class Utils {
  static final dateFormat = DateFormat('dd-MM-yyyy');
  static final timeFormat = DateFormat('hh:mm a');
  static NumberFormat numberFormatter = new NumberFormat("00");

  // compress file and get.
  static Future<Uint8List?> compressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 60,
    );
    return result;
  }

  static Future<File?> compressImage(File file, File targetFile) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetFile.absolute.path,
        quality: 80);
    return result;
  }

  static String addZeroForMonth(String month) {
    if (month.isEmpty) return "";
    if (month.length == 1) return "0" + month;
    return month;
  }

  static Uint8List getImageFromBase64(String base64image) {
    final byteImage = const Base64Decoder().convert(base64image);
    return byteImage;
  }

  static String? validateMobile(String value) {
    String pattern = r'(^01[0-9][0-9]{8})';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return '${'mobile'.tr} ${'must'.tr}';
    } else if (value.length < 11) {
      return 'মোট ১১ ডিজিট এর হতে হবে';
    } else if (!regExp.hasMatch(value)) {
      return 'মোবাইল নম্বরটি 01 দিয়ে শুরু হতে হবে';
    }
    return null;
  }

  static String? validatePassword(String value) {
    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
    if (value.isEmpty) {
      return '৮ অক্ষর/সংখ্যা এর পাসওয়ার্ড দিন';
    } else {
      if (!regex.hasMatch(value)) {
        return 'অন্তত একটি বড় হাতের অক্ষর, একটি ছোট হাতের অক্ষর, একটি সংখ্যা থাকতে হবে';
      } else {
        return null;
      }
    }
  }

  static String? validateEmail(String value) {
    RegExp regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value.isEmpty) return '${'email'.tr} ${'must'.tr}';
    /* if (!regex.hasMatch(value)) {
        return 'email_not_valid'.tr;
      } else {
        return null;
      }*/
    return null;
  }

  static timeStampToDate(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return dateFormat.format(date);
  }

  static timeStampToTime(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return timeFormat.format(date);
  }

  static logoutOperation() {
    SharedPref.sharedPref.clear();
    Get.offAll(() => LoginTypeScreen());
  }
}
