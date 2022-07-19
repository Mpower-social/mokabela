import 'package:m_survey/database/database_provider.dart';
import 'package:m_survey/services/form_service.dart';
import 'package:sqflite/sqflite.dart';

class FormRepository{
  final FormService _formService = FormService();

  Future<String> submitFormOperation(projectId,formData) async {
    final Database? db = await DatabaseProvider.dbProvider.database;
    var res = await _formService.submitFormOperation(projectId,formData);

    return res??'';
  }
}