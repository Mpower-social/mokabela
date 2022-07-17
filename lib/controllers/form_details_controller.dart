import 'package:get/get.dart';
import '../utils/odk_util.dart';

class FormDetailsController extends GetxController {
  void openOdkForm() async {
    final results = await OdkUtil.instance.openForm('member_register_test901',
        arguments: {'projectId': "123456"});
    if (results != null && results.isNotEmpty) {
      print("success  $results");
    }
    print('failed');
  }
}
