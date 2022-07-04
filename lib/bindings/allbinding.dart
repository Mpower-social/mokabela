import 'package:get/get.dart';
import 'package:m_survey/controllers/dashboard_controller.dart';
import 'package:m_survey/controllers/form_details_controller.dart';
class AllBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController(),fenix: true);
    Get.lazyPut(() => FormDetailsController(),fenix: true);
  }

}
