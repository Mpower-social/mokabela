import 'package:flutter/material.dart';
import 'package:m_survey/app_icons_icons.dart';
import 'package:m_survey/controllers/submitted_form_controller.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/models/local/submitted_form_list_data.dart';
import 'package:m_survey/res/color.dart';
import 'package:m_survey/res/screen_size.dart';
import 'package:m_survey/style/common_style.dart';
import 'package:m_survey/utils/utils.dart';
import 'package:m_survey/widgets/app_bar.dart';
import 'package:get/get.dart';
import 'package:m_survey/widgets/common_button.dart';
import 'package:m_survey/widgets/no_data_found_msg.dart';
import 'package:m_survey/widgets/progress_bar.dart';

class SubmittedFormScreen extends StatelessWidget {
  Function? wp;
  Function? hp;

  SubmittedFormController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    hp = Screen(MediaQuery.of(context).size).hp;

    return SafeArea(
      child: Scaffold(
        appBar: baseAppBar(title: 'App Submission Response'),
        body: Container(
          padding: const EdgeInsets.all(10),
          height: hp!(100),
          width: wp!(100),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              _filter(),
              const SizedBox(
                height: 15,
              ),
              Expanded(child: _formList()),
              Padding(
                padding: const EdgeInsets.all(5),
                child: commonButton(
                    text: 'Clear Sent Response',
                    bg: red,
                    tap: () {},
                    width: wp!(50),
                    height: 40),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _filter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 7,
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: Obx(()=>Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: controller.isCheckedAll.value,
                  onChanged: (v){
                    controller.isCheckedAll.value = !controller.isCheckedAll.value;
                    controller.addCheckBoxData(0,from: 'all');
                  },
                ),
                ),
              ),
              Flexible(
                flex: 5,
                child: SizedBox(
                  height: 40,
                  child: Obx(
                    () => DropdownButtonFormField<ProjectListFromLocalDb>(
                        isExpanded: true,
                        value: controller.selectedProject.value.id == 0
                            ? controller.projectList[0]
                            : controller.selectedProject.value,
                        items: controller.projectList
                            .map(
                                (e) => DropdownMenuItem<ProjectListFromLocalDb>(
                                      value: e,
                                      child: Text(e.projectName!),
                                    ))
                            .toList(),
                        decoration: CommonStyle.textFieldStyle(
                          verPadding: 8,
                          horPadding: 10,
                        ),
                        onChanged: (v) {
                          controller.selectedProject.value = v!;
                          controller.filter(v.id??0);
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 3,
          child: InkWell(
            onTap: (){
              controller.ascOrDesc.value = !controller.ascOrDesc.value;
              controller.sortByDate();
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
      () => controller.isLoadingForms.value
          ? progressBar()
          : controller.submittedFormList.length == 0
              ? noDataFound()
              : ListView.separated(
                  itemCount:  controller.submittedFormList.length,
                  itemBuilder: (ctx, i) {
                    SubmittedFormListData data = controller.submittedFormList[i]!;
                    return Container(
                      width: wp!(100),
                      padding: EdgeInsets.only(left: 10, right: 10),
                      constraints: const BoxConstraints(minHeight: 50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: grey.withOpacity(.1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Obx(()=>Checkbox(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: (controller.isCheckList.value[i].isChecked),
                                  onChanged: (v){
                                    controller.addCheckBoxData(i,formData:controller.submittedFormList[i]);
                                  }
                              ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data.formName??''),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.date_range,
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(Utils.dateFormat.format(DateTime.parse(data.dateCreated!))),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.access_time,
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(Utils.timeFormat.format(DateTime.parse(data.dateCreated!))),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          /*    Row(
                  children: [
                    Container(
                      width: .5,
                      height: 50,
                      decoration: BoxDecoration(
                          color: grey
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      AppIcons.edit,
                      size: 22,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      AppIcons.delete,
                      size: 22,
                    ),
                  ],
                ),*/
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
}
