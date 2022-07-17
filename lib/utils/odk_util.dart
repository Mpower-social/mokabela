import 'dart:ffi';
import 'package:flutter/services.dart';

class OdkUtil {
  OdkUtil._internal();
  static final OdkUtil _instance = OdkUtil._internal();
  static OdkUtil get instance => _instance;

  var methodChannel = MethodChannel('flutter_to_odk_communication');

  Future<dynamic> initializeOdk(String xmlData) async {
    return await methodChannel
        .invokeMethod('initializeOdk', {'xmlData': xmlData});
  }

  Future<dynamic> openForm(String formId, {Map arguments = const {}}) async {
    return await methodChannel
        .invokeMethod('openForm', {'formId': formId, 'arguments': arguments});
  }

  Future<dynamic> editForm(Long instanceId) async {
    return await methodChannel
        .invokeMethod('editForm', {'instanceId': instanceId});
  }

  Future<dynamic> getDraftForms(List<String> formIds) async {
    return await methodChannel.invokeMethod('draftForms', {'formIds': formIds});
  }

  Future<dynamic> getFinalizedForms(List<String> formIds) async {
    return await methodChannel
        .invokeMethod('finalizedForms', {'formIds': formIds});
  }

  Future<dynamic> sendBackToDraft(Long instanceId) async {
    return await methodChannel
        .invokeMethod('sendBackToDraft', {'instanceId': instanceId});
  }

  Future<dynamic> deleteDraftForm(Long instanceId) async {
    return await methodChannel
        .invokeMethod('deleteDraft', {'instanceId': instanceId});
  }
}