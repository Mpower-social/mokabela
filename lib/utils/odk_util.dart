import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:m_survey/models/form_data.dart';

class OdkUtil {
  OdkUtil._internal();
  static final OdkUtil _instance = OdkUtil._internal();
  static OdkUtil get instance => _instance;

  var methodChannel = MethodChannel('flutter_to_odk_communication');

  Future<dynamic> navigateToAwaztulo() async {
    return await methodChannel.invokeMethod('navigateToAwaztulun');
  }

  Future<dynamic> goToSettings() async {
    return await methodChannel.invokeMethod('goToSettings');
  }

  Future<dynamic> initializeOdk(String username) async {
    return await methodChannel
        .invokeMethod('initializeOdk', {'username': username});
  }

  Future<dynamic> configureOdkForms(String xmlData) async {
    return await methodChannel
        .invokeMethod('configureOdkForms', {'xmlData': xmlData});
  }

  Future<dynamic> openForm(String formId, {Map arguments = const {}}) async {
    return await methodChannel
        .invokeMethod('openForm', {'formId': formId, 'arguments': arguments});
  }

  Future<dynamic> editForm(int instanceId) async {
    return await methodChannel
        .invokeMethod('editForm', {'instanceId': instanceId});
  }

  Future<dynamic> correctForm(FormData? formData) async {
    return await methodChannel
        .invokeMethod('correctForm', {'data': jsonEncode(formData)});
  }

  Future<dynamic> getDraftForms(List<String> formIds) async {
    return await methodChannel.invokeMethod('draftForms', {'formIds': formIds});
  }

  Future<dynamic> getFinalizedForms(List<String> formIds) async {
    return await methodChannel
        .invokeMethod('finalizedForms', {'formIds': formIds});
  }

  Future<dynamic> sendBackToDraft(int instanceId) async {
    return await methodChannel
        .invokeMethod('sendBackToDraft', {'instanceId': instanceId});
  }

  Future<dynamic> sendToSubmitted(int instanceId) async {
    return await methodChannel
        .invokeMethod('sendToSubmitted', {'instanceId': instanceId});
  }

  Future<dynamic> deleteDraftForm(int instanceId) async {
    return await methodChannel
        .invokeMethod('deleteDraft', {'instanceId': instanceId});
  }

  Future<dynamic> getRecentForms() async {
    return await methodChannel.invokeMethod('recentForms');
  }
}
