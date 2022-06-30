import 'package:flutter/material.dart';
import 'package:m_survey/app_icons_icons.dart';
import 'package:m_survey/controllers/dashboard_controller.dart';
import 'package:m_survey/res/color.dart';
import 'package:m_survey/res/screen_size.dart';
import 'package:m_survey/style/common_style.dart';
import 'package:m_survey/views/active_form_screen.dart';
import 'package:m_survey/views/draft_form_screen.dart';
import 'package:m_survey/views/form_details_screen.dart';
import 'package:m_survey/views/ready_to_sync_form_screen.dart';
import 'package:m_survey/views/submitted_form_screen.dart';
import 'package:m_survey/views/widgets/form_card.dart';
import 'package:m_survey/views/widgets/statistics_card.dart';
import 'package:m_survey/widgets/app_bar_with_drawer.dart';
import 'package:m_survey/widgets/field_tittle.dart';
import 'package:get/get.dart';


class ProjectDetailsScreen extends StatelessWidget {
  Function? wp;
  Function? hp;
  final DashboardController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery
        .of(context)
        .size).wp;
    hp = Screen(MediaQuery
        .of(context)
        .size).hp;
    return SafeArea(
      child: Scaffold(
        appBar: baseAppBarWithDrawer(
          title: 'BRAC-Edu',onLeadingTap: ()=>Get.back()
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ///top statistics
            Row(
              children: [
                InkWell(
                  onTap: ()=>Get.to(()=>ActiveFormScreen()),
                  child: statisticsCard(
                      title: 'Active Forms',
                      data: '09/13',
                      icon: AppIcons.active,
                      position: 1,wp: wp!(50)),
                ),

                InkWell(
                  onTap: ()=>Get.to(()=>DraftFormScreen()),
                  child: statisticsCard(
                      title: 'Draft',
                      data: '470',
                      icon: AppIcons.draft,
                      position: 2,wp: wp!(50)),
                ),
              ],
            ),
            Row(
              children: [
                InkWell(
                  onTap: ()=>Get.to(()=>SubmittedFormScreen()),
                  child: statisticsCard(
                      title: 'Submitted',
                      data: '1817',
                      icon: AppIcons.submitted,
                      position: 3,wp: wp!(50)),
                ),
                InkWell(
                  onTap: ()=>Get.to(()=>ReadyToSyncFormScreen()),
                  child: statisticsCard(
                      title: 'Ready to Sync',
                      data: '02',
                      icon: AppIcons.ready_sync,
                      position: 4,wp: wp!(50)),
                )
              ],
            ),


            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 20,right: 20,top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///search and title
                    _search(),
                    const SizedBox(height: 10,),
                    ///recent forms
                    Expanded(
                      child:  _formList(),
                    ),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _formList() {
    return ListView.builder(
      itemCount: _controller.recentFormList.length,
      itemBuilder: (ctx,i){
        return InkWell(
          onTap: ()=>Get.to(()=>FormDetailsScreen()),
          child: formCard(
            title: 'Student Registration 2020',
            date: '21-07-2022',
            totalSubmission: 750,
            totalForm: 1000,
            submittedForm: 300
          ),
        );
      },
    );
  }

  Widget _search() {
    return  Row(
      mainAxisAlignment:MainAxisAlignment.spaceBetween,
      children: [
        title(title: 'All Forms',wp: wp!(40)),
        SizedBox(
          height: 35,
          width: wp!(40),
          child: TextFormField(
            autofocus: false,
            style: const TextStyle(color: Colors.black),
            decoration: CommonStyle.textFieldStyle(
                verPadding:10,
                horPadding: 12,
                fillColor: primaryColor,
                borderColor: grey,
                hintTextStr: 'Search'
            ),
          ),
        ),
        const SizedBox(width: 5,),
        Container(
          height: 35,
          width: 35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: primaryColor
          ),
          child: Icon(Icons.search,color: white,),
        )
      ],);
  }
}
