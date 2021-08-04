import 'package:app_builder/database/database_helper.dart';
import 'package:app_builder/utils/constant_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModuleController extends GetxController {
  openForm(int formId) async {
    var db = await DatabaseHelper.instance.database;
    var dbForms = await db.rawQuery(
        'SELECT * FROM $TABLE_NAME_FORM_ITEM WHERE id = $formId LIMIT 1');

    if (dbForms.isNotEmpty && dbForms.first['name'] != null) {
      ConstantUtil.PLATFORM.invokeMethod(
        'openForms',
        {
          "formId": dbForms.first['name'],
        },
      );
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
}
