import 'package:app_builder/module/model/dto/module_item.dart';
import 'package:app_builder/module/model/provider/moduel_provider.dart';

class ModuleRepository {
  final _moduleProvider = ModuleProvider();

  Future<ModuleItem> getModules() => _moduleProvider.getModules();
}
