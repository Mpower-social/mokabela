import 'package:app_builder/module/model/dto/module.dart';
import 'package:app_builder/module/model/provider/moduel_provider.dart';

class ModuleRepository {
  final _moduleProvider = ModuleProvider();

  Future<Module> getModules() => _moduleProvider.getModules();
}
