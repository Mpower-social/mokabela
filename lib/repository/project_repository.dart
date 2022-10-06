import 'package:m_survey/constans/table_column.dart';
import 'package:m_survey/database/database_provider.dart';
import 'package:m_survey/models/local/all_form_list_data.dart';
import 'package:m_survey/models/local/submitted_form_list_data.dart';
import 'package:sqflite/sqflite.dart';

class ProjectRepository{

  Future<List<SubmittedFormListData>> getAllSubmittedFromLocalByProject(projectId)async{
    final Database? db = await DatabaseProvider.dbProvider.database;
    var data = await db!.rawQuery('select s.* from $TABLE_NAME_SUBMITTED_FORM as s where s.$SUBMITTED_ID not in (select * from $TABLE_NAME_DELETED_SUBMITTED_FORM) and s.$SUBMITTED_PROJECT_ID = $projectId ORDER BY s.$SUBMITTED_DATE_CREATED DESC');
    return List<SubmittedFormListData>.from(data.map((x) => SubmittedFormListData.fromJson(x)));
  }

  Future<List<SubmittedFormListData>> getAllSubmittedFromLocalByForm(formId)async{
    final Database? db = await DatabaseProvider.dbProvider.database;
    var data = await db!.rawQuery('select s.* from $TABLE_NAME_SUBMITTED_FORM as s where s.$SUBMITTED_ID not in (select * from $TABLE_NAME_DELETED_SUBMITTED_FORM) and s.$SUBMITTED_FORM_ID_STRING = "$formId" ORDER BY s.$SUBMITTED_DATE_CREATED DESC');
    return List<SubmittedFormListData>.from(data.map((x) => SubmittedFormListData.fromJson(x)));
  }

  Future<List<SubmittedFormListData>> getAllSubmittedFromLocal()async{
    final Database? db = await DatabaseProvider.dbProvider.database;
    var data = await db!.rawQuery('select * from $TABLE_NAME_SUBMITTED_FORM ORDER BY $SUBMITTED_DATE_CREATED DESC');
    return List<SubmittedFormListData>.from(data.map((x) => SubmittedFormListData.fromJson(x)));
  }

  Future<List<AllFormsData>> getAllFromLocalByProject(projectId)async{
    final Database? db = await DatabaseProvider.dbProvider.database;
   // var data = await db!.rawQuery('select * from $TABLE_NAME_All_FORM where $All_FORM_PROJECT_ID = $projectId ORDER BY $All_FORM_CREATED_AT DESC');
    var data = await db!.rawQuery(
        'select a.*,(select count(*) from $TABLE_NAME_SUBMITTED_FORM as s left join $TABLE_NAME_DELETED_SUBMITTED_FORM as d on s.$SUBMITTED_ID=d.$DELETED_SUBMITTED_FORM_ID '
            'where s.$SUBMITTED_FORM_ID_STRING = a.$All_FORM_ID_STRING and d.$DELETED_SUBMITTED_FORM_ID is null) as totalSubmission from $TABLE_NAME_All_FORM as a '
            'where a.$All_FORM_PROJECT_ID = $projectId '
            'ORDER BY a.$All_FORM_CREATED_AT DESC');
    return List<AllFormsData>.from(data.map((x) => AllFormsData.fromJson(x)));
  }

}