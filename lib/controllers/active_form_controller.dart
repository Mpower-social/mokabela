import 'package:get/get.dart';
import 'package:m_survey/models/local/all_form_list_data.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/repository/dashboard_repository.dart';
import 'package:m_survey/widgets/show_toast.dart';

class ActiveFormController extends GetxController {
  var formList = ['Test1', 'Test2', 'test3'];
  var selectedProject;
  var isCheckedAll = false.obs;
  var projectList = <ProjectListFromLocalDb>[].obs;
  var allFormList = <AllFormsData?>[].obs;
  var allFormListTemp = <AllFormsData?>[].obs;
  var isLoadingForms = false.obs;

  final DashboardRepository _dashboardRepository = DashboardRepository();

  ///true=asc, false=desc
  var ascOrDesc = false.obs;
  bool showActiveFormsOnly = false;
  ProjectListFromLocalDb? currentProject;

  @override
  void onInit() async {
    super.onInit();
  }

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

    allFormList.value = showActiveFormsOnly
        ? await _dashboardRepository.getAllActiveFormList(false)
        : await _dashboardRepository.getAllFormList(false);
    allFormListTemp.value = List.from(allFormList);

    isLoadingForms.value = false;
  }

  getProjectData() async {
    isLoadingForms.value = true;
    projectList.clear();
    selectedProject = currentProject;
    projectList.add(selectedProject);

    allFormList.value = await _dashboardRepository
        .getAllActiveFormsByProject(currentProject!.id!);
    allFormListTemp.value = List.from(allFormList);

    isLoadingForms.value = false;
  }

  getData() async {
    if (currentProject == null)
      await getAllData();
    else
      await getProjectData();
  }

  ///filter draft project list
  void filter(int projectId) {
    if (projectId == selectedProject.id) return;

    selectedProject =
        projectList.firstWhere((element) => element.id == projectId);

    if (projectId == 0)
      allFormList.value = allFormListTemp;
    else
      allFormList.value = allFormListTemp
          .where((v) => (v?.projectId ?? 0) == projectId)
          .toList();
  }

  ///sort list asc or desc
  void sortByDate() async {
    if (allFormList.length > 0) {
      if (ascOrDesc.value) {
        allFormList.sort((a, b) => a!.createdAt!.compareTo(b!.createdAt!));
        showToast(msg: 'Sorted by ascending order.');
      } else {
        allFormList.sort((a, b) => -a!.createdAt!.compareTo(b!.createdAt!));
        showToast(msg: 'Sorted by descending order');
      }
    }
  }
}
