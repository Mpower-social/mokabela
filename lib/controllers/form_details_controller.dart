import 'package:get/get.dart';
import 'package:m_survey/models/local/submitted_form_list_data.dart';
import 'package:m_survey/repository/project_repository.dart';
import '../utils/odk_util.dart';

class FormDetailsController extends GetxController {
  var submittedFormList = <SubmittedFormListData?>[].obs;
  ProjectRepository _projectRepository = ProjectRepository();
  @override
  void onInit()async{
    super.onInit();
  }

  void openOdkForm() async {
    final results = await OdkUtil.instance.openForm('member_register_test901',
        arguments: {'projectId': "123456"});
    if (results != null && results.isNotEmpty) {
      print("success  $results");
    }
    print('failed');
  }

  getTotalSubmittedForm(String? idString) async{
    submittedFormList.value = await _projectRepository.getAllSubmittedFromLocalByForm(idString);
  }
}
