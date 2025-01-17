import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:m_survey/controllers/dashboard_controller.dart';
import 'package:m_survey/enum/form_status.dart';
import 'package:m_survey/models/draft_checkbox_data.dart';
import 'package:m_survey/models/form_submit_status.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/models/local/submitted_form_list_data.dart';
import 'package:m_survey/repository/dashboard_repository.dart';
import 'package:m_survey/repository/form_repository.dart';
import 'package:m_survey/repository/project_repository.dart';
import 'package:m_survey/utils/odk_util.dart';
import 'package:m_survey/models/form_data.dart' as formData;
import 'package:m_survey/widgets/form_submit_status_dialog.dart';
import 'package:m_survey/widgets/progress_dialog.dart';
import 'package:m_survey/widgets/show_toast.dart';

class FormListController extends GetxController {
  var isCheckedAll = false.obs;
  var selectedStartDate = DateTime.now().obs;
  var selectedEndDate = DateTime.now().obs;

  var selectedStartDateStr = 'Start'.obs;
  var selectedEndDateStr = 'End'.obs;
  var _formRepository = FormRepository();
  var formList = <formData.FormData>[].obs;
  var formListTemp = <formData.FormData>[].obs;
  var isCheckList = <DraftCheckboxData>[].obs;
  var isCheckListTemp = <DraftCheckboxData>[].obs;

  var submittedFormList = <SubmittedFormListData?>[].obs;
  var submittedFormListTemp = <SubmittedFormListData?>[].obs;
  var formSubmitStatusList = <FormSubmitStatus>[].obs;

  var selectedProject =
      ProjectListFromLocalDb(id: 0, projectName: 'Select project').obs;
  var isLoadingForm = false.obs;

  ///true=asc, false=desc
  var ascOrDesc = false.obs;

  ProjectRepository _projectRepository = ProjectRepository();
  DashboardRepository _dashboardRepository = DashboardRepository();

  DashboardController _dashboardController = Get.find();

  ///pick date from datepicker
  void pickDate(String s) async {
    final DateTime? picked = await showDatePicker(
        context: Get.context!,
        initialDate: DateTime.now(),
        firstDate: /*DateTime(2000, 8).subtract(*/s == 'Start'?selectedEndDate.value.subtract(Duration(days: 3650)):selectedStartDate.value, //3650 = 10 years before
        lastDate: /*DateTime(2100).subtract(Duration(days: selectedStartDate.value.day))*/s=='End'?selectedStartDate.value.add(Duration(days: 3650)):selectedEndDate.value //3650 = 10 years after
    );

    if (s == 'Start') {
      if (picked != null && picked != selectedStartDate) {
       /* if(selectedStartDate.value.difference(selectedEndDate.value).inMicroseconds<=0 && selectedEndDate!=DateTime.now()){
          showToast(msg: 'Select valid date');
          return;
        }*/
        selectedStartDate.value = picked;
        selectedStartDateStr.value = DateFormat('dd-MM-yyyy').format(picked);
        if (selectedEndDateStr != 'End') {
          filter();
        }
      }
    } else {
      /*if(selectedStartDate.value.difference(selectedEndDate.value).inMicroseconds>=0 && selectedStartDate!=DateTime.now()){
        showToast(msg: 'Select valid date');
        return;
      }*/
      if (picked != null && picked != selectedEndDate) {
        selectedEndDate.value = picked;
        selectedEndDateStr.value = DateFormat('dd-MM-yyyy').format(picked);
        if (selectedStartDateStr != 'Start') {
          filter();
        }
      }
    }
  }

  ///sync selected form
  void sync(String? formId) async {
    var anySelected = isCheckList.any((element) => element.isChecked == true);
    if (!anySelected) {
      showToast(msg: 'You didn\'t select any form');
      return;
    }

    progressDialog();
    formSubmitStatusList.clear();
    try {
      for (var element in isCheckList) {
        if (element.isChecked && element.formData != null) {
          if(_dashboardController.allFormList.firstWhereOrNull((e) => (e?.isActive==true && e?.idString == element.formData?.formId))!=null){
            final results =
            await _formRepository.submitFormOperation(element.formData);
            if (results.isNotEmpty) {
              formSubmitStatusList.add(FormSubmitStatus(element.formData?.displayName??'',true));
            }else{
              formSubmitStatusList.add(FormSubmitStatus(element.formData?.displayName??'',false));
            }
          }
        }
      }
    } catch (_) {
    } finally {
      await getCompleteFormList(formId);
      await _dashboardRepository.getSubmittedFormList(true);
      Get.back();
      showFormSubmitStatusDialog(formSubmitStatusList);
      isCheckedAll.value = false;
    }
  }

  ///sort (asc/desc) all forms by date
  void sortList() {}

  void filter() {
    if (selectedStartDate.value == null && selectedEndDate.value == null)
      isCheckList.value = isCheckListTemp.value;
    else {
      print(selectedStartDate);

      formList.value = formListTemp.where((v) {
        var d = DateTime.fromMillisecondsSinceEpoch(v.lastChangeDate!);
        var datetime = DateTime(d.year, d.month, d.day);
        return (datetime.compareTo(selectedStartDate.value) >= 0 &&
            datetime.compareTo(selectedEndDate.value) <= 0);
      }).toList();
      setupDefaultCheckBox();
    }
  }

  void getDraftFormByFormId(String? formId) async {
    isLoadingForm.value = true;
    final results = await OdkUtil.instance.getDraftForms([formId!]);
    if (results != null && results.isNotEmpty) {
      formList.value = formData.formDataFromJson(results);
      formListTemp.value = formList.value;
      setupDefaultCheckBox();
      isLoadingForm.value = false;
      return;
    }
    formList.value = [];
    isLoadingForm.value = false;
  }

  ///getting all complete form here
  getCompleteFormList(String? formId) async {
    isLoadingForm.value = true;
    final results = await OdkUtil.instance.getFinalizedForms([formId!]);
    if (results != null && results.isNotEmpty) {

      formList.value = formData.formDataFromJson(results);
      formListTemp.value = formList.value;
      setupDefaultCheckBox();
      isLoadingForm.value = false;
      return;
    }
    formList.value = [];
    isLoadingForm.value = false;
  }

  ///getting reverted form here
  void getRevertedFormList(String formId) async {
    isLoadingForm.value = true;
    formList.clear();
    var submittedList =
        await _dashboardRepository.getRevertedFromLocalByFromId(formId);
    submittedList.forEach((element) {
      formList.add(formData.FormData(
          id: int.tryParse(element.xFormId ?? ''),
          projectId: element.projectId.toString(),
          displayName: element.title,
          formId: element.idString ?? '',
          lastChangeDate: DateTime.parse(element.updatedAt!).millisecondsSinceEpoch,
          xml: element.xml,
          instanceId: element.instanceId,
          feedback: element.feedback,
          status: element.isActive.toString()
      ));
    });
    formListTemp.value = formList.value;
    setupDefaultCheckBox();
    isLoadingForm.value = false;
  }

  ///getting submitted forms here
   getSubmittedFormList(String formId) async {
    formList.clear();
    isLoadingForm.value = true;
    var submittedList =
        await _projectRepository.getAllSubmittedFromLocalByForm(formId);
    submittedList.forEach((element) {
      formList.add(formData.FormData(
          id: element.id ?? 0,
          projectId: element.projectId.toString(),
          displayName: element.formName ?? '',
          formId: element.formIdString ?? '',
          lastChangeDate: DateTime.parse(element.dateCreated!).millisecondsSinceEpoch));
    });
    formListTemp.value = formList.value;
    setupDefaultCheckBox();
    isLoadingForm.value = false;
  }

  ///sort list asc or desc
  void sortByDate() async {
    if (isCheckList.length > 0) {
      if (ascOrDesc.value) {
        isCheckList.sort((a, b) =>
            a.formData!.lastChangeDate!.compareTo(b.formData!.lastChangeDate!));
        showToast(msg: 'Sorted by ascending order.');
      } else {
        isCheckList.sort((a, b) => -a.formData!.lastChangeDate!
            .compareTo(b.formData!.lastChangeDate!));
        showToast(msg: 'Sorted by descending order');
      }
    }
  }

  ///edit form
  void editForm(formData.FormData formData, FormStatus formStatus) async {
    final results;
    print(jsonEncode(formData));
    if(formStatus == FormStatus.reverted){
      print(jsonEncode(formData));
      results = await OdkUtil.instance.correctForm(formData);
    }else{
      results = await OdkUtil.instance.editForm(formData.id!);
    }
    if (results != null && results.isNotEmpty) {
      if(formStatus == FormStatus.reverted){
        getRevertedFormList(formData.formId??'');
      }else{
        getDraftFormByFormId(formData.formId);
      }
      return;
    }
  }

  ///delete specific form
  void deleteForm(int id, String formId) async {
    final results = await OdkUtil.instance.deleteDraftForm(id);
    if (results != null && results.isNotEmpty) {
      Get.back();
      getDraftFormByFormId(formId);
      return;
    }
  }

  ///delete multiple data
  void deleteMultipleForm(String formId) async {
    var anySelected = isCheckList.any((element) => element.isChecked == true);
    if (!anySelected) {
      showToast(msg: 'You didn\'t select any form to delete');
      return;
    }

    try {
      for (var element in isCheckList) {
        if (element.isChecked) {
          _formRepository.deleteSubmittedForm(SubmittedFormListData(id: element.formData?.id));
        }
      }
    } catch (_) {
    } finally {
      await getSubmittedFormList(formId);
    }
  }

  ///sending complete list to draft
  void sendBackToDraft(String? formId) async {
    for (var element in isCheckList) {
      if (element.isChecked && element.formData != null) {
        final results =
            await OdkUtil.instance.sendBackToDraft(element.formData?.id ?? 0);
        if (results != null && results.isNotEmpty) {
          //succ
        }
      }
    }
    await getCompleteFormList(formId);
    setupDefaultCheckBox();
  }

  //initial defaults checkbox
  void setupDefaultCheckBox() {
    isCheckList.clear();
    formList.forEach((element) {
      isCheckList.add(DraftCheckboxData(false, element));
    });
    isCheckListTemp = isCheckList;
  }

  ///handling checkbox
  void addCheckBoxData(var pos, {from = 'each', formData.FormData? formData}) {
    if (from == 'each') {
      var trueCount = 0;
      isCheckList[pos] =
          DraftCheckboxData(!isCheckList[pos].isChecked, formData);

      isCheckList.forEach((element) {
        if (element.isChecked) trueCount++;
      });
      print(trueCount);

      if (trueCount == formList.length)
        isCheckedAll.value = true;
      else
        isCheckedAll.value = false;
    } else {
      for (int i = 0; i < formList.length; i++) {
        if (isCheckedAll.value) {
          isCheckList[i] = DraftCheckboxData(true, formList[i]);
        } else {
          isCheckList[i] = DraftCheckboxData(false, formList[i]);
        }
      }
    }
  }
}
