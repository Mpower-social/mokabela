import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:m_survey/repository/form_repository.dart';

class FormListController extends GetxController{
  var isCheckedAll = false.obs;
  var selectedStartDate = DateTime.now().obs;
  var selectedEndDate = DateTime.now().obs;

  var selectedStartDateStr = 'Start'.obs;
  var selectedEndDateStr = 'End'.obs;
  var _formRepository = FormRepository();

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
      }
    }else{
      if (picked != null && picked != selectedEndDate) {
        selectedEndDate.value = picked;
        selectedEndDateStr.value = DateFormat('dd-MM-yyyy').format(picked);
      }
    }
  }

  ///sync selected form
  void sync()async {
    _formRepository.submitFormOperation(1);
  }

  ///sort (asc/desc) all forms by date
  void sortList() {

  }

  ///send forms to draft
  void sendBackToDraft() {}

}