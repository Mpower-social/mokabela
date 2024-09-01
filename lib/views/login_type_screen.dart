import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:m_survey/res/color.dart';
import 'package:m_survey/res/screen_size.dart';
import 'package:m_survey/utils/odk_util.dart';
import 'package:m_survey/views/login_screen.dart';
import 'package:m_survey/widgets/common_button.dart';

import '../widgets/single_image_view.dart';

class LoginTypeScreen extends StatelessWidget {
  Function? hp;
  Function? wp;

  @override
  Widget build(BuildContext context) {
    hp = Screen(MediaQuery.of(context).size).hp;
    wp = Screen(MediaQuery.of(context).size).wp;
    return Scaffold(
      body: SafeArea(
        child: Container(
            height: hp!(100) - kToolbarHeight,
            width: wp!(100),
            margin: const EdgeInsets.only(left: 40, right: 40),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/msurvey_app_banner.png',
                        width: wp!(60),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      commonButton(
                        text: 'Login_for_NGO'.tr,
                        bg: primaryColor,
                        textColor: white,
                        radius: 25,
                        tap: () => Get.to(() => LoginScreen()),
                        width: wp!(100),
                        height: 50,
                      ),
                      const SizedBox(height: 20),
                      commonButton(
                        text: 'Entry_For_All'.tr,
                        bg: Color(0xFF1CABE2),
                        textColor: white,
                        radius: 25,
                        tap: () => OdkUtil.instance.navigateToAwaztulo(),
                        width: wp!(100),
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
