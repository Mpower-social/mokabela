import 'package:get/get.dart';
import 'package:m_survey/enum/form_status.dart';
import 'package:m_survey/models/local/all_form_list_data.dart';
import 'package:m_survey/models/local/submitted_form_list_data.dart';
import 'package:m_survey/repository/dashboard_repository.dart';
import 'package:m_survey/repository/project_repository.dart';
import 'package:m_survey/views/form_list_screen.dart';
import '../utils/odk_util.dart';
import 'package:m_survey/models/form_data.dart' as formData;

class FormDetailsController extends GetxController {
  var submittedFormList = <SubmittedFormListData?>[].obs;
  ProjectRepository _projectRepository = ProjectRepository();
  DashboardRepository _dashboardRepository =  DashboardRepository();
  var draftFormCount = 0.obs;
  var completeFormCount = 0.obs;
  var revertedFormCount = 0.obs;

  var progress = 0.0.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  void openOdkForm(int? id, String? formId,AllFormsData? allFormsData) async {
    final results = await OdkUtil.instance.openForm(formId??'',
        arguments: {'projectId': id?.toString()});
    if (results != null && results.isNotEmpty) {
      await refreshCount(formId,allFormsData);
    }
    print('failed');
  }

  getTotalSubmittedForm(String? idString,AllFormsData? allFormsData) async {
    submittedFormList.value =
        await _projectRepository.getAllSubmittedFromLocalByForm(idString);
    progress.value = (((submittedFormList.length * 100) / (allFormsData?.target ?? 0)) / 100.0);
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

  getRevertedFormCount(String? idString)async{
    final results = await OdkUtil.instance.getFinalizedForms([idString!]);
    if (results != null && results.isNotEmpty) {
      var formList = await _dashboardRepository.getRevertedFromLocalByFromId(idString);
      revertedFormCount.value = formList.length;
      return;
    }
  }

  refreshCount(String? idString,AllFormsData? allFormsData){
    getTotalSubmittedForm(idString,allFormsData);
    getDraftFormCount(idString);
    getCompleteFormCount(idString);
    getRevertedFormCount(idString);
  }


  navigateToFormList(FormStatus formStatus, AllFormsData? allFormsData, String? idString,)async{
    await Get.to(() => FormListScreen(formStatus, allFormsData));
    refreshCount(idString,allFormsData);
  }

}
