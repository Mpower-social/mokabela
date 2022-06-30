import 'package:m_survey/constans/table_column.dart';
import 'package:m_survey/database/database_provider.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/models/response/project_list_response.dart';
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
                status: 'false'
            ));
          }
        }
        return  await getAllProjectFromLocal();
      }
    }
    return projectList;
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


}
