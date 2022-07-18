import 'dart:io';

import 'package:m_survey/network/apis.dart';
import 'package:m_survey/network/base_api_provider.dart';
import 'package:m_survey/network/dio_exception.dart';
import 'package:m_survey/utils/shared_pref.dart';
import 'package:m_survey/widgets/show_toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class FormService extends BaseApiProvider{
  ///submit form data
  Future<String?> submitFormOperation(projectId, formPath) async {
    try{
    Directory? tempDir = await getExternalStorageDirectory();

    var finalDir = "${tempDir!.path.replaceAll("'", '')}/instances/${formPath.toString()}";
    var token = await SharedPref.sharedPref.getString(SharedPref.TOKEN);
      var xmlFile = await MultipartFile.fromFile(finalDir, filename: "file");
    //var xmlFile = await MultipartFile.fromFile('/storage/emulated/0/Android/data/com.mpower.appbuilder.app_builder/files/instances/Member Register_2022-07-18_14-23-44/Member Register_2022-07-18_14-23-44.xml', filename: "file");

      dio.options.headers.addAll({'Authorization':'Bearer $token'});

      var response = await dio.post(Apis.submitForm,
        data: FormData.fromMap(
          {
            "xls_file":xmlFile,
            "project_id":projectId
          }
        )
      );
      return response.data;
    }catch(error){
      showToast(msg:DioException.getDioException(error),isError: true);
      return null;
    }
  }
}