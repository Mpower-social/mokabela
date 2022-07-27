import 'package:m_survey/constans/table_column.dart';

class ProjectListFromLocalDb {
  int? id = 0;
  String? projectName = '';
  String? noOfForms = '0';
  String? startDate = '';
  String? endDate = '';
  String? status = '';
  int? totalForms = 0;

  ProjectListFromLocalDb({
    this.id,
    this.projectName,
    this.noOfForms,
    this.startDate,
    this.endDate,
    this.status,
    this.totalForms
  });

  factory ProjectListFromLocalDb.fromJson(Map<String, dynamic> json) =>
      ProjectListFromLocalDb(
        id: json[PROJECT_ID] ?? '',
        projectName: json[PROJECT_NAME] ?? '',
        noOfForms: json[PROJECT_NO_OF_FORMS] ?? '',
        startDate: json[PROJECT_START_DATE] ?? '',
        endDate: json[PROJECT_END_DATE] ?? '',
        status: json[PROJECT_STATUS],
        totalForms: json[PROJECT_TOTAL_FORMS],
      );

  Map<String, dynamic> toJson() => {
        PROJECT_ID: id ?? 0,
        PROJECT_NAME: projectName ?? '',
        PROJECT_NO_OF_FORMS: noOfForms ?? '0',
        PROJECT_START_DATE: startDate ?? '',
        PROJECT_END_DATE: endDate ?? '',
        PROJECT_STATUS: status ?? '',
      };
}
