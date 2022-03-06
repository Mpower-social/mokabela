import 'package:app_builder/database/database_helper.dart';
import 'package:app_builder/module/model/dto/catchment_area.dart';
import 'package:app_builder/module/model/dto/module_item.dart';
import 'package:app_builder/service/remote_service.dart';
import 'package:app_builder/utils/form_util.dart';
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
    var formUtil = FormUtil();

    try {
      await formUtil.sendDataToServer();
      await startAppSync();
      await formUtil.fetchDataFromServer();
      formUtil.fetchFormItemsAndGenerateCsv();
    } catch (e) {
      print(e);
    }
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

      await deleteAndSaveCatchmentArea(db, module.catchmentArea);
    }
  }

  Future<void> fetchListConfig() async {
    var db = await DatabaseHelper.instance.database;
    try {
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
    } catch (e) {
      print(e);
    }
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

  deleteAndSaveCatchmentArea(Database db, List<CatchmentArea> catchmentArea) {
    db.execute('DELETE FROM geo_cluster');

    catchmentArea.forEach((area) {
      try {
        db.rawInsert(
            "INSERT INTO geo_cluster (value, name, loc_type , parent) VALUES ('${area.value}', '${area.name}', '${area.locType}', '${area.parent}')");
      } catch (e) {
        print(e);
      }
    });
  }
}
