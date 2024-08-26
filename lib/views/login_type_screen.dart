import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_survey/res/color.dart';
import 'package:m_survey/res/screen_size.dart';
import 'package:m_survey/utils/odk_util.dart';
import 'package:m_survey/views/login_screen.dart';
import 'package:m_survey/widgets/common_button.dart';

class LoginTypeScreen extends StatelessWidget {
  Function? hp;
  Function? wp;

  @override
  Widget build(BuildContext context) {
    hp = Screen(MediaQuery.of(context).size).hp;
    wp = Screen(MediaQuery.of(context).size).wp;
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Container(
            height: hp!(100) - kToolbarHeight,
            width: wp!(100),
            margin: const EdgeInsets.only(left: 40, right: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                commonButton(
                    text: 'Login for NGO'.tr,
                    bg: Colors.white,
                    textColor: black,
                    tap: () => Get.to(() => LoginScreen()),
                    width: wp!(100),
                    height: 50),
                const SizedBox(
                  height: 20,
                ),
                commonButton(
                    text: 'Entry For All'.tr,
                    bg: Colors.white,
                    textColor: black,
                    tap: () => OdkUtil.instance.navigateToAwaztulo(),
                    width: wp!(100),
                    height: 50),
              ],
            )),
      ),
    );
  }
}
