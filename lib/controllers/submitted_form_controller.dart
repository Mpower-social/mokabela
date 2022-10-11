import 'package:get/get.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/models/local/submitted_form_list_data.dart';
import 'package:m_survey/models/submitted_checkbox_data.dart';
import 'package:m_survey/repository/dashboard_repository.dart';
import 'package:m_survey/repository/form_repository.dart';
import 'package:m_survey/widgets/show_toast.dart';

class SubmittedFormController extends GetxController {
  var selectedProject;
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
  ProjectListFromLocalDb? currentProject;

  loadProjects() async {
    projectList.clear();
    selectedProject =
        ProjectListFromLocalDb(id: 0, projectName: 'Select project');

    projectList.add(selectedProject);
    projectList.addAll(await _dashboardRepository.getAllProjectFromLocal());
  }

  ///getting active form data and project list here
  getAllData() async {
    isLoadingForms.value = true;
    await loadProjects();
    submittedFormList.value =
        await _dashboardRepository.getAllSubmittedFromLocalByDelete();
    submittedFormListTemp.value = List.from(submittedFormList);

    isLoadingForms.value = false;
  }

  getProjectData() async {
    isLoadingForms.value = true;
    projectList.clear();
    selectedProject = currentProject;
    projectList.add(selectedProject);

    submittedFormList.value = await _dashboardRepository
        .getAllUndeletedSubmittedFromLocalByProject(currentProject!.id!);
    submittedFormListTemp.value = List.from(submittedFormList);

    isLoadingForms.value = false;
  }

  getData() async {
    if (currentProject == null)
      await getAllData();
    else
      await getProjectData();

    setupDefaultCheckBox();
  }

  ///filter submitted project list
  void filter(int projectId) {
    print(projectId);
    if (projectId == selectedProject.id) return;

    selectedProject =
        projectList.firstWhere((element) => element.id == projectId);

    if (projectId == 0)
      submittedFormList.value = submittedFormListTemp;
    else
      submittedFormList.value = submittedFormListTemp
          .where((v){
            return (v?.projectId ?? 0) == projectId;
      })
          .toList();

    setupDefaultCheckBox();
  }

  ///sort list asc or desc
  void sortByDate() async {
    if (isCheckList.length > 0) {
      if (ascOrDesc.value) {
        isCheckList.sort((a, b) => a.submittedFormListData!.dateCreated!
            .compareTo(b.submittedFormListData!.dateCreated!));
        showToast(msg: 'Sorted by ascending order.');
      } else {
        isCheckList.sort((a, b) => -a.submittedFormListData!.dateCreated!
            .compareTo(b.submittedFormListData!.dateCreated!));
        showToast(msg: 'Sorted by descending order');
      }
    }
  }

  ///delete data
  void deleteForm() async {
    var anySelected = isCheckList.any((element) => element.isChecked == true);
    if (!anySelected) {
      showToast(msg: 'You didn\'t select any form to delete');
      return;
    }

    try {
      for (var element in isCheckList) {
        print(element.isChecked);
        if (element.isChecked && element.submittedFormListData != null) {
          _formRepository.deleteSubmittedForm(element.submittedFormListData!);
        }
      }
    } catch (_) {
    } finally {
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
  void addCheckBoxData(var pos,
      {from = 'each', SubmittedFormListData? formData}) {
    if (from == 'each') {
      var trueCount = 0;
      isCheckList[pos] =
          SubmittedCheckboxData(!isCheckList[pos].isChecked, formData);

      isCheckList.forEach((element) {
        if (element.isChecked) trueCount++;
      });
      print(trueCount);

      if (trueCount == submittedFormList.length)
        isCheckedAll.value = true;
      else
        isCheckedAll.value = false;
    } else {
      for (int i = 0; i < submittedFormList.length; i++) {
        if (isCheckedAll.value) {
          isCheckList[i] = SubmittedCheckboxData(true, submittedFormList[i]);
        } else {
          isCheckList[i] = SubmittedCheckboxData(false, submittedFormList[i]);
        }
      }
    }
  }
}
