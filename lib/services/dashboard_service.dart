import 'dart:convert';
import 'package:m_survey/models/response/all_form_list_response.dart';
import 'package:m_survey/models/response/project_list_response.dart';
import 'package:m_survey/models/response/submitted_form_list_response.dart';
import 'package:m_survey/network/apis.dart';
import 'package:m_survey/network/base_api_provider.dart';
import 'package:m_survey/network/dio_exception.dart';
import 'package:m_survey/utils/shared_pref.dart';
import 'package:dio/dio.dart';
import 'package:m_survey/widgets/show_toast.dart';

class DashboardService extends BaseApiProvider {
  ///getting project list here operation
  Future<ProjectListResponse?> getProjectListOperation(currentPage,pageSize) async {
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
  }

  Future<String?> getFormList() async{
    try{
      var token = await SharedPref.sharedPref.getString(SharedPref.TOKEN);
      var response = await dio.get(Apis.getFormList,options: Options(
        headers:  {'Authorization':'Bearer $token',},
        responseType: ResponseType.plain
      ));
      return response.data.toString();
    }catch(error){
      showToast(msg:DioException.getDioException(error),isError: true);
    }
    return null;
  }

  Future<List<SubmittedFormListResponse?>?> getSubmittedFormList() async {
    var list = <SubmittedFormListResponse>[];
    try {
      var token = await SharedPref.sharedPref.getString(SharedPref.TOKEN);
      var response = await dio.post(Apis.getSubmittedFormList,
          data:jsonEncode({ "from_date": "2021-01-19"}),
          options: Options(
              headers: {'Authorization': 'Bearer $token',},
              responseType: ResponseType.plain
          ));
      return List<SubmittedFormListResponse>.from(json.decode(response.data).map((x) => SubmittedFormListResponse.fromJson(x)));
    } catch (error) {
      showToast(msg: DioException.getDioException(error), isError: true);
    }
    return null;
  }

  Future<AllFormListResponse?> getAllFormList() async {
    try {
      var token = await SharedPref.sharedPref.getString(SharedPref.TOKEN);
      var response = await dio.get(Apis.getAllFormList,
          options: Options(
              headers: {'Authorization': 'Bearer $token',},
              responseType: ResponseType.plain
          ));
      return AllFormListResponse.fromJson(jsonDecode(response.data));
    } catch (error) {
      showToast(msg: DioException.getDioException(error), isError: true);
    }
    return null;
  }
}