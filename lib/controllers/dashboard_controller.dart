import 'package:app_builder/database/database_helper.dart';
import 'package:app_builder/module/model/dto/module_item.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final moduleItems = List<ModuleItem>.empty().obs;

  @override
  void onInit() async {
    super.onInit();

    fetchModuleConfig();
  }

  Future<void> fetchModuleConfig() async {
    var db = await DatabaseHelper.instance.database;
    var dbModules = await db.rawQuery(
        'SELECT * FROM $TABLE_NAME_MODULE_ITEM WHERE app_id = 1 LIMIT 1');
    if (dbModules.isNotEmpty && dbModules.first['definition'] != null) {
      var module = moduleItemFromJson(dbModules.first['definition'] as String);
      moduleItems.assign(module);
    }
  }
}
