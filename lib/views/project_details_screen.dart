import 'package:flutter/material.dart';
import 'package:m_survey/app_icons_icons.dart';
import 'package:m_survey/controllers/project_details_controller.dart';
import 'package:m_survey/models/local/all_form_list_data.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/res/color.dart';
import 'package:m_survey/res/screen_size.dart';
import 'package:m_survey/style/common_style.dart';
import 'package:m_survey/utils/utils.dart';
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
import 'package:m_survey/widgets/no_data_found_msg.dart';
import 'package:m_survey/widgets/progress_bar.dart';

class ProjectDetailsScreen extends StatelessWidget {
  Function? wp;
  Function? hp;

  ProjectDetailsController _controller = Get.find();
  ProjectListFromLocalDb _projectListFromData;
  ProjectDetailsScreen(this._projectListFromData) {
    _controller.getAllDataByProject(_projectListFromData.id);
  }

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    hp = Screen(MediaQuery.of(context).size).hp;
    return SafeArea(
      child: Scaffold(
        appBar: baseAppBarWithDrawer(
            title: '${_projectListFromData.projectName}',
            onLeadingTap: () => Get.back()),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///top statistics
            Row(
              children: [
                InkWell(
                  onTap: () => Get.to(() => ActiveFormScreen()),
                  child: Obx(
                    () => statisticsCard(
                        title: 'Active Forms',
                        data:
                            '${Utils.numberFormatter.format(_controller.allFormList.length)}',
                        icon: AppIcons.active,
                        position: 1,
                        wp: wp!(50)),
                  ),
                ),
                InkWell(
                  onTap: () => Get.to(
                    () => DraftFormScreen(
                      project: _projectListFromData,
                    ),
                  ),
                  child: Obx(
                    () => statisticsCard(
                        title: 'Draft',
                        data:
                            '${Utils.numberFormatter.format(_controller.draftFormCount.value)}',
                        icon: AppIcons.draft,
                        position: 2,
                        wp: wp!(50)),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                InkWell(
                  onTap: () => Get.to(
                    () => SubmittedFormScreen(
                      project: _projectListFromData,
                    ),
                  ),
                  child: Obx(
                    () => statisticsCard(
                        title: 'Submitted',
                        data:
                            '${Utils.numberFormatter.format(_controller.submittedFormList.length)}',
                        icon: AppIcons.submitted,
                        position: 3,
                        wp: wp!(50)),
                  ),
                ),
                InkWell(
                  onTap: () => Get.to(
                    () => ReadyToSyncFormScreen(
                      project: _projectListFromData,
                    ),
                  ),
                  child: Obx(
                    () => statisticsCard(
                        title: 'Ready to Sync',
                        data:
                            '${Utils.numberFormatter.format(_controller.completeFormCount.value)}',
                        icon: AppIcons.ready_sync,
                        position: 4,
                        wp: wp!(50)),
                  ),
                )
              ],
            ),

            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///search and title
                    _search(),
                    const SizedBox(
                      height: 10,
                    ),

                    ///recent forms
                    Expanded(
                      child: _formList(),
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
    return Obx(
      () => _controller.isLoadingProject.value
          ? progressBar()
          : _controller.allFormList.length == 0
              ? noDataFound()
              : ListView.builder(
                  itemCount: _controller.allFormList.length,
                  itemBuilder: (ctx, i) {
                    AllFormsData data = _controller.allFormList[i]!;
                    return formCard(
                      title: data.title ?? '',
                      subTittle: data.projectName ?? '',
                      date: Utils.dateFormat
                          .format(DateTime.parse(data.createdAt!)),
                      totalSubmission: data.totalSubmission ?? 0,
                      totalForm: data.target ?? 0,
                      submittedForm: data.totalSubmission ?? 0,
                      onTap: () => Get.to(
                        () => FormDetailsScreen(
                          projectListFromData: _projectListFromData,
                          allFormsData: data,
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _search() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: title(title: 'All Forms'),
        ),
        Expanded(
          flex: 6,
          child: SizedBox(
            height: 35,
            child: TextFormField(
              autofocus: false,
              controller: _controller.searchEditingController,
              style: const TextStyle(color: Colors.black),
              decoration: CommonStyle.textFieldStyle(
                  horPadding: 12,
                  fillColor: primaryColor,
                  borderColor: grey,
                  hintTextStr: 'Search'),
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          height: 35,
          width: 35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: primaryColor),
          child: IconButton(
            onPressed: () {
              _controller.searchOperation();
            },
            icon: Icon(
              Icons.search,
              color: white,
            ),
          ),
        )
      ],
    );
  }
}
