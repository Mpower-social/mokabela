import 'package:m_survey/constans/table_column.dart';
import 'package:m_survey/database/database_provider.dart';
import 'package:m_survey/models/local/all_form_list_data.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/models/local/submitted_form_list_data.dart';
import 'package:m_survey/models/response/all_form_list_response.dart';
import 'package:m_survey/models/response/project_list_response.dart';
import 'package:m_survey/models/response/submitted_form_list_response.dart';
import 'package:m_survey/services/dashboard_service.dart';
import 'package:m_survey/utils/shared_pref.dart';
import 'package:sqflite/sqflite.dart';

class DashboardRepository {
  final DashboardService _dashboardService = DashboardService();

  ////////remote data////////
  Future<List<ProjectListFromLocalDb>> getProjectListOperation(
      currentPage, pageSize, forceLoad) async {
    try{
      final Database? db = await DatabaseProvider.dbProvider.database;
      List<ProjectListFromLocalDb> projectList = await getAllProjectFromLocal();

      if (projectList.isEmpty || forceLoad) {
        ProjectListResponse? projectListResponse = await _dashboardService
            .getProjectListOperation(currentPage, pageSize);

        if (projectListResponse != null) {
          if (projectListResponse.data!.isNotEmpty) {
            db!.delete(TABLE_NAME_PROJECT);
            for (var projectData in projectListResponse.data!) {
              insertProject(ProjectListFromLocalDb(
                  id: int.tryParse(projectData.id!),
                  projectName: projectData.attributes?.name,
                  startDate: projectData.attributes?.startDate.toString(),
                  endDate: projectData.attributes?.endDate.toString(),
                  status: projectData.attributes?.projectStatus?.id.toString()));
            }
          }
          return await getAllProjectFromLocal();
        }
      }
      return projectList;
    }catch(_){
      return [];
    }
  }

  Future<String> getFormList() async {
    return await _dashboardService.getFormList() ?? '';
  }

  Future<List<SubmittedFormListData?>> getSubmittedFormList() async {
    try{
      final Database? db = await DatabaseProvider.dbProvider.database;

      List<SubmittedFormListData> submittedFormList =
      await getAllSubmittedFromLocal();

      ///checking data already exist or not
      if (submittedFormList.isEmpty) {
        ///getting data from remote
        List<SubmittedFormListResponse?>? submittedFormListResponse =
        await _dashboardService.getSubmittedFormList();
        if (submittedFormList != null) {
          db!.delete(TABLE_NAME_SUBMITTED_FORM);
          for (var formData in submittedFormListResponse!) {

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
                xml: formData?.xml));
          }
          ///inserting last updated datetime here
          if(submittedFormListResponse.length>0){
            await SharedPref.sharedPref.setString(SharedPref.SUBMITTED_FORM_DATE_TIME, submittedFormListResponse[0]?.dateUpdated??'0');
          }
          return await getAllSubmittedFromLocalByDelete();
        }
      }
      return await getAllSubmittedFromLocalByDelete();
    }catch(_){
      return [];
    }
  }

  Future<List<AllFormsData?>> getAllFormList() async {
   //try{
     final Database? db = await DatabaseProvider.dbProvider.database;

     List<AllFormsData> allFormList = await getAllFromLocal();

     ///checking data already exist or not
     if (allFormList.isEmpty) {

       ///getting data from remote
       AllFormListResponse? allFormResponse =
       await _dashboardService.getAllFormList();

       ///checking data already exist or not
       if (allFormResponse?.data != null) {
         db!.delete(TABLE_NAME_All_FORM);
         for (Data formData in allFormResponse?.data ?? []) {

           ///inserting data to local
           insertAllForms(AllFormsData(
             id: formData.id,
             xFormId: formData.attributes?.xformId,
             title: formData.attributes?.title,
             idString: formData.attributes?.idString,
             createdAt: formData.attributes?.createdAt,
             target: formData.attributes?.target,
             projectId: formData.attributes?.project?.id,
             projectName: formData.attributes?.project?.name,
             projectDes: formData.attributes?.project?.description,
           ));
         }

         ///inserting last updated datetime here
         if((allFormResponse?.data!.length??0)>0){
           await SharedPref.sharedPref.setString(SharedPref.SUBMITTED_FORM_DATE_TIME, allFormResponse?.data?[0].attributes?.updatedAt??'0');
         }
         return await getAllFromLocal();
       }
     }
     return allFormList;
   /*}catch(_){
     return [];
   }*/
  }

  ///////////local data/////////

  ///insert project data to local
  void insertProject(ProjectListFromLocalDb projectListFromLocalDb) async {
    final Database? db = await DatabaseProvider.dbProvider.database;
    await db!.insert(TABLE_NAME_PROJECT, projectListFromLocalDb.toJson());
  }

  ///getting all project from local
  Future<List<ProjectListFromLocalDb>> getAllProjectFromLocal() async {
    final Database? db = await DatabaseProvider.dbProvider.database;
    var data = await db!.rawQuery('select * from $TABLE_NAME_PROJECT');
    return List<ProjectListFromLocalDb>.from(
        data.map((x) => ProjectListFromLocalDb.fromJson(x)));
  }

  ///insert submitted form
  insertSubmittedForms(SubmittedFormListData submittedFormListResponse) async {
    final Database? db = await DatabaseProvider.dbProvider.database;
    await db!
        .insert(TABLE_NAME_SUBMITTED_FORM, submittedFormListResponse.toJson());
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
    await db!.insert(TABLE_NAME_All_FORM, allFormsData.toJson());
  }

  ///getting all form data from local
  Future<List<AllFormsData>> getAllFromLocal() async {
    final Database? db = await DatabaseProvider.dbProvider.database;
    var data = await db!.rawQuery(
        'select * from $TABLE_NAME_All_FORM ORDER BY $All_FORM_CREATED_AT DESC');
    return List<AllFormsData>.from(data.map((x) => AllFormsData.fromJson(x)));
  }
}
