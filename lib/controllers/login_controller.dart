import 'dart:convert';
import 'package:app_builder/database/database_helper.dart';
import 'package:app_builder/service/remote_service.dart';
import 'package:app_builder/user/model/catchment.dart';
import 'package:app_builder/utils/constant_util.dart';
import 'package:app_builder/utils/preference_util.dart';
import 'package:app_builder/views/dashboard_page.dart';
import 'package:app_builder/views/side_bar_layout.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class LoginController extends GetxController {
  var communicatingWithServer = false.obs;
  var passwordVisible = true.obs;
  var userPassword = "".obs;
  var userName = "".obs;

  var divisions = List<Catchment>.empty(growable: true).obs;
  var districts = List<Catchment>.empty(growable: true).obs;
  var upazilas = List<Catchment>.empty(growable: true).obs;

  var selectedDivision;
  var selectedDistrict;
  var selectedUpazila;

  late Database db;

  @override
  void onInit() async {
    super.onInit();

    db = await DatabaseHelper.instance.database;
    fetchCatchments();
  }

  Future<void> fetchCatchments() async {
    var divCatchments = await db.rawQuery(
        'SELECT DISTINCT division, division_label FROM $TABLE_NAME_CATCHMENT');
    if (divCatchments.isNotEmpty)
      divisions.assignAll(catchmentsFromJson(divCatchments));
  }

  Future<void> setSelectedDivision(Catchment? value) async {
    selectedDivision = value;
    var disCatchemnts = await db.rawQuery(
        'SELECT DISTINCT district, dist_label FROM $TABLE_NAME_CATCHMENT WHERE division = ${value?.division}');
    if (disCatchemnts.isNotEmpty)
      districts.assignAll(catchmentsFromJson(disCatchemnts));
  }

  Future<void> setSelectedDistrict(Catchment? value) async {
    selectedDistrict = value;
    var upaCatchemnts = await db.rawQuery(
        'SELECT DISTINCT upazila, upazila_label FROM $TABLE_NAME_CATCHMENT WHERE district = ${value?.district}');
    if (upaCatchemnts.isNotEmpty)
      upazilas.assignAll(catchmentsFromJson(upaCatchemnts));
  }

  void togglePassword() {
    passwordVisible.value = !passwordVisible.value;
  }

  void updateUserMobile(String mobile) {
    userName.value = mobile;
  }

  void updateUserPassword(String password) {
    userPassword.value = password;
  }

  Future handleLogin() async {
    communicatingWithServer.value = true;

    var connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      var user = await RemoteService().handleLogin(
          userName.value, userPassword.value, selectedUpazila.upazila);

      if (user != null) {
        PreferenceUtil.setValue(PreferenceUtil.KEY_LOGGED_IN, true);
        PreferenceUtil.setValue(PreferenceUtil.KEY_USERID, user.userName);
        PreferenceUtil.setValue(
            PreferenceUtil.KEY_USER, json.encode(user.toJson()));

        initializeOdkCollectThroughChannel(user.userName);

        Get.offAll(() => SideBarLayout(
              user: user,
            ));
      } else {
        Get.snackbar(
          'Error',
          'Invalid credentials, try again...',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Warning',
        'You are not connected to internet, please check...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    communicatingWithServer.value = false;
  }

  initializeOdkCollectThroughChannel(String username) async {
    try {
      ConstantUtil.PLATFORM
          .invokeMethod('initializeOdk', {"username": username});
    } on PlatformException catch (_) {
      Get.snackbar(
        'Warning!',
        'Unable to initialize ODK',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
