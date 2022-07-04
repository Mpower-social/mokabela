import 'package:get/get.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/repository/dashboard_repository.dart';

class SubmittedFormController extends GetxController{
  var formList = ['Test1','Test2','test3'];
  var selectedProject = ProjectListFromLocalDb(id: 0,projectName: 'Select project').obs;
  var isCheckedAll = false.obs;
  var projectList = <ProjectListFromLocalDb>[].obs;

  final DashboardRepository _dashboardRepository = DashboardRepository();

  @override
  void onInit()async{
    super.onInit();
   await loadProjects();
  }

  loadProjects() async{
    projectList.clear();
    projectList.add(ProjectListFromLocalDb(id: 0,projectName: 'Select project'));
    projectList.addAll(await _dashboardRepository.getAllProjectFromLocal());
  }
}