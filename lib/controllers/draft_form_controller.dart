import 'package:get/get.dart';
import 'package:m_survey/controllers/dashboard_controller.dart';
import 'package:m_survey/models/form_data.dart' as formData;
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/repository/dashboard_repository.dart';
import 'package:m_survey/utils/odk_util.dart';
import 'package:m_survey/widgets/show_toast.dart';

import '../repository/form_repository.dart';

class DraftFormController extends GetxController {
  var formList = <formData.FormData>[].obs;
  var formListTemp = <formData.FormData>[].obs;
  var selectedProject;
  var isCheckedAll = false.obs;
  var isLoadingDraftForm = false.obs;

  var projectList = <ProjectListFromLocalDb>[].obs;

  final DashboardRepository _dashboardRepository = DashboardRepository();

  DashboardController _dashboardController = Get.find();

  ///true=asc, false=desc
  var ascOrDesc = false.obs;
  ProjectListFromLocalDb? currentProject;

  ///getting project list for dropdown
  loadProjects() async {
    projectList.clear();
    selectedProject =
        ProjectListFromLocalDb(id: 0, projectName: 'Select project');

    projectList.add(selectedProject);
    projectList.addAll(await _dashboardRepository.getAllProjectFromLocal());
  }

  ///getting active form data and project list here
  getAllData() async {
    isLoadingDraftForm.value = true;
    loadProjects();

    final results = await OdkUtil.instance.getDraftForms([]);
    if (results != null && results.isNotEmpty) {
      formList.value = formData.formDataFromJson(results);
      formListTemp.value = List.from(formList);
    }

    isLoadingDraftForm.value = false;
  }

  getProjectData() async {
    isLoadingDraftForm.value = true;
    projectList.clear();
    selectedProject = currentProject;
    projectList.add(selectedProject);

    var projectForms =
        await _dashboardRepository.getAllFormsByProject(currentProject!.id!);

    if (projectForms.isNotEmpty) {
      var formIds = projectForms.map((project) => project.idString!).toList();

      final results = await OdkUtil.instance.getDraftForms(formIds);
      if (results != null && results.isNotEmpty) {
        formList.value = formData.formDataFromJson(results);
        formListTemp.value = List.from(formList);
      }
    }

    isLoadingDraftForm.value = false;
  }

  getData() async {
    if (currentProject == null)
      await getAllData();
    else
      await getProjectData();
  }

  ///delete specific form
  void deleteForm(int id) async {
    final results = await OdkUtil.instance.deleteDraftForm(id);
    if (results != null && results.isNotEmpty) {
      Get.back();
      await getData();
      await _dashboardController.getDraftFormCount();
      return;
    }
  }

  ///filter draft project list
  void filter(int projectId) {
    if (projectId == selectedProject.id) return;

    selectedProject =
        projectList.firstWhere((element) => element.id == projectId);

    if (projectId == 0)
      formList.value = formListTemp;
    else
      formList.value =
          formListTemp.where((v) => v.projectId == projectId).toList();
  }

  ///edit form
  void editDraftForm(int id) async {
    final results = await OdkUtil.instance.editForm(id);
    if (results != null && results.isNotEmpty) {
      return;
    }
  }

  ///sort list asc or desc
  void sortByDate() async {
    if (formList.length > 0) {
      if (ascOrDesc.value) {
        formList.sort((a, b) => a.lastChangeDate!.compareTo(b.lastChangeDate!));
        showToast(msg: 'Sorted by ascending order.');
      } else {
        formList
            .sort((a, b) => -a.lastChangeDate!.compareTo(b.lastChangeDate!));
        showToast(msg: 'Sorted by descending order');
      }
    }
  }
}
