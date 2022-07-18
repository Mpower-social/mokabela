import 'dart:math';

import 'package:get/get.dart';
import 'package:m_survey/models/draft_checkbox_data.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/repository/dashboard_repository.dart';
import 'package:m_survey/models/form_data.dart' as formData;
import 'package:m_survey/repository/form_repository.dart';
import 'package:m_survey/utils/odk_util.dart';
import 'package:m_survey/widgets/progress_dialog.dart';

class ReadyToSyncFormFormController extends GetxController{
  var formList = <formData.FormData>[].obs;
  var formListTemp = <formData.FormData>[].obs;
  var selectedFormList = <formData.FormData>[].obs;

  var selectedProject = ProjectListFromLocalDb(id: 0,projectName: 'Select project').obs;
  var isLoadingForm = false.obs;
  var isCheckedAll = false.obs;
  var isCheckList = <DraftCheckboxData>[].obs;

  var projectList = <ProjectListFromLocalDb>[].obs;

  final DashboardRepository _dashboardRepository = DashboardRepository();
  final FormRepository _formRepository = FormRepository();

  @override
  void onInit()async{
    super.onInit();
    await loadProjects();
    await getCompleteFormList();
    setupDefaultCheckBox();
  }

  loadProjects() async{
    projectList.clear();
    projectList.add(ProjectListFromLocalDb(id: 0,projectName: 'Select project'));
    projectList.addAll(await _dashboardRepository.getAllProjectFromLocal());
  }


  ///getting all complete form here
  getCompleteFormList() async{
    isLoadingForm.value = true;
    final results = await OdkUtil.instance.getFinalizedForms(['member_register_test901']);
    if (results != null && results.isNotEmpty) {
      formList.value = formData.formDataFromJson(results);
      formListTemp.value = formList.value;
      isLoadingForm.value = false;
      return;
    }
    formList.value = [];
    isLoadingForm.value = false;
  }

  ///delete specific form
  void deleteForm(int id) async{
    final results = await OdkUtil.instance.deleteDraftForm(id);
    if (results != null && results.isNotEmpty) {
      Get.back();
      await getCompleteFormList();
      return;
    }
  }

  ///filter draft project list
  void filter(int projectId){
    if(projectId == 0) formList.value = formListTemp.value;
    else formList.value = formListTemp.where((v) => v.projectId == projectId).toList();
  }

  ///sending complete list to draft
  void sendBackToDraft() async{
   for(var element in isCheckList){
     if(element.isChecked && element.formData != null){
       final results = await OdkUtil.instance.sendBackToDraft(element.formData?.id??0);
       if (results != null && results.isNotEmpty) {
         //succ
       }
     }
   }
   await getCompleteFormList();
  }
  
  ///sync data
  void syncCompleteForm()async{
    progressDialog();
    try{
      for(var element in isCheckList){
        if(element.isChecked && element.formData != null){
          final results = await _formRepository.submitFormOperation(1,element.formData?.instanceFilePath);
          if (results != null && results.isNotEmpty) {
            //succ
          }
        }
      }
    }catch(_){

    }finally{
      Get.back();
    }
  }

  //initial defaults checkbox
  void setupDefaultCheckBox() {
    formList.forEach((element) {
      isCheckList.add(DraftCheckboxData(false, null));
    });
  }

  ///handling checkbox
  void addCheckBoxData(var pos, {from = 'each',formData.FormData? formData}) {

   if(from == 'each'){
     var trueCount = 0;
     isCheckList[pos] = DraftCheckboxData(!isCheckList[pos].isChecked,formData);

     isCheckList.forEach((element) {
       if(element.isChecked) trueCount++;
     });

     if(trueCount == formList.length) isCheckedAll.value = true;
     else  isCheckedAll.value = false;

   }else{
    for(int i=0;i<formList.length;i++){
     if(isCheckedAll.value){
       isCheckList[i] = DraftCheckboxData(true,formList[i]);
     }else{
       isCheckList[i] = DraftCheckboxData(false,formList[i]);
     }
    }
   }
  }
}