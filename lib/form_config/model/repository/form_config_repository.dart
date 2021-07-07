import 'package:app_builder/form_config/model/dto/form_config.dart';
import 'package:app_builder/form_config/model/provider/form_config_provider.dart';

class FormConfigRepository {
  final _formConfigProvider = FormConfigProvider();

  Future<List<FormConfig>> getFormConfigs() =>
      _formConfigProvider.getFormConfigs();
}
