import 'package:app_builder/module/model/repository/moduel_repository.dart';
import 'package:app_builder/utils/custom_stream_controller.dart';

class ModuleBloc {
  final _moduleRepository = ModuleRepository();
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

  dispose() {
    modulesStreamController.dispose();
  }
}
