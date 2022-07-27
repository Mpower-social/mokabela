import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m_survey/app_icons_icons.dart';
import 'package:m_survey/controllers/form_list_controller.dart';
import 'package:m_survey/enum/form_status.dart';
import 'package:m_survey/models/local/all_form_list_data.dart';
import 'package:m_survey/res/color.dart';
import 'package:m_survey/res/screen_size.dart';
import 'package:m_survey/utils/utils.dart';
import 'package:m_survey/widgets/app_bar.dart';
import 'package:get/get.dart';
import 'package:m_survey/widgets/common_button.dart';
import 'package:m_survey/widgets/dialog_info.dart';
import 'package:m_survey/widgets/no_data_found_msg.dart';
import 'package:m_survey/widgets/progress_bar.dart';

class FormListScreen extends StatelessWidget {
  FormStatus formStatus;
  AllFormsData? allFormsData;
  FormListController controller = Get.find();

  FormListScreen(this.formStatus, this.allFormsData) {
    if (formStatus == FormStatus.draft) {
      controller.getDraftFormByFormId(allFormsData?.idString??'');
    }else if(formStatus == FormStatus.readyToSync){
      controller.getCompleteFormList(allFormsData?.idString??'');
    }else if(formStatus == FormStatus.reverted){
      controller.getRevertedFormList(allFormsData?.idString??'');
    }else{
      controller.getSubmittedFormList(allFormsData?.idString??'');
    }
  }

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
                : formStatus == FormStatus.reverted?'Reverted' : 'Synced Response'),
        body: Container(
          padding: const EdgeInsets.all(10),
          height: hp!(100),
          width: wp!(100),
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
               Text(
                '${allFormsData?.title??''}',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 15,
              ),
              _filter(controller),
              const SizedBox(
                height: 15,
              ),
              Expanded(child: _formList()),
              formStatus == FormStatus.readyToSync
                  ? Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          commonButton(
                              text: 'Send Back to draft',
                              bg: primaryColor,
                              tap: () => controller.sendBackToDraft(allFormsData?.idString??''),
                              width: wp!(40),
                              height: 40),
                          commonButton(
                              text: 'Sync',
                              bg: green,
                              tap: () => controller.sync(allFormsData?.id??''),
                              width: wp!(40),
                              height: 40),
                        ],
                      ))
                  : SizedBox()
            ],
          ),
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
              visible: formStatus == FormStatus.draft ? false : true,
              child:  Obx(()=>Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: controller!.isCheckedAll.value,
                onChanged: (v){
                  controller.isCheckedAll.value = !controller.isCheckedAll.value;
                  controller.addCheckBoxData(0,from: 'all');
                },
              ),
              ),
            ),
            _datePickerUi('Start', controller),
            const SizedBox(
              width: 5,
            ),
            const Text('to'),
            const SizedBox(
              width: 5,
            ),
            _datePickerUi('End', controller),
          ],
        ),
        Flexible(
          flex: 3,
          child: InkWell(
            onTap: (){
              controller?.ascOrDesc.value = !controller.ascOrDesc.value;
              controller?.sortByDate();
            },
            child: Container(
              constraints: const BoxConstraints(
                  minHeight: 30
              ),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  border: Border.all(color: grey),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: const Icon(AppIcons.group_15 ,size: 35,),
            ),
          ),
        )
      ],
    );
  }

  Widget _formList() {
    return Obx(
      () => controller.isLoadingForm.value == true
          ? progressBar()
          : controller.isCheckList.length == 0
              ? noDataFound()
              : ListView.separated(
                  itemCount: controller.isCheckList.length,
                  itemBuilder: (ctx, i) {
                    return Container(
                      width: wp!(100),
                      padding: EdgeInsets.only(
                          left: formStatus == FormStatus.draft ? 10 : 1,
                          right: 10),
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
                                visible: formStatus == FormStatus.draft
                                    ? false
                                    : true,
                                child: formStatus == FormStatus.draft?Container():Obx(()=>Checkbox(
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      value: controller.isCheckList.value[i].isChecked,
                                      onChanged: (v){
                                        controller.addCheckBoxData(i,formData:controller.isCheckList[i].formData);
                                      }
                                  ),
                                )
                              ),
                              const Icon(
                                Icons.date_range,
                                size: 15,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(Utils.timeStampToDate(controller.isCheckList[i].formData!.lastChangeDate??0)),
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
                              Text(Utils.timeStampToTime(controller.isCheckList[i].formData!.lastChangeDate??0)),
                            ],
                          ),
                          Row(
                            children: [
                              Visibility(
                                visible: formStatus == FormStatus.submitted
                                    ? false
                                    : true,
                                child: Container(
                                  width: .5,
                                  height: 50,
                                  decoration: BoxDecoration(color: grey),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Visibility(
                                visible: formStatus == FormStatus.draft
                                    ? true
                                    : false,
                                child: IconButton(
                                  onPressed: ()=>controller.editDraftForm(controller.isCheckList[i].formData!.id??0),
                                  icon: Icon(
                                    AppIcons.edit,
                                    size: 22,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: formStatus == FormStatus.draft
                                    ? true
                                    : false,
                                child: const SizedBox(
                                  width: 20,
                                ),
                              ),
                              Visibility(
                                visible: formStatus == FormStatus.submitted
                                    ? false
                                    : true,
                                child: IconButton(
                                  onPressed: () {
                                    infoDialog(
                                        title: 'Alert',
                                        msg: 'Are you sure to delete ?',
                                        confirmText: 'Yes',
                                        cancelText: 'No',
                                        onOkTap: ()=>controller.deleteForm( controller.isCheckList[i].formData!.id!, allFormsData!.idString!),
                                        onCancelTap: ()=>Get.back()
                                    );
                                  },
                                  icon: const Icon(
                                    AppIcons.delete,
                                    size: 22,
                                  ),
                                ),
                              ),

                              Visibility(
                                visible: formStatus == FormStatus.reverted
                                    ? true
                                    : false,
                                child: IconButton(
                                  onPressed: () {
                                    infoDialog(
                                        title: 'Feedback',
                                        msg: 'Are you sure to delete ?',
                                        confirmText: 'Ok',
                                        onOkTap: ()=>Get.back(),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.message,
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
                ),
    );
  }

  Widget _datePickerUi(String s, FormListController? controller) {
    return Obx((){
      var date = s;
      if (s == 'Start')
        date = controller!.selectedStartDateStr.value;
      else
        date = controller!.selectedEndDateStr.value;

      return InkWell(
        onTap: () {
          controller.pickDate(s);
        },
        child: Container(
          constraints: const BoxConstraints(minHeight: 30),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(color: grey),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Text(
                date,
                style: TextStyle(color: black.withOpacity(.6)),
              ),
              const SizedBox(
                width: 5,
              ),
              Icon(
                Icons.date_range,
                color: grey,
                size: 20,
              )
            ],
          ),
        ),
      );
    },
    );
  }
}
