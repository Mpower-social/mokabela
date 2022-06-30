import 'package:get/get.dart';
import 'package:m_survey/controllers/dashboard_controller.dart';
class AllBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController(),fenix: true);
    /* Get.lazyPut(() => RegisterScreenController(),fenix: true);
    Get.lazyPut(() => AddFarmerController(),fenix: true);

    Get.lazyPut(() => FarmerListController(),fenix: true);
    Get.lazyPut(() => FarmerProfileController(),fenix: true);
    Get.lazyPut(() => CattleProfileController(),fenix: true);

    Get.lazyPut(() => AddCattleController(),fenix: true);
    Get.lazyPut(() => CameraPreviewController(),fenix: true);*/
  }

}
