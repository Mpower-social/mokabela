import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m_survey/app_icons_icons.dart';
import 'package:m_survey/controllers/form_details_controller.dart';
import 'package:m_survey/enum/form_status.dart';
import 'package:m_survey/models/local/all_form_list_data.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/res/color.dart';
import 'package:m_survey/res/screen_size.dart';
import 'package:m_survey/widgets/app_bar_with_drawer.dart';
import 'package:m_survey/widgets/icon_button.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:get/get.dart';

class FormDetailsScreen extends StatelessWidget {
  Function? wp;
  Function? hp;
  ProjectListFromLocalDb? projectListFromData;
  AllFormsData? allFormsData;
  String? formId;
  FormDetailsController controller = Get.find();

  FormDetailsScreen({
    this.projectListFromData,
    this.allFormsData,
    this.formId = '',
  }) {
    formId = this.formId!.isEmpty ? allFormsData?.idString ?? '' : this.formId;
    controller.getTotalSubmittedForm(formId,allFormsData);
    controller.getDraftFormCount(formId);
    controller.getCompleteFormCount(formId);
    controller.getRevertedFormCount(formId);
  }
  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    hp = Screen(MediaQuery.of(context).size).hp;

    return Container(
      color: statusBarColor,
      child: SafeArea(
        child: Scaffold(
          appBar: baseAppBarWithDrawer(
            context: context,
            title: '${projectListFromData?.projectName ?? ''}',
          ),
          body: Container(
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
                  Obx(
                    () => iconButton(
                        icon: AppIcons.draft,
                        title: '${'draft'.tr} (${controller.draftFormCount})',
                        bg: primaryColor,
                        textColor: white,
                        height: 45,
                        width: wp!(85),
                        onTap: () => controller.navigateToFormList(FormStatus.draft, allFormsData,formId)),
                  ),
                  // SizedBox(
                  //   height: hp!(1),
                  // ),
                  // Obx(() => iconButton(
                  //     icon: CupertinoIcons.arrow_left_square_fill,
                  //     title: '${'Reverted'.tr} (${controller.revertedFormCount})',
                  //     bg: primaryColor,
                  //     textColor: white,
                  //     height: 45,
                  //     width: wp!(85),
                  //     onTap: () => controller.navigateToFormList(FormStatus.reverted, allFormsData,formId))),
                  SizedBox(
                    height: hp!(1),
                  ),
                  Obx(() => iconButton(
                      icon: CupertinoIcons.checkmark_square_fill,
                      title: '${'ready_to_sync'.tr} (${controller.completeFormCount})',
                      bg: primaryColor,
                      textColor: white,
                      height: 45,
                      width: wp!(85),
                      onTap: () =>controller.navigateToFormList(FormStatus.readyToSync, allFormsData,formId))),
                  SizedBox(
                    height: hp!(1),
                  ),
                  Obx(() => iconButton(
                        icon: Icons.remove_red_eye,
                        title: '${'submitted'.tr} (${controller.submittedFormList.length})',
                        bg: primaryColor,
                        textColor: white,
                        height: 45,
                        width: wp!(85),
                        onTap: () => controller.navigateToFormList(FormStatus.submitted, allFormsData,formId)
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _topPart() {

    return Obx(()=>Container(
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
                  TextSpan(text: 'Project: '.tr),
                  TextSpan(
                      text: '${projectListFromData?.projectName ?? ''}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
              ),
              SizedBox(height: hp!(5)),
              Text(
                '${'Total'.tr}(${allFormsData?.target ?? '0'})',
                style: TextStyle(color: white),
              ),
              SizedBox(height: hp!(1.5)),
              LinearPercentIndicator(
                padding: EdgeInsets.all(0),
                backgroundColor: white,
                lineHeight: 8.0,
                percent: controller.progress.value.isInfinite
                    ? 0
                    : controller.progress.value.isNaN
                        ? 0
                        : (controller.progress.value > 1?1:controller.progress.value),
                progressColor: green,
              ),
              SizedBox(height: hp!(1.5)),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '${controller.submittedFormList.length}',
                      style: TextStyle(color: white),
                    ),
                    Text(
                        '${((allFormsData?.target ?? 0) - controller.submittedFormList.length)}',
                        style: TextStyle(color: white))
                  ],
                ),
              ),
            ],
          )),
    );
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
                 // print('${projectListFromData?.id}, $formId,  $allFormsData  ${allFormsData?.status}');
                 // if((allFormsData?.status??'false') == 'true') {
                   /* if((allFormsData?.target??0)<=0){
                      showToast(msg: 'Target is empty.',isError: true);
                    }
                     else*/ /*controller.openOdkForm(projectListFromData?.id,formId,allFormsData);*/
                 // }else showToast(msg: 'Unable to open inactive form.',isError: true);
                  controller.openOdkForm(projectListFromData?.id,formId,allFormsData);
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
                      'Collect'.tr,
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
