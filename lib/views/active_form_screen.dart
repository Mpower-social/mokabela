import 'package:flutter/material.dart';
import 'package:m_survey/app_icons_icons.dart';
import 'package:m_survey/controllers/active_form_controller.dart';
import 'package:m_survey/models/local/all_form_list_data.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/res/color.dart';
import 'package:m_survey/res/screen_size.dart';
import 'package:m_survey/style/common_style.dart';
import 'package:m_survey/views/widgets/form_card.dart';
import 'package:m_survey/widgets/app_bar.dart';
import 'package:get/get.dart';
import 'package:m_survey/widgets/no_data_found_msg.dart';
import 'package:m_survey/widgets/progress_bar.dart';

class ActiveFormScreen extends StatelessWidget {
  Function? wp;
  Function? hp;
  var showActiveFormsOnly;
  ActiveFormController controller = Get.find();
  final ProjectListFromLocalDb? project;

  ActiveFormScreen({this.project, this.showActiveFormsOnly = true}) {
    controller.showActiveFormsOnly = showActiveFormsOnly;
    controller.currentProject = project;
    controller.getData();
  }

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    hp = Screen(MediaQuery.of(context).size).hp;

    return Container(
      color: statusBarColor,
      child: SafeArea(
        child: Scaffold(
            appBar: baseAppBar(
                title: showActiveFormsOnly ? 'Active Forms' : 'All Forms'),
            body: Container(
              height: hp!(100),
              width: wp!(100),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  _filter(),
                  const SizedBox(height: 15),
                  Expanded(child: _formList())
                ],
              ),
            )),
      ),
    );
  }

  Widget _filter() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 7,
            child: SizedBox(
              height: 40,
              child: Obx(
                () => DropdownButtonFormField<ProjectListFromLocalDb>(
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
                        .map((e) => DropdownMenuItem<ProjectListFromLocalDb>(
                              value: e,
                              child: Text(e.projectName!),
                            ))
                        .toList(),
                    decoration: CommonStyle.dropDownFieldStyle(
                      verPadding: 8,
                      horPadding: 10,
                    ),
                    onChanged: (v) {
                      controller.filter(v?.id ?? 0);
                    }),
              ),
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
      () => controller.isLoadingForms.value
          ? progressBar()
          : controller.allFormList.length == 0
              ? noDataFound()
              : ListView.builder(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  itemCount: controller.allFormList.length,
                  itemBuilder: (ctx, i) {
                    AllFormsData data = controller.allFormList[i]!;
                    return InkWell(
                      onTap: () => controller.navigateToFormDetailsScreen(
                        ProjectListFromLocalDb(
                          id: data.projectId,
                          projectName: data.projectName
                        ),
                        data,
                      ),
                      child: formCard(data: data),
                    );
                  },
                ),
    );
  }
}
