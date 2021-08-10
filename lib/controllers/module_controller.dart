import 'package:app_builder/database/database_helper.dart';
import 'package:app_builder/form_definition/model/dto/form_item.dart';
import 'package:app_builder/utils/constant_util.dart';
import 'package:app_builder/utils/form_util.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModuleController extends GetxController {
  var communicationWithServer = false.obs;

  openForm(int formId) async {
    var db = await DatabaseHelper.instance.database;
    var dbForms = await db.rawQuery(
        'SELECT * FROM $TABLE_NAME_FORM_ITEM WHERE id = $formId LIMIT 1');

    if (dbForms.isNotEmpty && dbForms.first['name'] != null) {
      var formItem = FormItem.fromLocalJson(dbForms.first);

      var instancePath = await ConstantUtil.PLATFORM.invokeMethod(
        'openForms',
        {
          "formId": formItem.name,
        },
      );

      FormUtil().parseFormAndSaveToTable(instancePath, formItem);
    } else {
      Get.snackbar(
        'Warning!',
        'Related form not found.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  fetchDataAndUpdate() async {
    if (communicationWithServer.value) return;

    communicationWithServer.value = true;

    var formUtil = FormUtil();
    var connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      await formUtil.fetchDataFromServer();
      await formUtil.fetchFormItemsAndGenerateCsv();
    } else {
      Get.snackbar(
        'Warning!',
        'Check your internet connection and try again',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    }

    communicationWithServer.value = false;
  }
}
