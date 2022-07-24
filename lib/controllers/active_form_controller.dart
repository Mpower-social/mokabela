import 'package:get/get.dart';
import 'package:m_survey/models/local/all_form_list_data.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/repository/dashboard_repository.dart';
import 'package:m_survey/widgets/show_toast.dart';

class ActiveFormController extends GetxController{
  var formList = ['Test1','Test2','test3'];
  var selectedProject = ProjectListFromLocalDb(id: 0,projectName: 'Select project').obs;  var isCheckedAll = false.obs;
  var projectList = <ProjectListFromLocalDb>[].obs;
  var allFormList = <AllFormsData?>[].obs;
  var allFormListTemp = <AllFormsData?>[].obs;
  var isLoadingForms = false.obs;

  final DashboardRepository _dashboardRepository = DashboardRepository();

  ///true=asc, false=desc
  var ascOrDesc = false.obs;

  @override
  void onInit()async{
    super.onInit();
    await getData();
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
    allFormList.value = await _dashboardRepository.getAllFormList();
    allFormListTemp.value = allFormList.value;
    isLoadingForms.value = false;
  }

  ///filter draft project list
  void filter(int projectId){
    print(projectId);
    if(projectId == 0) allFormList.value = allFormListTemp;
    else allFormList.value = allFormListTemp.where((v) => (v?.projectId??0) == projectId).toList();
  }

  ///sort list asc or desc
  void sortByDate() async{
    if(allFormList.length>0){
      if(ascOrDesc.value){
        allFormList.sort((a,b)=>a!.createdAt!.compareTo(b!.createdAt!));
        showToast(msg: 'Sorted by ascending order.');
      }else{
        allFormList.sort((a,b)=>-a!.createdAt!.compareTo(b!.createdAt!));
        showToast(msg: 'Sorted by descending order');
      }
    }
  }

}