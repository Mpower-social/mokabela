import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:m_survey/repository/auth_repository.dart';
import 'package:m_survey/views/dashboard_screen.dart';
class LoginController extends GetxController{
  var isLoading = false.obs;
  GlobalKey<FormState> loginFormKey =  GlobalKey<FormState>();
  final AuthRepository _authRepository = AuthRepository();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  void loginOperation()async{
    isLoading.value = true;
    bool res = await _authRepository.loginOperation(emailController.text.toString().trim(), passController.text.toString().trim());
    if(res){
      Get.to(()=>DashboardScreen());
    }
    isLoading.value = false;
  }
}