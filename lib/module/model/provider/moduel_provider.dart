import 'dart:convert';

import 'package:app_builder/module/model/dto/module_item.dart';
import 'package:flutter/services.dart' show rootBundle;

class ModuleProvider {
  Future<String> _loadModulesAsset() async {
    return await rootBundle.loadString('assets/json/module_list_json.json');
  }

  Future<ModuleItem> getModules() async {
    String jsonString = await _loadModulesAsset();
    final jsonResponse = json.decode(jsonString);
    return ModuleItem.fromJson(jsonResponse);
  }
}
