import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m_survey/app_icons_icons.dart';
import 'package:m_survey/controllers/form_list_controller.dart';
import 'package:m_survey/enum/form_status.dart';
import 'package:m_survey/res/color.dart';
import 'package:m_survey/res/screen_size.dart';
import 'package:m_survey/widgets/app_bar.dart';
import 'package:get/get.dart';
import 'package:m_survey/widgets/common_button.dart';
import 'package:m_survey/widgets/dialog_info.dart';

class FormListScreen extends StatelessWidget {
  FormStatus formStatus;

  FormListScreen(this.formStatus, {Key? key}) : super(key: key);
  Function? wp;
  Function? hp;

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    hp = Screen(MediaQuery.of(context).size).hp;

    return SafeArea(
      child: Scaffold(
        appBar: baseAppBar(
            title: formStatus == FormStatus.draft
                ? 'Saved Response'
                : formStatus == FormStatus.readyToSync
                    ? 'Completed Response'
                    : 'Synced Response'),
        body: GetX<FormListController>(
          init: FormListController(),
          builder: (controller){
            return Container(
              padding: const EdgeInsets.all(10),
              height: hp!(100),
              width: wp!(100),
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'Student registration 2020',
                    style: TextStyle(fontSize: 18),
                  ),

                  const SizedBox(height: 15,),

                  _filter(controller),

                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(child: _formList(controller)),

                  formStatus == FormStatus.readyToSync?
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          commonButton(
                              text: 'Send Back to draft',
                              bg: primaryColor,
                              tap: ()=>controller.sendBackToDraft(),
                              width: wp!(40),
                              height: 40),

                          commonButton(
                              text: 'Sync',
                              bg: green,
                              tap: ()=>controller.sync(),
                              width: wp!(40),
                              height: 40),
                        ],
                      )
                  ):SizedBox()
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _filter([FormListController? controller]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Visibility(
              visible: formStatus == FormStatus.draft?false:true,
              child: Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: controller!.isCheckedAll.value,
                onChanged: (v){
                  controller.isCheckedAll.value = !controller.isCheckedAll.value;
                },
              ),
            ),
            _datePickerUi('Start',controller),
            const SizedBox(width: 5,),
            const Text('to'),
            const SizedBox(width: 5,),
            _datePickerUi('End',controller),
          ],
        ),

        Container(
          constraints: const BoxConstraints(
              minHeight: 30
          ),
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              border: Border.all(color: grey),
              borderRadius: BorderRadius.circular(5)
          ),
          child:IconButton(
            onPressed: ()=>controller.sortList(),
            icon: const Icon(AppIcons.group_15 ,size: 25,),
          ),
        )
      ],
    );
  }


  Widget _formList([FormListController? controller]) {
    return ListView.separated(
      itemCount: 10,
      itemBuilder: (ctx, i) {
        return Container(
          width: wp!(100),
          padding: EdgeInsets.only(left: formStatus == FormStatus.draft?10:1,right: 10),
          constraints: const BoxConstraints(minHeight: 50),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: grey.withOpacity(.1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Visibility(
                    visible: formStatus == FormStatus.draft?false:true,
                    child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: controller!.isCheckedAll.value,
                        onChanged: (v){
                          controller.isCheckedAll.value = !controller.isCheckedAll.value;
                        },
                    ),
                  ),

                  const Icon(
                    Icons.date_range,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  const Text('21-05-2020'),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(
                    Icons.access_time,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  const Text('09:15 am'),
                ],
              ),
              Row(
                children: [
                  Visibility(
                    visible: formStatus == FormStatus.submitted?false:true,
                    child: Container(
                      width: .5,
                      height: 50,
                      decoration: BoxDecoration(
                        color: grey
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Visibility(
                    visible: formStatus == FormStatus.draft?true:false,
                    child: const Icon(
                      AppIcons.edit,
                      size: 22,
                    ),
                  ),
                  Visibility(
                    visible: formStatus == FormStatus.draft?true:false,
                    child: const SizedBox(
                      width: 20,
                    ),
                  ),
                  Visibility(
                    visible: formStatus == FormStatus.submitted?false:true,
                    child: IconButton(
                      onPressed: (){
                        infoDialog(
                          title: 'Alert',
                          msg: 'Are you sure to delete ?',
                          confirmText: 'Yes',
                          cancelText: 'No',
                          onOkTap: (){},
                          onCancelTap: ()=>Get.back()
                        );
                      },
                      icon: const Icon(
                        AppIcons.delete,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      separatorBuilder: (ctx, i) {
        return const SizedBox(
          height: 6,
        );
      },
    );
  }

  Widget _datePickerUi(String s,FormListController? controller) {
    var date = s;
    if(s == 'Start') date = controller!.selectedStartDateStr.value;
    else date = controller!.selectedEndDateStr.value;

    return InkWell(
      onTap: (){
        controller.pickDate(s);
      },
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 30
        ),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: grey),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          children: [
            Text(date,style: TextStyle(color: black.withOpacity(.6)),),
            const SizedBox(width: 5,),
            Icon(Icons.date_range,color: grey,size: 20,)
          ],
        ),
      ),
    );
  }
}
