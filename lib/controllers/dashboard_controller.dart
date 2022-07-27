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

class DashboardController extends GetxController {
  var name = ''.obs;
  var designation = ''.obs;
  var recentFormList = <formData.FormData>[].obs;
  var projectList = <ProjectListFromLocalDb>[].obs;
  var submittedFormList = <SubmittedFormListData?>[].obs;
  var allFormList = <AllFormsData?>[].obs;
  var isLoadingProject = false.obs;
  var totalActiveForms = 0.obs;
  var totalSubmittedForms = 0.obs;

  var draftFormCount = 0.obs;
  var completeFormCount = 0.obs;

  final DashboardRepository _dashboardRepository = DashboardRepository();
  final FormRepository _formRepository = FormRepository();

  @override
  void onInit() async {
    super.onInit();
    await getDraftFormCount();
    await getCompleteFormCount();
    handlePermission();
    getUserdata();
    getAllData(false);
    downloadForm();
    await getRecentFormList();
  }

  void getUserdata() async {
    name.value = await SharedPref.sharedPref.getString(SharedPref.NAME) ?? '';
    designation.value =
        await SharedPref.sharedPref.getString(SharedPref.DESIGNATION) ?? '';
  }

  ///getting project list here
  void getAllData(forceLoad) async {
    isLoadingProject.value = true;
    projectList.value = await _dashboardRepository.getProjectListOperation(1, 10, forceLoad);
    submittedFormList.value = await _dashboardRepository.getSubmittedFormList();
    allFormList.value = await _dashboardRepository.getAllFormList();
    isLoadingProject.value = false;
  }

  ///sync all data
  void syncAllForm() async {

    try {
      for (var element in allFormList) {
        if (element != null) {
          final results = await _formRepository.submitFormOperation(element);
          if (results.isNotEmpty) {
            //succ
          }
        }
      }
    } catch (_) {
      showToast(msg: 'Failed to sync.Try again.',isError: true);
    } finally {
      showToast(msg: 'Sync complete');
    }
  }

  getDraftFormCount() async {
    final results =
        await OdkUtil.instance.getDraftForms(['member_register_test901']);
    if (results != null && results.isNotEmpty) {
      draftFormCount.value = formData.formDataFromJson(results).length;
      return;
    }
  }

  getCompleteFormCount() async {
    final results =
        await OdkUtil.instance.getFinalizedForms(['member_register_test901']);
    if (results != null && results.isNotEmpty) {
      completeFormCount.value = formData.formDataFromJson(results).length;
      return;
    }
  }

  getRecentFormList() async {
    recentFormList.clear();
    final results =
        await OdkUtil.instance.getRecentForms(['member_register_test901']);
    if (results != null && results.isNotEmpty) {
      formData.formDataFromJson(results).forEach((element) {
        var searchedProjectList = projectList.where((v) => v.id == element.id);
        element.projectName = searchedProjectList.isEmpty
            ? 'N/A'
            : searchedProjectList.first.projectName;
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

  void goToSettings() {
    OdkUtil.instance.goToSettings();
  }
}
