import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:m_survey/models/local/all_form_list_data.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/repository/dashboard_repository.dart';
import 'package:m_survey/repository/project_repository.dart';
import 'package:m_survey/utils/odk_util.dart';
import 'package:m_survey/models/form_data.dart' as formData;
import '../views/active_form_screen.dart';
import '../views/draft_form_screen.dart';
import '../views/form_details_screen.dart';
import '../views/ready_to_sync_form_screen.dart';
import '../views/submitted_form_screen.dart';

class ProjectDetailsController extends GetxController {
  TextEditingController searchEditingController = TextEditingController();
  ProjectRepository _projectRepository = ProjectRepository();
  DashboardRepository _dashboardRepository = DashboardRepository();
  var projectList = <ProjectListFromLocalDb>[].obs;
  var allFormList = <AllFormsData?>[].obs;
  var allFormListTemp = <AllFormsData?>[].obs;
  var isLoadingProject = false.obs;
  var clearSearchText = false.obs;
  int currentProjectId = 0;
  Timer? debounce;

  var draftFormCount = 0.obs;
  var activeFormCount = 0.obs;
  var completeFormCount = 0.obs;
  var submittedFormCount = 0.obs;

  ///search operation
  void clearSearchView() async {
    if (clearSearchText.value) {
      searchEditingController.clear();
      clearSearchText.value = false;
      allFormList.value = allFormListTemp;
    }
  }

  onSearchChanged(String query) async {
    if (debounce?.isActive ?? false) debounce?.cancel();

    debounce = Timer(const Duration(milliseconds: 300), () {
      if (searchEditingController.text.isEmpty) {
        clearSearchText.value = false;
        allFormList.value = allFormListTemp;
      } else {
        clearSearchText.value = true;
        allFormList.value = allFormListTemp
            .where((v) => (v?.title ?? '')
                .toLowerCase()
                .contains(searchEditingController.text.toLowerCase()))
            .toList();
      }
    });
  }

  ///getting project list here
  getAllData() async {
    isLoadingProject.value = true;
    await refreshDashBoardCount();
    isLoadingProject.value = false;
  }

  getAllDataByProject() async {

    allFormList.value = await _projectRepository.getAllFromLocalByProject(currentProjectId);
    allFormListTemp.value = List.from(allFormList);
  }

  getSubmittedFormCount() async {
   /* if(await CheckNetwork.checkNetwork.check()){
      //await _dashboardRepository.getSubmittedFormList(true);
    }else */
    await _dashboardRepository.getSubmittedFormList(false);
    submittedFormCount.value = (await _projectRepository.getAllSubmittedFromLocalByProject(currentProjectId)).length;
  }

  getActiveFormCount() async {
    activeFormCount.value = allFormList.where((form) => form?.isActive == true).length;
  }

  getDraftFormCount() async {
    if (allFormList.isNotEmpty) {
      var formIds = allFormList.map((form) => form!.idString!).toList();

      final results = await OdkUtil.instance.getDraftForms(formIds);
      if (results != null && results.isNotEmpty) {
        draftFormCount.value = formData.formDataFromJson(results).length;
        return;
      }
    }
  }

  getCompleteFormCount() async {
    if (allFormList.isNotEmpty) {
      var formIds = allFormList.map((form) => form!.idString!).toList();

      final results = await OdkUtil.instance.getFinalizedForms(formIds);
      if (results != null && results.isNotEmpty) {
        completeFormCount.value = formData.formDataFromJson(results).length;
        return;
      }
    }
  }

  navigateToDraftFormsScreen(ProjectListFromLocalDb projectListFromData) async {
    var formIds = allFormList.map((form) => form!.idString!).toList();

    await Get.to(
      () => DraftFormScreen(
        formIds,
        project: projectListFromData,
      ),
    );

    refreshDashBoardCount();
  }

  navigateToActiveFormsScreen(
      ProjectListFromLocalDb projectListFromData) async {
    await Get.to(
      () => ActiveFormScreen(
        project: projectListFromData,
      ),
    );

    refreshDashBoardCount();
  }

  navigateToSyncFormsScreen(ProjectListFromLocalDb projectListFromData) async {
    var formIds = allFormList.map((form) => form!.idString!).toList();
    await Get.to(
      () => ReadyToSyncFormScreen(
        project: projectListFromData,
        formIds:formIds
      ),
    );

    refreshDashBoardCount();
  }

  navigateToSubmittedFormsScreen(
      ProjectListFromLocalDb projectListFromData) async {
    await Get.to(
      () => SubmittedFormScreen(
        project: projectListFromData,
      ),
    );

    refreshDashBoardCount();
  }

  navigateToFormDetailsScreen(
    ProjectListFromLocalDb projectListFromData,
    AllFormsData data,
  ) async {
    await Get.to(
      () => FormDetailsScreen(
        projectListFromData: projectListFromData,
        allFormsData: data,
      ),
    );

    refreshDashBoardCount();
  }

  Future<void> refreshDashBoardCount() async {
    await getAllDataByProject();
    await getDraftFormCount();
    await getActiveFormCount();
    await getCompleteFormCount();
    await getSubmittedFormCount();
  }

  @override
  void onClose() {
    super.onClose();
    debounce?.cancel();
  }
}
