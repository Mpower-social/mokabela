import 'package:get/get.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/repository/dashboard_repository.dart';
import 'package:m_survey/utils/odk_util.dart';
import 'package:m_survey/utils/shared_pref.dart';

class DashboardController extends GetxController {
  var name = ''.obs;
  var designation = ''.obs;
  var recentFormList = [
    'Test 1',
    'test 2',
    'test 3',
    'test 4',
    'test 4',
    'test 4',
    'test 4' 'test 4' 'test 4' 'test 4'
  ];
  var projectList = <ProjectListFromLocalDb>[].obs;
  var isLoadingProject = false.obs;

  final DashboardRepository _dashboardRepository = DashboardRepository();

  @override
  void onInit()async{
    super.onInit();
    getUserdata();
    loadProjects(false);
    downloadForm();
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

  void downloadForm() async {
    _dashboardRepository.getFormList().then((value) async {
      final results = await OdkUtil.instance.initializeOdk(value);
      if (results != null && results.isNotEmpty) {
        print('Success');
      }
      print('failed');
    });
  }

}