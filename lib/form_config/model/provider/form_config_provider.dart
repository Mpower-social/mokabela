import 'dart:convert';

import 'package:app_builder/form_config/model/dto/form_config.dart';
import 'package:flutter/services.dart';

class FormConfigProvider {
  Future<String> _loadFormConfigsAsset() async {
    return await rootBundle.loadString('assets/json/form_config_json.json');
  }

  Future<List<FormConfig>> getFormConfigs() async {
    String jsonString = await _loadFormConfigsAsset();
    final jsonResponse = json.decode(jsonString);
    return (jsonResponse as List)
        .map((formConfig) => FormConfig.fromJson(formConfig))
        .toList();
  }
}
