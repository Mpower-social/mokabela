import 'package:m_survey/constans/table_column.dart';
import 'package:m_survey/database/database_provider.dart';
import 'package:m_survey/models/local/all_form_list_data.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/models/local/submitted_form_list_data.dart';
import 'package:m_survey/models/response/all_form_list_response.dart';
import 'package:m_survey/models/response/project_list_response.dart';
import 'package:m_survey/models/response/submitted_form_list_response.dart';
import 'package:m_survey/services/dashboard_service.dart';
import 'package:sqflite/sqflite.dart';

class DashboardRepository {
  final DashboardService _dashboardService = DashboardService();

  ////////remote data////////
  Future<List<ProjectListFromLocalDb>> getProjectListOperation(currentPage, pageSize,forceLoad) async {
    final Database? db = await DatabaseProvider.dbProvider.database;
    List<ProjectListFromLocalDb> projectList =  await getAllProjectFromLocal();

    if (projectList.isEmpty || forceLoad) {
      ProjectListResponse? projectListResponse = await _dashboardService.getProjectListOperation(currentPage, pageSize);

      if (projectListResponse != null) {
        if(projectListResponse.data!.isNotEmpty){
          db!.delete(TABLE_NAME_PROJECT);
          for(var projectData in projectListResponse.data!){
            insertProject( ProjectListFromLocalDb(
                id: int.tryParse(projectData.id!),
                projectName: projectData.attributes?.name,
                startDate: projectData.attributes?.startDate.toString(),
                endDate: projectData.attributes?.endDate.toString(),
                status: projectData.attributes?.projectStatus?.id.toString()
            ));
          }
        }
        return  await getAllProjectFromLocal();
      }
    }
    return projectList;
  }

  Future<String> getFormList() async{
    return await _dashboardService.getFormList()??'';
  }

  Future<List<SubmittedFormListData?>> getSubmittedFormList() async{
    final Database? db = await DatabaseProvider.dbProvider.database;

    List<SubmittedFormListData> submittedFormList =  await getAllSubmittedFromLocal();

    if(submittedFormList.isEmpty){
      List<SubmittedFormListResponse?>? submittedFormListResponse = await _dashboardService.getSubmittedFormList();
      if (submittedFormList != null) {
          db!.delete(TABLE_NAME_SUBMITTED_FORM);
          for(var formData in submittedFormListResponse!){

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
                xml: formData?.xml
            ));
          }
        return  await getAllSubmittedFromLocalByDelete();
      }
    }
    return await getAllSubmittedFromLocalByDelete();
  }

  Future<List<AllFormsData?>> getAllFormList() async{
    final Database? db = await DatabaseProvider.dbProvider.database;

    List<AllFormsData> allFormList =  await getAllFromLocal();
    if(allFormList.isEmpty){
      AllFormListResponse? allFormResponse = await _dashboardService.getAllFormList();

      if (allFormResponse?.data != null) {
          db!.delete(TABLE_NAME_All_FORM);
          for(Data formData in allFormResponse?.data??[]){
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
        return  await getAllFromLocal();
      }
    }
    return allFormList;
  }


  ///////////local data/////////
  void insertProject(ProjectListFromLocalDb projectListFromLocalDb)async{
    final Database? db = await DatabaseProvider.dbProvider.database;
    await db!.insert(TABLE_NAME_PROJECT, projectListFromLocalDb.toJson());
  }


  Future<List<ProjectListFromLocalDb>> getAllProjectFromLocal()async{
    final Database? db = await DatabaseProvider.dbProvider.database;
    var data = await db!.rawQuery('select * from $TABLE_NAME_PROJECT');
    return List<ProjectListFromLocalDb>.from(data.map((x) => ProjectListFromLocalDb.fromJson(x)));
  }




   insertSubmittedForms(SubmittedFormListData submittedFormListResponse)async{
    final Database? db = await DatabaseProvider.dbProvider.database;
    await db!.insert(TABLE_NAME_SUBMITTED_FORM, submittedFormListResponse.toJson());
  }


  Future<List<SubmittedFormListData>> getAllSubmittedFromLocalByDelete()async{
    final Database? db = await DatabaseProvider.dbProvider.database;
    var data = await db!.rawQuery('select s.* from $TABLE_NAME_SUBMITTED_FORM as s where s.$SUBMITTED_ID not in (select * from $TABLE_NAME_DELETED_SUBMITTED_FORM) ORDER BY s.$SUBMITTED_DATE_CREATED DESC');
    return List<SubmittedFormListData>.from(data.map((x) => SubmittedFormListData.fromJson(x)));
  }

  Future<List<SubmittedFormListData>> getAllSubmittedFromLocal()async{
    final Database? db = await DatabaseProvider.dbProvider.database;
    var data = await db!.rawQuery('select * from $TABLE_NAME_SUBMITTED_FORM ORDER BY $SUBMITTED_DATE_CREATED DESC');
    return List<SubmittedFormListData>.from(data.map((x) => SubmittedFormListData.fromJson(x)));
  }


  void insertAllForms(AllFormsData allFormsData)async{
    final Database? db = await DatabaseProvider.dbProvider.database;
    await db!.insert(TABLE_NAME_All_FORM, allFormsData.toJson());
  }


  Future<List<AllFormsData>> getAllFromLocal()async{
    final Database? db = await DatabaseProvider.dbProvider.database;
    var data = await db!.rawQuery('select * from $TABLE_NAME_All_FORM ORDER BY $All_FORM_CREATED_AT DESC');
    return List<AllFormsData>.from(data.map((x) => AllFormsData.fromJson(x)));
  }

}
