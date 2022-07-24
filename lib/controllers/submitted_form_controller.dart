import 'package:get/get.dart';
import 'package:m_survey/models/draft_checkbox_data.dart';
import 'package:m_survey/models/local/all_form_list_data.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/models/local/submitted_form_list_data.dart';
import 'package:m_survey/models/submitted_checkbox_data.dart';
import 'package:m_survey/repository/dashboard_repository.dart';
import 'package:m_survey/repository/form_repository.dart';
import 'package:m_survey/widgets/show_toast.dart';

class SubmittedFormController extends GetxController{
  var selectedProject = ProjectListFromLocalDb(id: 0,projectName: 'Select project').obs;
  var projectList = <ProjectListFromLocalDb>[].obs;
  var submittedFormList = <SubmittedFormListData?>[].obs;
  var submittedFormListTemp = <SubmittedFormListData?>[].obs;
  var isLoadingForms = false.obs;

  var isCheckedAll = false.obs;
  var isCheckList = <SubmittedCheckboxData>[].obs;
  var isCheckListTemp = <SubmittedCheckboxData>[].obs;

  final DashboardRepository _dashboardRepository = DashboardRepository();
  final FormRepository _formRepository = FormRepository();

  ///true=asc, false=desc
  var ascOrDesc = false.obs;

  @override
  void onInit()async{
    super.onInit();
    await getData();
    setupDefaultCheckBox();
  }

  loadProjects() async{
    projectList.clear();
    projectList.add(ProjectListFromLocalDb(id: 0,projectName: 'Select project'));
    projectList.addAll(await _dashboardRepository.getAllProjectFromLocal());
  }

  ///getting active form data and project list here
  getData() async{
    isLoadingForms.value = true;
    await loadProjects();
    submittedFormList.value = await _dashboardRepository.getAllSubmittedFromLocalByDelete();
    isLoadingForms.value = false;
  }

  ///filter submitted project list
  void filter(int projectId){
    if(projectId == 0) submittedFormList.value = submittedFormListTemp;
    else submittedFormList.value = submittedFormListTemp.where((v) => (v?.projectId??0) == projectId).toList();
  }

  ///sort list asc or desc
  void sortByDate() async{
    if(isCheckList.length>0){
      if(ascOrDesc.value){
        isCheckList.sort((a,b)=>a.submittedFormListData!.dateCreated!.compareTo(b.submittedFormListData!.dateCreated!));
        showToast(msg: 'Sorted by ascending order.');
      }else{
        isCheckList.sort((a,b)=>-a.submittedFormListData!.dateCreated!.compareTo(b.submittedFormListData!.dateCreated!));
        showToast(msg: 'Sorted by descending order');
      }
    }
  }


  ///delete data
  void deleteForm()async{
    try{
      for(var element in isCheckList){
        print(element.isChecked);
        if(element.isChecked && element.submittedFormListData != null){
         _formRepository.deleteSubmittedForm(element.submittedFormListData!);
        }
      }
    }catch(_){

    }finally{
      setupDefaultCheckBox();
      await getData();
    }
  }

  //initial defaults checkbox
  void setupDefaultCheckBox() {
    isCheckList.clear();
    submittedFormList.forEach((element) {
      isCheckList.add(SubmittedCheckboxData(false, element));
    });
    isCheckListTemp = isCheckList;
  }

  ///handling checkbox
  void addCheckBoxData(var pos, {from = 'each',SubmittedFormListData? formData}) {

    if(from == 'each'){
      var trueCount = 0;
      isCheckList[pos] = SubmittedCheckboxData(!isCheckList[pos].isChecked,formData);

      isCheckList.forEach((element) {
        if(element.isChecked) trueCount++;
      });
      print(trueCount);

      if(trueCount == submittedFormList.length) isCheckedAll.value = true;
      else  isCheckedAll.value = false;

    }else{
      for(int i=0;i<submittedFormList.length;i++){
        if(isCheckedAll.value){
          isCheckList[i] = SubmittedCheckboxData(true,submittedFormList[i]);
        }else{
          isCheckList[i] = SubmittedCheckboxData(false,submittedFormList[i]);
        }
      }
    }
  }
}