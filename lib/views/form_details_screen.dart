import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m_survey/app_icons_icons.dart';
import 'package:m_survey/controllers/form_details_controller.dart';
import 'package:m_survey/enum/form_status.dart';
import 'package:m_survey/res/color.dart';
import 'package:m_survey/res/screen_size.dart';
import 'package:m_survey/views/form_list_screen.dart';
import 'package:m_survey/widgets/app_bar_with_drawer.dart';
import 'package:m_survey/widgets/icon_button.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:get/get.dart';

class FormDetailsScreen extends StatelessWidget {
  Function? wp;
  Function? hp;

  FormDetailsController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    hp = Screen(MediaQuery.of(context).size).hp;
    return SafeArea(
      child: Scaffold(
        appBar: baseAppBarWithDrawer(
          context:context,
          title: 'Student Registration 2020',
        ),
        body:Container(
            height: hp!(100),
            width: wp!(100),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: .5,
                    width: wp!(100),
                    color: white,
                  ),
                  _topPart(),
                  SizedBox(
                    height: hp!(4),
                  ),
                  _collectButton(),
                  SizedBox(
                    height: hp!(4),
                  ),
                  iconButton(
                      icon: AppIcons.draft,
                      title: 'Drafts(47)',
                      bg: primaryColor,
                      textColor: white,
                      height: 45,
                      width: wp!(85),
                      onTap: () => Get.to(() => FormListScreen(FormStatus.draft))),
                  SizedBox(
                    height: hp!(1),
                  ),
                  iconButton(
                      icon: CupertinoIcons.checkmark_square_fill,
                      title: 'Ready to Sync(101)',
                      bg: primaryColor,
                      textColor: white,
                      height: 45,
                      width: wp!(85),
                      onTap: () => Get.to(() => FormListScreen(FormStatus.readyToSync))),
                  SizedBox(
                    height: hp!(1),
                  ),
                  iconButton(
                    icon: Icons.remove_red_eye,
                    title: 'Submitted(512)',
                    bg: primaryColor,
                    textColor: white,
                    height: 45,
                    width: wp!(85),
                    onTap: () => Get.to(() => FormListScreen(FormStatus.submitted)),
                  )
                ],
              ),
            ),
          ),

      ),
    );
  }

  Widget _topPart() {
    return Container(
        padding: EdgeInsets.all(20),
        constraints: BoxConstraints(minHeight: hp!(25)),
        width: wp!(100),
        color: primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(children: [
                TextSpan(text: 'Project: '),
                TextSpan(
                    text: 'BRAC-Edu:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ]),
            ),
            SizedBox(height: hp!(5)),
            Text(
              'Total(700)',
              style: TextStyle(color: white),
            ),
            SizedBox(height: hp!(1.5)),
            LinearPercentIndicator(
              padding: EdgeInsets.all(0),
              backgroundColor: white,
              lineHeight: 8.0,
              percent: 0.9,
              progressColor: green,
            ),
            SizedBox(height: hp!(1.5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '170',
                  style: TextStyle(color: white),
                ),
                Text('530', style: TextStyle(color: white))
              ],
            )
          ],
        ));
  }

  Widget _collectButton() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(200),
      ),
      color: Colors.white.withOpacity(.5),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ClipOval(
          child: Container(
            height: 120,
            width: 120,
            child: Material(
              color: Colors.green,
              child: InkWell(
                onTap: () {
                  controller.openOdkForm();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle,
                      color: Colors.white,
                      size: 30,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Collect',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
