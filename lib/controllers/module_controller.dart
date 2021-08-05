import 'dart:convert';
import 'dart:io';

import 'package:app_builder/database/database_helper.dart';
import 'package:app_builder/form_definition/model/dto/form_item.dart';
import 'package:app_builder/form_definition/model/dto/geo_definition.dart';
import 'package:app_builder/service/remote_service.dart';
import 'package:app_builder/utils/constant_util.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ModuleController extends GetxController {
  var communicationWithServer = false.obs;

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

  fetchDataAndUpdate() async {
    if (communicationWithServer.value) return;

    communicationWithServer.value = true;

    var connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      await fetchDataFromServer();
      await fetchFormItemsAndGenerateCsv();
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

  Future<void> fetchDataFromServer() async {
    var db = await DatabaseHelper.instance.database;
    var appLogs = await db.rawQuery(
        'SELECT MAX(updated_at) AS lastSyncTime FROM $TABLE_NAME_DATA_ITEM');
    var lastSyncTime = 0;

    if (appLogs.isNotEmpty)
      lastSyncTime = (appLogs.first['lastSyncTime'] as int?) ?? 0;

    var dataItems = await RemoteService().fetchDataItems(lastSyncTime);
    dataItems.forEach((dataItem) async {
      try {
        db.insert(
          TABLE_NAME_DATA_ITEM,
          dataItem.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } catch (e) {
        print(e);
      }

      await parseAndSaveToFlatTables(
        db,
        dataItem.id,
        dataItem.json,
        dataItem.xformId,
      );
    });
  }

  Future<void> parseAndSaveToFlatTables(
      Database db, int? id, String userJson, int xformId) async {
    var dbValue = await db.rawQuery(
      'SELECT * FROM $TABLE_NAME_FORM_ITEM WHERE id = ? LIMIT 1',
      [xformId],
    );
    if (dbValue.isNotEmpty) {
      var formItem = FormItem.fromLocalJson(dbValue.first);
      var formDefinition = formItem.formDefinition;
      var fieldNames = json.decode(formItem.fieldNames);
      var userData = json.decode(userJson);

      await findFieldValuesFromUserData(
        db,
        'bahis_${formDefinition?.idString}',
        "",
        userData,
        id != null ? id.toString() : userData['meta/instanceID'],
        null,
        "",
        fieldNames,
      );
    }
  }

  Future<void> findFieldValuesFromUserData(
    Database db,
    String tableName,
    String parentTableName,
    Map<String, dynamic> userData,
    String? instanceId,
    int? parentId,
    String lastRepeatKeyName,
    List fieldNames,
  ) async {
    var columnNames = '';
    var fieldValues = '';
    var repeatKeys = [];

    for (var key in userData.keys) {
      if (fieldNames.contains(key)) {
        if (userData[key] is List &&
            userData[key].length > 0 &&
            isNotArrayOfString(userData[key])) {
          repeatKeys.add(key);
        } else {
          var tmpColumnName = key.substring(
              lastRepeatKeyName.length > 0 ? lastRepeatKeyName.length + 1 : 0);
          tmpColumnName = tmpColumnName.replaceAll('/', '_');
          columnNames = '${columnNames + tmpColumnName}, ';
          fieldValues = '$fieldValues"${userData[key]}", ';
        }
      }
    }

    var newParentId;
    if (columnNames.isNotEmpty || repeatKeys.length > 0) {
      if (instanceId != null) {
        columnNames += 'instanceid, ';
        fieldValues += '"$instanceId", ';
      }
      if (parentId != null) {
        columnNames += '${parentTableName.substring(6)}_id, ';
        fieldValues += '"$parentId", ';
      }

      var sql = 'INSERT INTO ${tableName}_table (${columnNames.substring(
        0,
        columnNames.length - 2,
      )}) VALUES (${fieldValues.substring(0, fieldValues.length - 2)})';

      try {
        var id = await db.rawInsert(sql);
        newParentId = id;
      } catch (e) {
        print(e);
      }
    }

    repeatKeys.forEach((key) {
      userData[key].forEach((elm) {
        findFieldValuesFromUserData(
          db,
          '${tableName}_${key.replaceAll('/', '_')}',
          tableName,
          elm,
          instanceId,
          newParentId,
          key,
          fieldNames,
        );
      });
    });
  }

  bool isNotArrayOfString(List testArray) {
    var isObjectFound = false;
    testArray.forEach((element) {
      if (element is Object) isObjectFound = true;
    });

    return isObjectFound;
  }

  fetchFormItemsAndGenerateCsv() async {
    var db = await DatabaseHelper.instance.database;
    var dbForms =
        await db.rawQuery('SELECT * FROM $TABLE_NAME_FORM_ITEM ORDER BY id');

    if (dbForms.isNotEmpty) {
      dbForms.forEach((dbForm) async {
        var formItem = FormItem.fromLocalJson(dbForm);
        await prepareAndGenerateCsv(db, formItem);
      });
    }
  }

  prepareAndGenerateCsv(Database db, FormItem formItem) async {
    var directory = await getExternalStorageDirectory();

    if (directory != null) {
      var path =
          '${directory.path}/forms/${formItem.formDefinition?.title}-media';
      var rootDirectory = Directory(path);
      if (!rootDirectory.existsSync()) rootDirectory.createSync();

      if (formItem.choiceList?.division != null)
        await createCsv(db, rootDirectory, formItem.choiceList!.division!);

      if (formItem.choiceList?.geo != null)
        await createCsv(db, rootDirectory, formItem.choiceList!.geo!);

      if (formItem.choiceList?.geoDivision != null)
        await createCsv(db, rootDirectory, formItem.choiceList!.geoDivision!);

      if (formItem.choiceList?.geoDistrict != null)
        await createCsv(db, rootDirectory, formItem.choiceList!.geoDistrict!);

      if (formItem.choiceList?.staff != null)
        await createCsv(db, rootDirectory, formItem.choiceList!.staff!);

      if (formItem.choiceList?.medicine != null)
        await createCsv(db, rootDirectory, formItem.choiceList!.medicine!);
    }
  }

  createCsv(Database db, Directory rootDirectory, GeoDefinition geo) async {
    var csvFile = File('${rootDirectory.path}/${geo.configJson!.csvName}.csv');

    if (csvFile.existsSync()) csvFile.deleteSync();
    csvFile.createSync();

    var csvContents = await db.rawQuery(geo.query!);
    if (csvContents.isNotEmpty) {
      csvFile.writeAsStringSync('${csvContents.first.keys.join(",")}\n',
          mode: FileMode.append);

      csvContents.forEach((content) {
        csvFile.writeAsStringSync('${content.values.join(",")}\n',
            mode: FileMode.append);
      });
    }
  }
}
