import 'package:get/get.dart';
import 'package:m_survey/models/local/submitted_form_list_data.dart';
import 'package:m_survey/repository/project_repository.dart';
import '../utils/odk_util.dart';
import 'package:m_survey/models/form_data.dart' as formData;

class FormDetailsController extends GetxController {
  var submittedFormList = <SubmittedFormListData?>[].obs;
  ProjectRepository _projectRepository = ProjectRepository();
  var draftFormCount = 0.obs;
  var completeFormCount = 0.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  void openOdkForm(int? id) async {
    final results = await OdkUtil.instance.openForm('member_register_test901',
        arguments: {'projectId': id?.toString()});
    if (results != null && results.isNotEmpty) {
      print("success  $results");
    }
    print('failed');
  }

  getTotalSubmittedForm(String? idString) async {
    submittedFormList.value =
        await _projectRepository.getAllSubmittedFromLocalByForm(idString);
  }
  getDraftFormCount(String? idString)async{
    final results = await OdkUtil.instance.getDraftForms([idString!]);
    if (results != null && results.isNotEmpty) {
      draftFormCount.value = formData.formDataFromJson(results).length;
      return;
    }
  }
  getCompleteFormCount(String? idString)async{
    final results = await OdkUtil.instance.getFinalizedForms([idString!]);
    if (results != null && results.isNotEmpty) {
      completeFormCount.value = formData.formDataFromJson(results).length;
      return;
    }
  }

}
