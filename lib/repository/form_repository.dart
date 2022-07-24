import 'dart:convert';

import 'package:m_survey/constans/table_column.dart';
import 'package:m_survey/database/database_provider.dart';
import 'package:m_survey/models/local/submitted_form_list_data.dart';
import 'package:m_survey/models/submitted_checkbox_data.dart';
import 'package:m_survey/services/form_service.dart';
import 'package:sqflite/sqflite.dart';

class FormRepository{
  final FormService _formService = FormService();

  Future<String> submitFormOperation(projectId,formData) async {
    final Database? db = await DatabaseProvider.dbProvider.database;
    var res = await _formService.submitFormOperation(projectId,formData);

    return res??'';
  }

  deleteSubmittedForm(SubmittedFormListData element) async{
    final Database? db = await DatabaseProvider.dbProvider.database;
    var row = {
      'id':element.id
    };
    await db!.insert(TABLE_NAME_DELETED_SUBMITTED_FORM, row,conflictAlgorithm: ConflictAlgorithm.replace);
  }
}