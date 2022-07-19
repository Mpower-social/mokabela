import 'package:get/get.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/repository/dashboard_repository.dart';
import 'package:m_survey/utils/odk_util.dart';
import 'package:m_survey/utils/shared_pref.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:m_survey/models/form_data.dart' as formData;


class DashboardController extends GetxController {
  var name = ''.obs;
  var designation = ''.obs;
  var recentFormList = <formData.FormData>[].obs;
  var projectList = <ProjectListFromLocalDb>[].obs;
  var isLoadingProject = false.obs;

  final DashboardRepository _dashboardRepository = DashboardRepository();

  @override
  void onInit()async{
    super.onInit();
    handlePermission();
    getUserdata();
    loadProjects(false);
    downloadForm();
    await getRecentFormList();
  }

  void getUserdata()async{
    name.value = await SharedPref.sharedPref.getString(SharedPref.NAME)??'';
    designation.value = await SharedPref.sharedPref.getString(SharedPref.DESIGNATION)??'';
  }

  void loadProjects(forceLoad) async{
    isLoadingProject.value = true;
    projectList.value = await _dashboardRepository.getProjectListOperation(1, 10,forceLoad);
    isLoadingProject.value = false;
  }

  getRecentFormList() async{
    final results = await OdkUtil.instance.getRecentForms(['member_register_test901']);
    if (results != null && results.isNotEmpty) {
      recentFormList.value = formData.formDataFromJson(results);
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

  void handlePermission() async{
    await [
        Permission.storage,
    ].request();
    if (await Permission.storage.request().isGranted) {
      print('granted');
    }
  }


}