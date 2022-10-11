import 'package:flutter/material.dart';
import 'package:m_survey/app_icons_icons.dart';
import 'package:m_survey/controllers/draft_form_controller.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/res/color.dart';
import 'package:m_survey/res/screen_size.dart';
import 'package:m_survey/style/common_style.dart';
import 'package:m_survey/utils/utils.dart';
import 'package:m_survey/widgets/app_bar.dart';
import 'package:get/get.dart';
import 'package:m_survey/widgets/dialog_info.dart';
import 'package:m_survey/widgets/no_data_found_msg.dart';
import 'package:m_survey/widgets/progress_bar.dart';

class DraftFormScreen extends StatelessWidget {
  Function? wp;
  Function? hp;
  final controller = DraftFormController();
  final ProjectListFromLocalDb? project;
  List<String> formIds = [];

  DraftFormScreen(List<String> formIds, {this.project}) {
    this.formIds = formIds;
    controller.currentProject = project;
    controller.getData(formIds);
  }

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    hp = Screen(MediaQuery.of(context).size).hp;

    return Container(
      color: statusBarColor,
      child: SafeArea(
        child: Scaffold(
          appBar: baseAppBar(title: 'Draft Forms'),
          body: Container(
            height: hp!(100),
            width: wp!(100),
            child: Column(
              children: [
                const SizedBox(height: 15),
                _filter(),
                const SizedBox(height: 15),
                Expanded(child: _formList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _filter() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 7,
            child: Row(
              children: [
                Flexible(
                  flex: 5,
                  child: SizedBox(
                    height: 40,
                    child: Obx(
                      () {
                        return DropdownButtonFormField<ProjectListFromLocalDb>(
                            isExpanded: true,
                            selectedItemBuilder: (_) {
                              return controller.projectList
                                  .map((ProjectListFromLocalDb item) {
                                return Text(
                                  item.projectName!,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                );
                              }).toList();
                            },
                            value: controller.selectedProject,
                            items: controller.projectList
                                .map(
                                  (e) =>
                                      DropdownMenuItem<ProjectListFromLocalDb>(
                                    value: e,
                                    child: Text(e.projectName!),
                                  ),
                                )
                                .toList(),
                            decoration: CommonStyle.dropDownFieldStyle(
                              verPadding: 8,
                              horPadding: 10,
                            ),
                            onChanged: (v) {
                              controller.filter(v?.id ?? 0);
                            });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 3,
            child: InkWell(
              onTap: () {
                controller.ascOrDesc.value = !controller.ascOrDesc.value;
                controller.sortByDate();
              },
              child: Container(
                constraints: const BoxConstraints(minHeight: 30),
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    border: Border.all(color: grey),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(
                  AppIcons.group_15,
                  size: 35,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _formList() {
    return Obx(
      () => controller.isLoadingDraftForm.value == true
          ? progressBar()
          : controller.formList.length == 0
              ? noDataFound()
              : ListView.separated(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  itemCount: controller.formList.length,
                  itemBuilder: (ctx, i) {
                    var data = controller.formList[i];

                    return Container(
                      width: wp!(100),
                      padding: const EdgeInsets.only(left: 10, right: 0),
                      constraints: const BoxConstraints(minHeight: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 233, 234, 235),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.displayName ?? '',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(
                                    Icons.date_range,
                                    size: 15,
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    Utils.timeStampToDate(
                                        data.lastChangeDate ?? 0),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.access_time,
                                    size: 15,
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    Utils.timeStampToTime(
                                        data.lastChangeDate ?? 0),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: .5,
                                height: 50,
                                decoration:
                                    BoxDecoration(color: Color(0xFFB5B5B5)),
                              ),
                              SizedBox(width: 5),
                              IconButton(
                                onPressed: () =>
                                    controller.editDraftForm(data,formIds),
                                icon: Icon(
                                  AppIcons.edit,
                                  size: 22,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  infoDialog(
                                      title: 'Alert',
                                      msg: 'Are you sure to delete?',
                                      confirmText: 'Yes',
                                      cancelText: 'No',
                                      onOkTap: () =>
                                          controller.deleteForm(data.id ?? 0,formIds),
                                      onCancelTap: () => Get.back());
                                },
                                icon: Icon(
                                  AppIcons.delete,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (ctx, i) {
                    return SizedBox(height: 6);
                  },
                ),
    );
  }
}
