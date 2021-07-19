import 'dart:convert';
import 'package:app_builder/database/database_helper.dart';
import 'package:app_builder/service/remote_service.dart';
import 'package:app_builder/user/model/user.dart';
import 'package:app_builder/utils/preference_util.dart';
import 'package:app_builder/views/dashboard_page.dart';
import 'package:app_builder/views/login_page.dart';
import 'package:app_builder/views/side_bar_layout.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    moveToNextScreen();
  }

  void moveToNextScreen() async {
    await Future.wait([
      downloadAndSaveCatchment(),
      Future.delayed(Duration(seconds: 5)),
    ]);

    var isLoggedIn = await PreferenceUtil.getValue(PreferenceUtil.KEY_LOGGED_IN,
        defaultValue: false);

    if (isLoggedIn != null && isLoggedIn) {
      var userResponse = await PreferenceUtil.getValue(PreferenceUtil.KEY_USER);
      var user = User.fromJson(json.decode(userResponse));
      Get.offAll(() => SideBarLayout(
            user: user,
          ));
    } else {
      Get.offAll(() => LoginPage());
    }
  }

  Future<void> downloadAndSaveCatchment() async {
    var tempDir = await getApplicationDocumentsDirectory();
    var catchmentFile = await RemoteService().downloadCatchmentFile(tempDir);
    if (catchmentFile != null) {
      var db = await DatabaseHelper.instance.database;
      await db.rawDelete('DELETE FROM $TABLE_NAME_CATCHMENT');

      var lines = catchmentFile.readAsLinesSync();
      var columns = lines.removeAt(0);
      lines.forEach((values) async {
        var arguments = [];
        values.split(',').forEach((element) {
          arguments.add("\'${element.replaceAll("'", "''")}\'");
        });

        try {
          await db.rawInsert(
              'INSERT INTO $TABLE_NAME_CATCHMENT ($columns) VALUES (${arguments.join(',')})');
        } catch (e) {
          print(e);
        }
      });
    }
  }
}
