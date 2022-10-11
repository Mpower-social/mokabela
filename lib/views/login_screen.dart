import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m_survey/controllers/login_controller.dart';
import 'package:m_survey/res/color.dart';
import 'package:m_survey/res/screen_size.dart';
import 'package:m_survey/style/common_style.dart';
import 'package:m_survey/utils/utils.dart';
import 'package:m_survey/widgets/common_button.dart';
import 'package:m_survey/widgets/field_tittle.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  Function? hp;
  Function? wp;
  @override
  Widget build(BuildContext context) {
    hp = Screen(MediaQuery.of(context).size).hp;
    wp = Screen(MediaQuery.of(context).size).wp;
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: SingleChildScrollView(
          child: Container(
            height: hp!(100)-kToolbarHeight,
            width: wp!(100),
            margin: const EdgeInsets.only(left: 40,right: 40),
            child: GetX<LoginController>(
              init: LoginController(),
              builder: (controller){
                return Form(
                  key: controller.loginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      ///tittle
                      Text('mSurvey',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 45,color: white
                        ),),
                      const SizedBox(height: 5,),
                      ///subtittle
                      Text('login_top_title'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,color: white
                        ),),
                      const SizedBox(height: 40,),


                      ///input fields
                      Align(
                          alignment: Alignment.centerLeft,
                          child: title(title: '${'email'.tr}*',color: white)
                      ),
                      const SizedBox(height: 8,),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextFormField(
                          autofocus: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: const TextStyle(color: Colors.white),
                          controller: controller.emailController,
                          decoration: CommonStyle.textFieldStyle(
                              verPadding:15,
                              horPadding: 10,
                              fillColor: primaryColor,
                              borderColor: grey,
                              hintTextStr: '${'enter'.tr} ${'email'.tr}'
                          ),

                          validator: (v){
                            return Utils.validateEmail(v!);
                          },
                        ),
                      ),

                      const SizedBox(height: 20,),

                      Align(
                          alignment: Alignment.centerLeft,
                          child: title(title: '${'password'.tr}*',color: white)
                      ),
                      const SizedBox(height: 8,),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextFormField(
                          autofocus: false,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          controller: controller.passController,
                          decoration: CommonStyle.textFieldStyle(
                              verPadding:15,
                              horPadding: 10,
                              fillColor: primaryColor,
                              borderColor: grey,
                              hintTextStr: '${'enter'.tr} ${'password'.tr}'
                          ),

                          validator: (v){
                            if(v!.isEmpty) return '${'password'.tr} ${'must'.tr}';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 30,),

                      ///login button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: commonButton(
                            text: 'login'.tr,
                            bg: green,
                            textColor: black,
                            tap: (){
                              //Get.to(()=>DashboardScreen());
                              if(controller.loginFormKey.currentState!.validate()){
                                controller.loginOperation();
                              }
                            },
                            width: wp!(100),
                            height: 50,isLoading: controller.isLoading.value
                        ),
                      ),
                      const SizedBox(height: 30,),
                      Text('login_bottom_title'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,color: white
                        ),),

                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
