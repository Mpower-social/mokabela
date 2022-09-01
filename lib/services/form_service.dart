import 'dart:io';
import 'package:m_survey/network/apis.dart';
import 'package:m_survey/network/base_api_provider.dart';
import 'package:m_survey/network/dio_exception.dart';
import 'package:m_survey/utils/odk_util.dart';
import 'package:m_survey/utils/shared_pref.dart';
import 'package:m_survey/widgets/show_toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:m_survey/models/form_data.dart' as formData;
import 'package:path/path.dart';

class FormService extends BaseApiProvider{
  ///get submitted form list
  /*Future<ProjectListResponse?> getProjectListOperation(currentPage,pageSize) async {
    try{
      var token = await SharedPref.sharedPref.getString(SharedPref.TOKEN);
      var orgId = await SharedPref.sharedPref.getString(SharedPref.ORG_ID);
      dio.options.headers.addAll({'Authorization':'Bearer $token'});
      var response = await dio.get(Apis.getProjectList(orgId, currentPage, pageSize));
      return ProjectListResponse.fromJson(response.data);
    }catch(error){
      showToast(msg:DioException.getDioException(error),isError: true);
    }
    return null;
  }*/


  ///submit form data
  Future<String?> submitFormOperation(formData) async {
    try{
    Directory? tempDir = await getExternalStorageDirectory();

    var finalDir = "${tempDir!.path.replaceAll("'", '')}/instances/${formData.instanceFilePath.toString()}";
    var mediaDir = "${tempDir.path.replaceAll("'", '')}/instances/";
    var token = await SharedPref.sharedPref.getString(SharedPref.TOKEN);
      var xmlFile = await MultipartFile.fromFile(finalDir, filename: "file");
      List<MultipartFile> multipartList = [];

      Map<String,dynamic> data = Map<String,dynamic>();
      data['xml_submission_file'] = xmlFile;
      data['id_string'] = formData.formId.toString();


      List<FileSystemEntity> dir = await Directory(mediaDir).list().toList();
      for (var element in dir){
      if(extension(element.path)){
        var filename = element.path.split("/").last;
        data[filename] = await MultipartFile.fromFile(finalDir, filename: filename);
      }
      }

      dio.options.headers.addAll({'Authorization':'Bearer $token'});
      var response = await dio.post(Apis.submitForm,
        data: FormData.fromMap(data)
      );

      print(response.data);
      if(response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202){
        await OdkUtil.instance.sendToSubmitted(formData.id);

      }
      return 'success';
    }catch(error){
      print(error);
      showToast(msg:DioException.getDioException(error),isError: true);
      return null;
    }
  }
}