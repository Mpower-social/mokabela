import 'package:m_survey/constans/table_column.dart';


var boolean = [
  false,
  true
];

class ProjectListFromLocalDb {
  int? id = 0;
  String? projectName = '';
  String? noOfForms = '0';
  String? startDate = '';
  String? endDate = '';
  String? status = '';
  int? totalForms = 0;
  bool? isPublished;
  bool? isActive;
  bool? isArchived;
  bool? isDeleted;

  ProjectListFromLocalDb({
    this.id,
    this.projectName,
    this.noOfForms,
    this.startDate,
    this.endDate,
    this.status,
    this.totalForms,
    this.isPublished,
    this.isActive,
    this.isArchived,
    this.isDeleted,
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
        isPublished: boolean[json[PROJECT_IS_PUBLISHED]],
        isActive:  boolean[json[PROJECT_IS_ACTIVE]],
        isArchived:  boolean[json[PROJECT_IS_ARCHIVED]],
        isDeleted:  boolean[json[PROJECT_IS_DELETED]],
      );

  Map<String, dynamic> toJson() => {
        PROJECT_ID: id ?? 0,
        PROJECT_NAME: projectName ?? '',
        PROJECT_NO_OF_FORMS: noOfForms ?? '0',
        PROJECT_START_DATE: startDate ?? '',
        PROJECT_END_DATE: endDate ?? '',
        PROJECT_STATUS: status ?? '',
        PROJECT_IS_PUBLISHED: isPublished??false,
        PROJECT_IS_ACTIVE: isActive??false,
        PROJECT_IS_ARCHIVED: isArchived??false,
        PROJECT_IS_DELETED: isDeleted??false,
  };
}
