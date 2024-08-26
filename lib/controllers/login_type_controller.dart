import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginTypeController extends GetxController{

  @override
  void onInit() async{
    super.onInit();
    bool isGranted = await requestManageExternalStoragePermission();
    if (!isGranted) {
      openAppSettings();
    }
  }

  Future<bool> requestManageExternalStoragePermission() async {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    } else {
      final status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    }
  }
}