import 'package:m_survey/models/local/submitted_form_list_data.dart';

class SubmittedCheckboxData{
  bool isChecked = false;
  SubmittedFormListData? submittedFormListData;

  SubmittedCheckboxData(this.isChecked, this.submittedFormListData);
}