import 'package:app_builder/database/database_helper.dart';
import 'package:app_builder/form_config/model/dto/form_config.dart';
import 'package:app_builder/form_config/model/repository/form_config_repository.dart';
import 'package:app_builder/module/model/repository/moduel_repository.dart';
import 'package:app_builder/utils/custom_stream_controller.dart';

class ModuleBloc {
  final _moduleRepository = ModuleRepository();
  final _formConfigRepository = FormConfigRepository();
  var modulesStreamController = CustomStreamController();

  getModules() async {
    print('Getting modules');
    await _moduleRepository
        .getModules()
        .then((value) => modulesStreamController.setStream(value))
        .onError((error, stackTrace) {
      print('Error occurred.\n Reason - $error');
    });
  }

  getFormConfigAndGenerateTables() async {
    await _formConfigRepository.getFormConfigs().then((value) {
      for (FormConfig formConfig in value) _createTable(formConfig);
    }).onError((error, stackTrace) {
      print('Error occurred while fetching form configs.\nReason - $error');
    });
  }

  _createTable(FormConfig formConfig) async {
    DatabaseHelper.instance
        .createTable(query: formConfig.sqlScript!)
        .then((value) => print('${formConfig.id} SUCCESS'))
        .onError((error, stackTrace) {
      print('${formConfig.id} Failed to load\nReason - $error');
    });
  }

  dispose() {
    modulesStreamController.dispose();
  }
}
