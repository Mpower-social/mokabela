import 'dart:convert';
import 'package:app_builder/database/database_helper.dart';
import 'package:app_builder/form_definition/model/dto/form_item.dart';
import 'package:app_builder/module/model/dto/module_item.dart';
import 'package:app_builder/service/remote_service.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class SyncController extends GetxController {
  var communicationWithServer = false.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  Future<void> startSync() async {
    communicationWithServer.value = true;
    await startAppSync();
    await startDataSync();
    communicationWithServer.value = false;
  }

  Future<void> startAppSync() async {
    await Future.wait([
      fetchFormsConfig(),
      fetchModuleConfig(),
      fetchListConfig(),
      fetchFormsList(),
    ]);
  }

  Future<void> startDataSync() async {
    await Future.wait([
      fetchDataFromServer(),
      sendDataToServer(),
    ]);
  }

  Future<void> fetchFormsConfig() async {
    var db = await DatabaseHelper.instance.database;
    var appLogs = await db.rawQuery(
        'SELECT * FROM $TABLE_NAME_APP_LOG ORDER BY time DESC LIMIT 1');
    var lastSyncTime = 0;

    if (appLogs.isNotEmpty) lastSyncTime = appLogs.first['time'] as int;

    var formConfigs = await RemoteService().fetchFormConfigs(lastSyncTime);
    formConfigs.forEach((formConfig) {
      if (formConfig.updatedAt > lastSyncTime)
        lastSyncTime = formConfig.updatedAt;

      formConfig.sqlScript.split(";").forEach((element) {
        if (element.isNotEmpty) {
          try {
            db.execute(element).onError((error, stackTrace) {
              print(error);
            });
          } catch (e) {
            print(e);
          }
        }
      });
    });

    db.insert(
      TABLE_NAME_APP_LOG,
      {'time': lastSyncTime},
    );
  }

  Future<void> fetchModuleConfig() async {
    var db = await DatabaseHelper.instance.database;
    var module = await RemoteService().fetchModules();
    if (module != null) {
      db.insert(
        TABLE_NAME_MODULE_ITEM,
        {
          'app_id': 1,
          'app_name': 'Bahis',
          'definition': moduleItemToJson(module),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> fetchListConfig() async {
    var db = await DatabaseHelper.instance.database;
    var listDefinitions = await RemoteService().fetchListDefinitions();
    listDefinitions.forEach((listDefinition) {
      try {
        db.insert(
          TABLE_NAME_LIST_ITEM,
          listDefinition.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } catch (e) {
        print(e);
      }
    });
  }

  Future<void> fetchFormsList() async {
    var db = await DatabaseHelper.instance.database;
    var formItems = await RemoteService().fetchFormItems();
    formItems.forEach((formItem) {
      try {
        db.insert(
          TABLE_NAME_FORM_ITEM,
          formItem.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } catch (e) {
        print(e);
      }
    });
  }

  Future<void> sendDataToServer() async {}

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
}
