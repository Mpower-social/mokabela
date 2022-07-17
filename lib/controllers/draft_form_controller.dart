import 'package:get/get.dart';
import 'package:m_survey/models/form_data.dart' as formData;
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/repository/dashboard_repository.dart';
import 'package:m_survey/utils/odk_util.dart';

class DraftFormController extends GetxController{
  var formList = <formData.FormData>[].obs;
  var selectedProject = ProjectListFromLocalDb(id: 0,projectName: 'Select project').obs;  var isCheckedAll = false.obs;
  var projectList = <ProjectListFromLocalDb>[].obs;

  final DashboardRepository _dashboardRepository = DashboardRepository();

  @override
  void onInit()async{
    super.onInit();
    await loadProjects();
    await getDraftFormList();
  }

  loadProjects() async{
    projectList.clear();
    projectList.add(ProjectListFromLocalDb(id: 0,projectName: 'Select project'));
    projectList.addAll(await _dashboardRepository.getAllProjectFromLocal());
  }

  getDraftFormList() async{
    final results = await OdkUtil.instance.getDraftForms(['member_register_test901']);
    if (results != null && results.isNotEmpty) {
     formList.value = formData.formDataFromJson(results);
     return;
    }
    formList.value = [];
  }
}