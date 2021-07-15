import 'dart:convert';

import 'package:app_builder/form_config/model/dto/form_config.dart';
import 'package:app_builder/form_definition/model/dto/form_item.dart';
import 'package:app_builder/list_definition/model/dto/list_definition.dart';
import 'package:app_builder/module/model/dto/module_item.dart';
import 'package:app_builder/sync_data/model/data_item.dart';
import 'package:http/http.dart' as http;

class RemoteService {
  final String baseUrl = 'http://dyn-bahis-dev.mpower-social.com:8043';
  var client = http.Client();

  Future<List<FormConfig>> fetchFormConfigs(int lastSyncTime) async {
    try {
      var url = Uri.parse(
          '$baseUrl/bhmodule/bahis_ulo/get/form-config/$lastSyncTime/');
      final response = await client.get(url);

      if (response.statusCode == 200) {
        return formConfigFromJson(utf8.decode(response.bodyBytes));
      }

      return [];
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<ModuleItem?> fetchModules() async {
    try {
      var url = Uri.parse('$baseUrl/bhmodule/bahis_ulo/get-api/module-list/');
      final response = await client.get(url);

      if (response.statusCode == 200) {
        return moduleItemFromJson(utf8.decode(response.bodyBytes));
      }

      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<FormItem>> fetchFormItems() async {
    try {
      var url = Uri.parse('$baseUrl/bhmodule/bahis_ulo/get-api/form-list/');
      final response = await client.get(url);

      if (response.statusCode == 200) {
        return formItemsFromJson(utf8.decode(response.bodyBytes));
      }

      return [];
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ListDefinition>> fetchListDefinitions() async {
    try {
      var url = Uri.parse('$baseUrl/bhmodule/bahis_ulo/get-api/list-def/');
      final response = await client.get(url);

      if (response.statusCode == 200) {
        return listDefinitionsFromJson(utf8.decode(response.bodyBytes));
      }

      return [];
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<DataItem>> fetchDataItems(int lastSyncTime) async {
    try {
      var url = Uri.parse(
          '$baseUrl/bhmodule/form/bahis_ulo/data-sync/?last_modified=$lastSyncTime');
      final response = await client.get(url);

      if (response.statusCode == 200) {
        return dataItemsFromJson(utf8.decode(response.bodyBytes));
      }

      return [];
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
