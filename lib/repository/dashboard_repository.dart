import 'package:m_survey/constans/table_column.dart';
import 'package:m_survey/database/database_provider.dart';
import 'package:m_survey/models/local/all_form_list_data.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/models/local/submitted_form_list_data.dart';
import 'package:m_survey/models/response/all_form_list_response.dart';
import 'package:m_survey/models/response/project_list_response.dart';
import 'package:m_survey/models/response/reverted_form_list_response.dart';
import 'package:m_survey/models/response/submitted_form_list_response.dart';
import 'package:m_survey/services/dashboard_service.dart';
import 'package:m_survey/utils/shared_pref.dart';
import 'package:sqflite/sqflite.dart';

class DashboardRepository {
  final DashboardService _dashboardService = DashboardService();

  ////////remote data////////
  Future<List<ProjectListFromLocalDb>> getProjectListOperation(bool forceLoad) async {
    try {
      List<ProjectListFromLocalDb> projectList = await getAllProjectFromLocal();

      if (projectList.isEmpty || forceLoad) {
        ProjectListResponse? projectListResponse =
            await _dashboardService.getProjectListOperation();

        if (projectListResponse != null) {
          if (projectListResponse.data!.isNotEmpty) {
            for (var projectData in projectListResponse.data!) {
              insertProject(ProjectListFromLocalDb(
                id: int.tryParse(projectData.id!),
                projectName: projectData.attributes?.name,
                startDate: projectData.attributes?.startDate.toString(),
                endDate: projectData.attributes?.endDate.toString(),
                status: projectData.attributes?.projectStatus?.id.toString(),
                isPublished: projectData.attributes?.isPublished,
                isActive: projectData.attributes?.isActive,
                isArchived: projectData.attributes?.isArchived,
                isDeleted: projectData.attributes?.projectMember?.voided,
              ));
            }
            if ((projectListResponse.data?.length ?? 0) > 0) {
              await SharedPref.sharedPref.setString(
                  SharedPref.PROJECT_DATE_TIME,
                  projectListResponse.data?[0].attributes?.updatedAt ?? '0');
            }
          }

          return await getAllProjectFromLocal();
        }
      }
      return projectList;
    } catch (_) {
      return [];
    }
  }

  Future<String> getFormList() async {
    return await _dashboardService.getFormList() ?? '';
  }

  Future<List<SubmittedFormListData?>> getSubmittedFormList(
      bool forceLoad) async {
    try {
      List<SubmittedFormListData> submittedFormList =
          await getAllSubmittedFromLocal();

      ///checking data already exist or not
      if (submittedFormList.isEmpty || forceLoad) {
        ///getting data from remote
        List<SubmittedFormListResponse?>? submittedFormListResponse =
            await _dashboardService.getSubmittedFormList();
        if (submittedFormListResponse != null) {
          for (var formData in submittedFormListResponse) {
            ///inserting data to local
            await insertSubmittedForms(SubmittedFormListData(
                id: formData?.id,
                formName: formData?.formName,
                formIdString: formData?.formIdString,
                projectId: formData?.projectId,
                dateCreated: formData?.dateCreated.toString(),
                submittedById: formData?.submittedBy?.id,
                submittedByUsername: formData?.submittedBy?.username,
                submittedByFirstLame: formData?.submittedBy?.firstName,
                submittedByLastName: formData?.submittedBy?.lastName,
                instanceId: formData?.instanceId,
                xml: formData?.xml));
          }

          ///inserting last updated datetime here
          if (submittedFormListResponse.length > 0) {
            await SharedPref.sharedPref.setString(
                SharedPref.SUBMITTED_FORM_DATE_TIME,
                submittedFormListResponse[0]?.dateUpdated ?? '0');
          }
          return await getAllSubmittedFromLocalByDelete();
        }
      }
      return await getAllSubmittedFromLocalByDelete();
    } catch (_) {
      return [];
    }
  }

  Future<List<AllFormsData?>> getAllActiveFormList(bool forceLoad) async {
    var allForms = await getAllFormList(forceLoad);
    return allForms.where((element) => element?.isActive == true).toList();
  }

  Future<List<AllFormsData?>> getAllFormList(bool forceLoad) async {
    try {
      List<AllFormsData> allFormList = await getAllFromLocal();

      ///checking data already exist or not
      if (allFormList.isEmpty || forceLoad) {
        ///getting data from remote
        AllFormListResponse? allFormResponse =
            await _dashboardService.getAllFormList();

        ///checking data already exist or not
        if (allFormResponse?.data != null) {
          for (Data formData in allFormResponse?.data ?? []) {
            ///inserting data to local
            insertAllForms(AllFormsData(
                id: formData.id,
                xFormId: formData.attributes?.xformId,
                title: formData.attributes?.title,
                idString: formData.attributes?.idString,
                createdAt: formData.attributes?.createdAt,
                updatedAt: formData.attributes?.updatedAt,
                target: formData.attributes?.target,
                projectId: formData.attributes?.project?.id ?? 0,
                projectName: formData.attributes?.project?.name ?? '',
                projectDes: formData.attributes?.project?.description ?? '',
                isActive: formData.attributes?.isActive,
                isPublished: formData.attributes?.isPublished));
          }

          ///inserting last updated datetime here
          if ((allFormResponse?.data!.length ?? 0) > 0) {
            await SharedPref.sharedPref.setString(SharedPref.ALL_FORM_DATE_TIME,
                allFormResponse?.data?[0].attributes?.updatedAt ?? '0');
          }
          return await getAllFromLocal();
        }
      }
      return allFormList;
    } catch (_) {
      return [];
    }
  }

  Future<List<AllFormsData?>> getRevertedFormList(bool forceLoad) async {
    try {
      List<AllFormsData> allFormList = await getRevertedFromLocal();

      ///checking data already exist or not
      if (allFormList.isEmpty || forceLoad) {
        ///getting data from remote
        RevertedFormListResponse? revertedFormListResponse =
            await _dashboardService.getRevertedFormList();

        ///checking data already exist or not
        if (revertedFormListResponse?.data != null) {
          for (RevertedDatum formData in revertedFormListResponse?.data ?? []) {
            ///inserting data to local
            insertRevertedForms(AllFormsData(
                id: formData.id,
                xFormId: formData.attributes?.xform?.xformId,
                title: formData.attributes?.xform?.title,
                idString: formData.attributes?.xform?.idString,
                createdAt: formData.attributes?.updatedAt.toString(),
                updatedAt: formData.attributes?.updatedAt.toString(),
                projectId: formData.attributes?.xform?.projectId,
                isActive: formData.attributes?.status == 'true' ? true : false,
                instanceId: formData.attributes?.instanceUuid,
                feedback: formData.attributes?.feedback));
          }

          ///inserting last updated datetime here
          if ((revertedFormListResponse?.data!.length ?? 0) > 0) {
            await SharedPref.sharedPref.setString(
                SharedPref.REVERTED_FORM_DATE_TIME,
                (revertedFormListResponse?.data?[0].attributes?.updatedAt ??
                        '0')
                    .toString());
          }
          return await getRevertedFromLocal();
        }
      }
      return allFormList;
    } catch (_) {
      return [];
    }
  }

  ///////////local data/////////

  ///insert project data to local
  void insertProject(ProjectListFromLocalDb projectListFromLocalDb) async {
    final Database? db = await DatabaseProvider.dbProvider.database;
    await db!.insert(TABLE_NAME_PROJECT, projectListFromLocalDb.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  ///getting all project from local
  Future<List<ProjectListFromLocalDb>> getAllProjectFromLocal() async {
    final Database? db = await DatabaseProvider.dbProvider.database;
    var data = await db!.rawQuery(
        'select p.*,(select count(*) from $TABLE_NAME_All_FORM as a'
        ' where p.$PROJECT_ID = a.$All_FORM_PROJECT_ID and a.$All_FORM_IS_PUBLISHED = ${1}) as $PROJECT_TOTAL_FORMS from $TABLE_NAME_PROJECT as p'
        ' where p.$PROJECT_IS_ARCHIVED = ${0} and p.$PROJECT_IS_DELETED != ${1}');
    return List<ProjectListFromLocalDb>.from(
        data.map((x) => ProjectListFromLocalDb.fromJson(x)));
  }

  ///insert submitted form
  insertSubmittedForms(SubmittedFormListData submittedFormListResponse) async {
    final Database? db = await DatabaseProvider.dbProvider.database;
    await db!.insert(
        TABLE_NAME_SUBMITTED_FORM, submittedFormListResponse.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  ///getting all undeleted submitted form here
  Future<List<SubmittedFormListData>> getAllSubmittedFromLocalByDelete() async {
    final Database? db = await DatabaseProvider.dbProvider.database;
    var data = await db!.rawQuery(
        'select s.* from $TABLE_NAME_SUBMITTED_FORM as s where s.$SUBMITTED_ID not in (select * from $TABLE_NAME_DELETED_SUBMITTED_FORM) ORDER BY s.$SUBMITTED_DATE_CREATED DESC');
    return List<SubmittedFormListData>.from(
        data.map((x) => SubmittedFormListData.fromJson(x)));
  }

  //getting undeleted submitted form from local base on project id
  Future<List<SubmittedFormListData>>
      getAllUndeletedSubmittedFromLocalByProject(int projectId) async {
    final Database? db = await DatabaseProvider.dbProvider.database;
    var data = await db!.rawQuery(
        'select s.* from $TABLE_NAME_SUBMITTED_FORM as s where s.$SUBMITTED_PROJECT_ID = $projectId AND s.$SUBMITTED_ID not in (select * from $TABLE_NAME_DELETED_SUBMITTED_FORM) ORDER BY s.$SUBMITTED_DATE_CREATED DESC');
    return List<SubmittedFormListData>.from(
        data.map((x) => SubmittedFormListData.fromJson(x)));
  }

  ///getting all submitted form from local
  Future<List<SubmittedFormListData>> getAllSubmittedFromLocal() async {
    final Database? db = await DatabaseProvider.dbProvider.database;
    var data = await db!.rawQuery(
        'select * from $TABLE_NAME_SUBMITTED_FORM ORDER BY $SUBMITTED_DATE_CREATED DESC');
    return List<SubmittedFormListData>.from(
        data.map((x) => SubmittedFormListData.fromJson(x)));
  }

  ///insert form data to local
  void insertAllForms(AllFormsData allFormsData) async {
    final Database? db = await DatabaseProvider.dbProvider.database;
    await db!.insert(TABLE_NAME_All_FORM, allFormsData.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  ///getting all form data from local
  Future<List<AllFormsData>> getAllFromLocal() async {
    final Database? db = await DatabaseProvider.dbProvider.database;
    var data = await db!.rawQuery(
        'select a.*,(select count(*) from $TABLE_NAME_SUBMITTED_FORM as s where s.$SUBMITTED_FORM_ID_STRING = a.$All_FORM_ID_STRING) as totalSubmission '
        'from $TABLE_NAME_All_FORM as a left join $TABLE_NAME_PROJECT as p on a.$All_FORM_PROJECT_ID = p.$PROJECT_ID where p.$PROJECT_IS_ARCHIVED = ${0} '
        'and a.$All_FORM_IS_PUBLISHED = ${1} and p.$PROJECT_IS_DELETED != ${1} ORDER BY a.$All_FORM_CREATED_AT DESC');
    return List<AllFormsData>.from(data.map((x) => AllFormsData.fromJson(x)));
  }

  ///getting all form data from local for a project
  Future<List<AllFormsData>> getAllFormsByProject(int projectId) async {
    final Database? db = await DatabaseProvider.dbProvider.database;
    /*var data = await db!.rawQuery(
        "select * from $TABLE_NAME_All_FORM f WHERE f.$All_FORM_PROJECT_ID = $projectId ORDER BY $All_FORM_CREATED_AT DESC");*/
    var data = await db!.rawQuery(
        'select a.*,(select count(*) from $TABLE_NAME_SUBMITTED_FORM as s '
        'where s.$SUBMITTED_FORM_ID_STRING = a.$All_FORM_ID_STRING) as totalSubmission from $TABLE_NAME_All_FORM as a '
        'WHERE a.$All_FORM_PROJECT_ID = $projectId and a.$All_FORM_IS_PUBLISHED = ${1} ORDER BY a.$All_FORM_CREATED_AT DESC');
    return List<AllFormsData>.from(data.map((x) => AllFormsData.fromJson(x)));
  }

  ///getting all form data from local for a project
  Future<List<AllFormsData>> getAllActiveFormsByProject(int projectId) async {
    final Database? db = await DatabaseProvider.dbProvider.database;
    /*var data = await db!.rawQuery(
        "select * from $TABLE_NAME_All_FORM f WHERE f.$All_FORM_PROJECT_ID = $projectId AND f.$All_FORM_STATUS = 'true' ORDER BY $All_FORM_CREATED_AT DESC");*/
    var query = 'select a.*,(select count(*) from $TABLE_NAME_SUBMITTED_FORM as s where s.$SUBMITTED_FORM_ID_STRING = a.$All_FORM_ID_STRING) as totalSubmission '
        'from $TABLE_NAME_All_FORM as a '
        'left join $TABLE_NAME_PROJECT as p on a.$All_FORM_PROJECT_ID = p.$PROJECT_ID where p.$PROJECT_IS_PUBLISHED = ${1} and p.$PROJECT_IS_ARCHIVED = ${0} and'
        ' a.$All_FORM_PROJECT_ID = $projectId AND a.$All_FORM_IS_PUBLISHED = ${1} and p.$PROJECT_IS_DELETED != ${1}  ORDER BY a.$All_FORM_CREATED_AT DESC';
    print(query);
    var data = await db!.rawQuery(query);
    return List<AllFormsData>.from(data.map((x) => AllFormsData.fromJson(x)));
  }

  ///insert reverted form data to local
  void insertRevertedForms(AllFormsData allFormsData) async {
    final Database? db = await DatabaseProvider.dbProvider.database;
    await db!.insert(
        TABLE_NAME_REVERTED_FORM, allFormsData.toJsonRevertedForm(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  ///getting reverted form data from local
  Future<List<AllFormsData>> getRevertedFromLocal() async {
    final Database? db = await DatabaseProvider.dbProvider.database;
    var data = await db!.rawQuery(
        'select * from $TABLE_NAME_REVERTED_FORM ORDER BY $All_FORM_CREATED_AT DESC');
    return List<AllFormsData>.from(data.map((x) => AllFormsData.fromJson(x)));
  }

  ///getting reverted form data from local
  Future<List<AllFormsData>> getRevertedFromLocalByFromId(formId) async {
    final Database? db = await DatabaseProvider.dbProvider.database;
    var data = await db!.rawQuery(
        'select r.*,s.$SUBMITTED_XML from $TABLE_NAME_REVERTED_FORM as r left join $TABLE_NAME_SUBMITTED_FORM as s on s.$SUBMITTED_INSTANCE_ID = r.$REVERTED_FORM_INSTANCE_ID where $REVERTED_FORM_ID_STRING = "$formId" ORDER BY $All_FORM_CREATED_AT DESC');
    return List<AllFormsData>.from(data.map((x) => AllFormsData.fromJson(x)));
  }
}
