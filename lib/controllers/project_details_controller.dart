import 'package:get/get.dart';
import 'package:m_survey/models/local/all_form_list_data.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/models/local/submitted_form_list_data.dart';
import 'package:m_survey/repository/project_repository.dart';
import 'package:m_survey/utils/odk_util.dart';
class ProjectDetailsController extends GetxController{
  var projectList = <ProjectListFromLocalDb>[].obs;
  var submittedFormList = <SubmittedFormListData?>[].obs;
  var allFormList = <AllFormsData?>[].obs;
  var isLoadingProject = false.obs;
  var totalActiveForms = 0.obs;
  var totalSubmittedForms = 0.obs;

  ProjectRepository _projectRepository = ProjectRepository();


  @override
  void onInit()async{
    super.onInit();
  }

  ///search operation
  void searchOperation() {}



  ///getting project list here
  void getAllDataByProject(projectId) async{
    isLoadingProject.value = true;
    submittedFormList.value = await _projectRepository.getAllSubmittedFromLocalByProject(projectId);
    allFormList.value = await _projectRepository.getAllFromLocalByProject(projectId);
    isLoadingProject.value = false;
  }


  getDraftFormCount() async{
    final results = await OdkUtil.instance.getDraftForms(['member_register_test901']);
    if (results != null && results.isNotEmpty) {
      //draftFormCount.value = formData.formDataFromJson(results).length;
      return;
    }
  }

  getCompleteFormCount() async{
    final results = await OdkUtil.instance.getFinalizedForms(['member_register_test901']);
    if (results != null && results.isNotEmpty) {
     // completeFormCount.value = formData.formDataFromJson(results).length;
      return;
    }
  }
}