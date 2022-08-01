import 'package:get/get.dart';
import 'package:m_survey/controllers/dashboard_controller.dart';
import 'package:m_survey/models/draft_checkbox_data.dart';
import 'package:m_survey/models/form_submit_status.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/repository/dashboard_repository.dart';
import 'package:m_survey/models/form_data.dart' as formData;
import 'package:m_survey/repository/form_repository.dart';
import 'package:m_survey/utils/odk_util.dart';
import 'package:m_survey/widgets/form_submit_status_dialog.dart';
import 'package:m_survey/widgets/progress_dialog.dart';
import 'package:m_survey/widgets/show_toast.dart';

class ReadyToSyncFormController extends GetxController {
  var formList = <formData.FormData>[].obs;
  var formListTemp = <formData.FormData>[].obs;
  var selectedFormList = <formData.FormData>[].obs;

  var selectedProject;
  var isLoadingForm = false.obs;
  var isCheckedAll = false.obs;
  var isCheckList = <DraftCheckboxData>[].obs;

  var projectList = <ProjectListFromLocalDb>[].obs;

  final DashboardRepository _dashboardRepository = DashboardRepository();
  final FormRepository _formRepository = FormRepository();

  DashboardController _dashboardController = Get.find();
  var formSubmitStatusList = <FormSubmitStatus>[].obs;

  ///true=asc, false=desc
  var ascOrDesc = false.obs;
  ProjectListFromLocalDb? currentProject;

  loadProjects() async {
    projectList.clear();
    selectedProject =
        ProjectListFromLocalDb(id: 0, projectName: 'Select project');

    projectList.add(selectedProject);
    projectList.addAll(await _dashboardRepository.getAllProjectFromLocal());
  }

  getAllData() async {
    isLoadingForm.value = true;
    await loadProjects();
    final results = await OdkUtil.instance.getFinalizedForms([]);
    if (results != null && results.isNotEmpty) {
      formList.value = formData.formDataFromJson(results);
      formListTemp.value = List.from(formList);
    }

    isLoadingForm.value = false;
  }

  getProjectData() async {
    isLoadingForm.value = true;
    projectList.clear();
    selectedProject = currentProject;
    projectList.add(selectedProject);

    var formIds = ['member_register_test901'];
    var results = await OdkUtil.instance.getFinalizedForms(formIds);
    if (results != null && results.isNotEmpty) {
      formList.value = formData.formDataFromJson(results);
      formListTemp.value = List.from(formList);
    }

    isLoadingForm.value = false;
  }

  getData() async {
    if (currentProject == null)
      await getAllData();
    else
      await getProjectData();

    setupDefaultCheckBox();
  }

  ///delete specific form
  void deleteForm(int id) async {
    final results = await OdkUtil.instance.deleteDraftForm(id);
    if (results != null && results.isNotEmpty) {
      Get.back();
      await getData();
      await _dashboardController.getDraftFormCount();
      return;
    }
  }

  ///filter draft project list
  void filter(int projectId) {
    if (projectId == selectedProject.id) return;

    selectedProject =
        projectList.firstWhere((element) => element.id == projectId);

    if (projectId == 0)
      formList.value = formListTemp;
    else
      formList.value =
          formListTemp.where((v) => (v.projectId ?? 0) == projectId).toList();

    setupDefaultCheckBox();
  }

  ///sending complete list to draft
  void sendBackToDraft() async {
    var anySelected = isCheckList.any((element) => element.isChecked == true);
    if (!anySelected) {
      showToast(msg: 'You didn\'t select any form');
      return;
    }

    for (var element in isCheckList) {
      if (element.isChecked && element.formData != null) {
        final results =
            await OdkUtil.instance.sendBackToDraft(element.formData?.id ?? 0);
        if (results != null && results.isNotEmpty) {
          //succ
        }
      }
    }
    isCheckedAll.value = false;
    await getData();

    await _dashboardController.getDraftFormCount();
    await _dashboardController.getCompleteFormCount();
  }

  ///sync data
  void syncCompleteForm() async {
    var anySelected = isCheckList.any((element) => element.isChecked == true);
    if (!anySelected) {
      showToast(msg: 'You didn\'t select any form');
      return;
    }

    progressDialog();
    formSubmitStatusList.clear();
    try {
      for (var element in isCheckList) {
        if (element.isChecked && element.formData != null) {
          final results = await _formRepository.submitFormOperation(element.formData);
          if (results.isNotEmpty) {
            formSubmitStatusList.add(FormSubmitStatus(element.formData?.displayName??'',true));
          }else{
            formSubmitStatusList.add(FormSubmitStatus(element.formData?.displayName??'',false));
          }
        }
      }
    } catch (_) {
    } finally {
      await getData();
      Get.back();
      showFormSubmitStatusDialog(formSubmitStatusList);
    }
  }

  //initial defaults checkbox
  void setupDefaultCheckBox() {
    isCheckList.clear();
    formList.forEach((element) {
      isCheckList.add(DraftCheckboxData(false, element));
    });
  }

  ///handling checkbox
  void addCheckBoxData(var pos, {from = 'each', formData.FormData? formData}) {
    if (from == 'each') {
      var trueCount = 0;
      isCheckList[pos] =
          DraftCheckboxData(!isCheckList[pos].isChecked, formData);

      isCheckList.forEach((element) {
        if (element.isChecked) trueCount++;
      });
      print(trueCount);

      if (trueCount == formList.length)
        isCheckedAll.value = true;
      else
        isCheckedAll.value = false;
    } else {
      for (int i = 0; i < formList.length; i++) {
        if (isCheckedAll.value) {
          isCheckList[i] = DraftCheckboxData(true, formList[i]);
        } else {
          isCheckList[i] = DraftCheckboxData(false, formList[i]);
        }
      }
    }
  }

  ///sort list asc or desc
  void sortByDate() async {
    if (isCheckList.length > 0) {
      if (ascOrDesc.value) {
        isCheckList.sort((a, b) =>
            a.formData!.lastChangeDate!.compareTo(b.formData!.lastChangeDate!));
        showToast(msg: 'Sorted by ascending order.');
      } else {
        isCheckList.sort((a, b) => -a.formData!.lastChangeDate!
            .compareTo(b.formData!.lastChangeDate!));
        showToast(msg: 'Sorted by descending order');
      }
    }
  }
}