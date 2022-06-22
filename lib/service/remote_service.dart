import 'dart:convert';
import 'dart:io';

import 'package:app_builder/form_config/model/dto/form_config.dart';
import 'package:app_builder/form_definition/model/dto/form_item.dart';
import 'package:app_builder/list_definition/model/dto/list_definition.dart';
import 'package:app_builder/models/general_response.dart';
import 'package:app_builder/module/model/dto/module_item.dart';
import 'package:app_builder/sync_data/model/data_item.dart';
import 'package:app_builder/user/model/user.dart';
import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;

class RemoteService {
  final String baseUrl = 'http://bahisdev.mpower-social.com';
  var client = http.Client();

  Future<User?> handleLogin(
      String username, String password, String upazila) async {
    try {
      var url = Uri.parse('$baseUrl/bhmodule/app-user-verify/');
      final response = await client.post(
        url,
        body: jsonEncode({
          'username': '$username',
          'password': '$password',
          'upazila': '$upazila'
        }),
      );

      if (response.statusCode == 200) {
        return userFromJson(utf8.decode(response.bodyBytes));
      }

      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

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

  Future<File?> downloadCatchmentFile(Directory directory) async {
    var catchmentFile;

    try {
      var url = Uri.parse('$baseUrl/bhmodule/catchment-data-sync/');
      final response = await client.get(
        url,
      );

      if (response.statusCode == 200) {
        var archive = ZipDecoder().decodeBytes(response.bodyBytes);

        for (ArchiveFile file in archive) {
          var filename = file.name;
          if (file.isFile) {
            var data = file.content;
            catchmentFile = File(directory.path + "/packages/" + filename);
            if (catchmentFile.existsSync()) catchmentFile.deleteSync();

            catchmentFile.createSync(recursive: true);
            catchmentFile.writeAsBytesSync(data);
          } else {
            Directory(directory.path + "/packages/" + filename)
              ..create(recursive: true);
          }
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }

    return catchmentFile;
  }

  Future<int?> submitFormToServer(String xml) async {
    try {
      var url = Uri.parse('$baseUrl/bhmodule/bahis_ulo/submission/');
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'xml_submission_file': xml,
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var generalResponse =
            generalResponseFromJson(utf8.decode(response.bodyBytes));
        if (generalResponse.status == 200 || generalResponse.status == 201) {
          return generalResponse.id;
        }
      }
    } catch (e) {
      print(e.toString());
    }

    return null;
  }
}
