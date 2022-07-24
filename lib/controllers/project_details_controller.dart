import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:m_survey/models/local/all_form_list_data.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/models/local/submitted_form_list_data.dart';
import 'package:m_survey/repository/project_repository.dart';
import 'package:m_survey/utils/odk_util.dart';
import 'package:m_survey/models/form_data.dart' as formData;

class ProjectDetailsController extends GetxController{
  TextEditingController searchEditingController = TextEditingController();
  var projectList = <ProjectListFromLocalDb>[].obs;
  var submittedFormList = <SubmittedFormListData?>[].obs;
  var allFormList = <AllFormsData?>[].obs;
  var allFormListTemp = <AllFormsData?>[].obs;

  var isLoadingProject = false.obs;
  var totalActiveForms = 0.obs;
  var totalSubmittedForms = 0.obs;

  ProjectRepository _projectRepository = ProjectRepository();


  var draftFormCount = 0.obs;
  var completeFormCount = 0.obs;

  @override
  void onInit()async{
    super.onInit();
    await getDraftFormCount();
    await getCompleteFormCount();
  }

  ///search operation
  void searchOperation() async{
    if(searchEditingController.text.isEmpty) allFormList.value = allFormListTemp;
    else allFormList.value = allFormListTemp.where((v) => (v?.title??'').toLowerCase().contains(searchEditingController.text.toLowerCase())).toList();
  }

  ///getting project list here
  void getAllDataByProject(projectId) async{
    isLoadingProject.value = true;
    submittedFormList.value = await _projectRepository.getAllSubmittedFromLocalByProject(projectId);
    allFormList.value = await _projectRepository.getAllFromLocalByProject(projectId);
    allFormListTemp.value = allFormList.value;
    isLoadingProject.value = false;
  }


  getDraftFormCount() async{
    final results = await OdkUtil.instance.getDraftForms(['member_register_test901']);
    if (results != null && results.isNotEmpty) {
      draftFormCount.value = formData.formDataFromJson(results).length;
      return;
    }
  }

  getCompleteFormCount() async{
    final results = await OdkUtil.instance.getFinalizedForms(['member_register_test901']);
    if (results != null && results.isNotEmpty) {
      completeFormCount.value = formData.formDataFromJson(results).length;
      return;
    }
  }
}