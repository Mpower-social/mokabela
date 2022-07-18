import 'dart:ffi';

import 'package:get/get.dart';
import 'package:m_survey/models/form_data.dart' as formData;
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/repository/dashboard_repository.dart';
import 'package:m_survey/utils/odk_util.dart';

class DraftFormController extends GetxController{
  var formList = <formData.FormData>[].obs;
  var formListTemp = <formData.FormData>[].obs;
  var selectedProject = ProjectListFromLocalDb(id: 0,projectName: 'Select project').obs;  var isCheckedAll = false.obs;
  var isLoadingDraftForm = false.obs;

  var projectList = <ProjectListFromLocalDb>[].obs;

  final DashboardRepository _dashboardRepository = DashboardRepository();

  @override
  void onInit()async{
    super.onInit();
    await loadProjects();
    await getDraftFormList();
  }

  ///getting project list for dropdown
  loadProjects() async{
    projectList.clear();
    projectList.add(ProjectListFromLocalDb(id: 0,projectName: 'Select project'));
    projectList.addAll(await _dashboardRepository.getAllProjectFromLocal());
  }

  ///getting all draft form here
  getDraftFormList() async{
    isLoadingDraftForm.value = true;
    final results = await OdkUtil.instance.getDraftForms(['member_register_test901']);
    if (results != null && results.isNotEmpty) {
     formList.value = formData.formDataFromJson(results);
     formListTemp.value = formList.value;
     isLoadingDraftForm.value = false;
     return;
    }
    formList.value = [];
    isLoadingDraftForm.value = false;
  }

  ///delete specific form
  void deleteForm(int id) async{
    final results = await OdkUtil.instance.deleteDraftForm(id);
    if (results != null && results.isNotEmpty) {
      Get.back();
      await getDraftFormList();
      return;
    }
  }
  
  ///filter draft project list
  void filter(int projectId){
    if(projectId == 0) formList.value = formListTemp.value;
    else formList.value = formListTemp.where((v) => v.projectId == projectId).toList();
  }

  void editDraftForm(int id) async{
    final results = await OdkUtil.instance.editForm(id);
    if (results != null && results.isNotEmpty) {
      return;
    }
  }
}