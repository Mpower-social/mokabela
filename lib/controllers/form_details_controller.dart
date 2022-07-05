import 'package:flutter/services.dart';
import 'package:get/get.dart';

class FormDetailsController extends GetxController{
  var methodChannel = MethodChannel('flutter_to_odk_communication');

  void openOdkForm() async {
    final results = await methodChannel.invokeMethod<String>('openForms', {'formId':'member_register_test901'});
    if (results != null && results.isNotEmpty) {
      print("success  $results");
    }
    print('failed');
  }
}