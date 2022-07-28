import 'package:get/get.dart';
import 'package:m_survey/models/local/all_form_list_data.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/models/local/submitted_form_list_data.dart';
import 'package:m_survey/repository/dashboard_repository.dart';
import 'package:m_survey/repository/form_repository.dart';
import 'package:m_survey/utils/odk_util.dart';
import 'package:m_survey/utils/shared_pref.dart';
import 'package:m_survey/widgets/show_toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:m_survey/models/form_data.dart' as formData;

import '../views/active_form_screen.dart';
import '../views/draft_form_screen.dart';
import '../views/form_details_screen.dart';
import '../views/project_details_screen.dart';
import '../views/ready_to_sync_form_screen.dart';
import '../views/submitted_form_screen.dart';

class DashboardController extends GetxController {
  var name = ''.obs;
  var designation = ''.obs;
  var recentFormList = <formData.FormData>[].obs;
  var projectList = <ProjectListFromLocalDb>[].obs;
  var submittedFormList = <SubmittedFormListData?>[].obs;
  var allFormList = <AllFormsData?>[].obs;
  var isLoadingProject = false.obs;
  var formList = <formData.FormData>[].obs;
  var formListString = <String>[].obs;

  var draftFormCount = 0.obs;
  var activeFormCount = 0.obs;
  var completeFormCount = 0.obs;
  var submittedFormCount = 0.obs;

  final DashboardRepository _dashboardRepository = DashboardRepository();
  final FormRepository _formRepository = FormRepository();

  @override
  void onInit() async {
    super.onInit();
    handlePermission();
    getUserdata();
    await getAllData(false);
    downloadForm();
    await getRecentFormList();
  }

  void getUserdata() async {
    name.value = await SharedPref.sharedPref.getString(SharedPref.NAME) ?? '';
    designation.value =
        await SharedPref.sharedPref.getString(SharedPref.DESIGNATION) ?? '';
  }

  ///getting project list here
  Future<void> getAllData(bool forceLoad) async {
    isLoadingProject.value = true;
    submittedFormList.value = await _dashboardRepository.getSubmittedFormList(forceLoad);
    allFormList.value = await _dashboardRepository.getAllFormList(forceLoad);
    projectList.value = await _dashboardRepository.getProjectListOperation(forceLoad);
    await _dashboardRepository.getRevertedFormList(forceLoad);
    await getFormData();
    refreshDashBoardCount();

    isLoadingProject.value = false;
  }

  ///getting all forms data here
  getFormData() async {
    formListString.clear();
    allFormList.forEach((element) {
      formListString.add(element?.idString??'');
    });
    var formIds = formListString;
    var results = await OdkUtil.instance.getFinalizedForms(formIds);
    if (results != null && results.isNotEmpty) {
      formList.value = formData.formDataFromJson(results);
    }
  }

  ///sync all data
  void syncAllForm() async {
    try {
      for (var element in formList) {
        if (element != null) {
          final results = await _formRepository.submitFormOperation(element);
          if (results.isNotEmpty) {
            //succ
          }
        }
      }
    } catch (_) {
      showToast(msg: 'Failed to sync.Try again.', isError: true);
    } finally {
      showToast(msg: 'Sync complete');
    }
  }

  getSubmittedFormCount() async {
    submittedFormCount.value =
        (await _dashboardRepository.getSubmittedFormList(false)).length;
  }

  getActiveFormCount() async {
    activeFormCount.value =
        allFormList.where((form) => form?.status == 'true').length;
  }

  getDraftFormCount() async {
    final results = await OdkUtil.instance.getDraftForms([]);
    if (results != null && results.isNotEmpty) {
      draftFormCount.value = formData.formDataFromJson(results).length;
      return;
    }
  }

  getCompleteFormCount() async {
    final results = await OdkUtil.instance.getFinalizedForms([]);
    if (results != null && results.isNotEmpty) {
      completeFormCount.value = formData.formDataFromJson(results).length;
      return;
    }
  }

  getRecentFormList() async {
    recentFormList.clear();
    final results = await OdkUtil.instance.getRecentForms();
    if (results != null && results.isNotEmpty) {
      formData.formDataFromJson(results).forEach((element) {
        var projectId = int.tryParse(element.projectId!);
        var currentProject =
            projectList.firstWhereOrNull((v) => v.id == projectId);
        var currentForm = allFormList
            .firstWhereOrNull((form) => form?.projectId == projectId);

        element.projectName = currentProject?.projectName ?? 'N/A';
        element.status = currentForm?.status ?? 'false';

        recentFormList.add(element);
      });
      return;
    }

    recentFormList.value = [];
  }

  void downloadForm() async {
    _dashboardRepository.getFormList().then((value) async {
      final results = await OdkUtil.instance.initializeOdk(value);
      if (results != null && results.isNotEmpty) {
        print('Success');
      }
      print('failed');
    });
  }

  void handlePermission() async {
    await [
      Permission.storage,
    ].request();
    if (await Permission.storage.request().isGranted) {
      print('granted');
    }
  }

  navigateToDraftFormsScreen() async {
    await Get.to(
      () => DraftFormScreen(),
    );

    refreshDashBoardCount();
  }

  navigateToActiveFormsScreen(bool showActiveOnly) async {
    await Get.to(
      () => ActiveFormScreen(
        showActiveFormsOnly: showActiveOnly,
      ),
    );

    refreshDashBoardCount();
  }

  navigateToSyncFormsScreen() async {
    await Get.to(
      () => ReadyToSyncFormScreen(),
    );

    refreshDashBoardCount();
  }

  navigateToSubmittedFormsScreen() async {
    await Get.to(
      () => SubmittedFormScreen(),
    );

    refreshDashBoardCount();
  }

  navigateToProjectDetailsScreen(
    ProjectListFromLocalDb projectListFromData,
  ) async {
    await Get.to(
      () => ProjectDetailsScreen(
        projectListFromData,
      ),
    );

    refreshDashBoardCount();
  }

  navigateToFormDetailsScreen(
    AllFormsData? allFormsData,
    ProjectListFromLocalDb projectListFromData,
  ) async {
    await Get.to(
      () => FormDetailsScreen(
        allFormsData: allFormsData,
        projectListFromData: projectListFromData,
      ),
    );

    refreshDashBoardCount();
  }

  void refreshDashBoardCount() async {
    await getDraftFormCount();
    await getActiveFormCount();
    await getCompleteFormCount();
    await getSubmittedFormCount();
  }

  void goToSettings() {
    OdkUtil.instance.goToSettings();
  }
}
