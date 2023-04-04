import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_survey/views/dashboard_screen.dart';
import 'package:m_survey/views/login_screen.dart';
import '../res/color.dart';
import '../res/screen_size.dart';
import '../utils/shared_pref.dart';
import '../widgets/single_image_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Function wp = () {};
  Function hp = () {};
  @override
  void initState() {
    checkCredential();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    hp = Screen(MediaQuery.of(context).size).hp;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: hp(100),
          width: wp(100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              singleImageHolder('assets/images/msurvey_appicon.png',hp(50),wp(80)),
             /* Text('mSurvey',
              style: TextStyle(
                color: primaryColor,
                fontSize: 36
              ),),*/
            ],
          ),
        ),
      ),
    );
  }

  void checkCredential()async {
    await Future.delayed(const Duration(seconds: 2));
    if(await SharedPref.sharedPref.getString(SharedPref.TOKEN)!=null){
      Get.offAll(()=>DashboardScreen());
    }else{
      Get.offAll(()=> LoginScreen());
    }
  }
}
