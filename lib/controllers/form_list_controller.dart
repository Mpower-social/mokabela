import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/repository/form_repository.dart';
import 'package:m_survey/utils/odk_util.dart';
import 'package:m_survey/models/form_data.dart' as formData;
import 'package:m_survey/widgets/show_toast.dart';

class FormListController extends GetxController{
  var isCheckedAll = false.obs;
  var selectedStartDate = DateTime.now().obs;
  var selectedEndDate = DateTime.now().obs;

  var selectedStartDateStr = 'Start'.obs;
  var selectedEndDateStr = 'End'.obs;
  var _formRepository = FormRepository();
  var formList = <formData.FormData>[].obs;
  var formListTemp = <formData.FormData>[].obs;


  var selectedProject = ProjectListFromLocalDb(id: 0,projectName: 'Select project').obs;
  var isLoadingForm = false.obs;

  ///true=asc, false=desc
  var ascOrDesc = false.obs;

  ///pick date from datepicker
  void pickDate(String s) async{
    final DateTime? picked = await showDatePicker(
        context: Get.context!,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000, 8),
        lastDate: DateTime(2100));

    if(s == 'Start'){
      if (picked != null && picked != selectedStartDate) {
        selectedStartDate.value = picked;
        selectedStartDateStr.value = DateFormat('dd-MM-yyyy').format(picked);
        if(selectedEndDateStr!='End'){
          filter();
        }
      }
    }else{
      if (picked != null && picked != selectedEndDate) {
        selectedEndDate.value = picked;
        selectedEndDateStr.value = DateFormat('dd-MM-yyyy').format(picked);
        if(selectedStartDateStr!='Start'){
          filter();
        }
      }
    }
  }

  ///sync selected form
  void sync()async {
    await _formRepository.submitFormOperation(1,null);
  }

  ///sort (asc/desc) all forms by date
  void sortList() {

  }

  void filter(){
    print('called');
    if(selectedStartDate.value==null && selectedEndDate.value==null) formList.value = formListTemp.value;
    else {
      formList.value = formListTemp.where((v){
        var d = DateTime.fromMillisecondsSinceEpoch(v.lastChangeDate!);
        var datetime = DateTime(d.year,d.month,d.day);
        return (datetime.compareTo(selectedStartDate.value)>=0 && datetime.compareTo(selectedEndDate.value)<=0);
      }).toList();
    }
  }

  ///send forms to draft
  void sendBackToDraft() {}

  void getDraftFormByFormId(String? formId) async{
    isLoadingForm.value = true;
    final results = await OdkUtil.instance.getDraftForms([formId!]);
    if (results != null && results.isNotEmpty) {
      formList.value = formData.formDataFromJson(results);
      formListTemp.value = formList.value;
      isLoadingForm.value = false;
      return;
    }
    formList.value = [];
    isLoadingForm.value = false;
  }

  ///getting all complete form here
  getCompleteFormList(String? formId) async{
    isLoadingForm.value = true;
    final results = await OdkUtil.instance.getFinalizedForms([formId!]);
    if (results != null && results.isNotEmpty) {
      formList.value = formData.formDataFromJson(results);
      formListTemp.value = formList.value;
      isLoadingForm.value = false;
      return;
    }
    formList.value = [];
    isLoadingForm.value = false;
  }

  ///sort list asc or desc
  void sortByDate() async{
    if(formList.length>0){
      if(ascOrDesc.value){
        formList.sort((a,b)=>a.lastChangeDate!.compareTo(b.lastChangeDate!));
        showToast(msg: 'Sorted by ascending order.');
      }else{
        formList.sort((a,b)=>-a.lastChangeDate!.compareTo(b.lastChangeDate!));
        showToast(msg: 'Sorted by descending order');
      }
    }
  }

  ///edit form
  void editDraftForm(int id) async{
    final results = await OdkUtil.instance.editForm(id);
    if (results != null && results.isNotEmpty) {
      return;
    }
  }

  ///delete specific form
  void deleteForm(int id,String formId) async{
    final results = await OdkUtil.instance.deleteDraftForm(id);
    if (results != null && results.isNotEmpty) {
      Get.back();
       getDraftFormByFormId(formId);
      return;
    }
  }

}