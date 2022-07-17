import 'package:m_survey/network/apis.dart';
import 'package:m_survey/network/base_api_provider.dart';
import 'package:m_survey/network/dio_exception.dart';
import 'package:m_survey/utils/shared_pref.dart';
import 'package:m_survey/widgets/show_toast.dart';
import 'package:dio/dio.dart';

class FormService extends BaseApiProvider{
  ///submit form data
  Future<String?> submitFormOperation(projectId) async {
    try{
      var token = await SharedPref.sharedPref.getString(SharedPref.TOKEN);
      var xmlFile = await MultipartFile.fromFile('./text1.txt', filename: 'text1.txt');

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
    }
    return null;
  }
}