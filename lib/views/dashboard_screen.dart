import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m_survey/app_icons_icons.dart';
import 'package:m_survey/controllers/dashboard_controller.dart';
import 'package:m_survey/res/color.dart';
import 'package:m_survey/res/screen_size.dart';
import 'package:m_survey/utils/utils.dart';
import 'package:m_survey/views/active_form_screen.dart';
import 'package:m_survey/views/draft_form_screen.dart';
import 'package:m_survey/views/form_details_screen.dart';
import 'package:m_survey/views/project_details_screen.dart';
import 'package:m_survey/views/ready_to_sync_form_screen.dart';
import 'package:m_survey/views/submitted_form_screen.dart';
import 'package:m_survey/views/widgets/drawer.dart';
import 'package:m_survey/views/widgets/statistics_card.dart';
import 'package:m_survey/widgets/app_bar_with_drawer.dart';
import 'package:get/get.dart';
import 'package:m_survey/widgets/field_tittle.dart';
import 'package:m_survey/views/widgets/ongoing_project_card.dart';
import 'package:m_survey/views/widgets/recent_form_card.dart';
import 'package:m_survey/widgets/no_data_found_msg.dart';

class DashboardScreen extends StatelessWidget {
  Function? wp;
  Function? hp;

  final DashboardController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    hp = Screen(MediaQuery.of(context).size).hp;

    return SafeArea(
      child: Scaffold(
        appBar: baseAppBarWithDrawer(
          title: 'Home',
          context: context
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///top statistics
            Row(
              children: [
                InkWell(
                  onTap: () => Get.to(() => ActiveFormScreen()),
                  child: Obx(()=>statisticsCard(
                        title: 'active_form'.tr,
                        data: '09/${_controller.allFormList.length}',
                        icon: AppIcons.active,
                        position: 1,
                        wp: wp!(50)),
                  ),
                ),
                InkWell(
                  onTap: () => Get.to(() => SubmittedFormScreen()),
                  child: Obx(()=>statisticsCard(
                        title: 'submitted'.tr,
                        data:  Utils.numberFormatter.format(_controller.submittedFormList.value.length),
                        icon: AppIcons.submitted,
                        position: 2,
                        wp: wp!(50)),
                  ),
                )
              ],
            ),
            Row(
              children: [
               InkWell(
                    onTap: () => Get.to(() => DraftFormScreen()),
                    child: Obx(()=>statisticsCard(
                        title: 'draft'.tr,
                        data: Utils.numberFormatter.format(_controller.draftFormCount.value),
                        icon: AppIcons.draft,
                        position: 3,
                        wp: wp!(50)),
                ),),
                InkWell(
                  onTap: () => Get.to(() => ReadyToSyncFormScreen()),
                  child: Obx(()=>statisticsCard(
                        title: 'ready_to_sync'.tr,
                        data: Utils.numberFormatter.format(_controller.completeFormCount.value),
                        icon: AppIcons.ready_sync,
                        position: 4,
                        wp: wp!(50)),
                  ),
                )
              ],
            ),

            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Obx(()=>Visibility(
                       visible: _controller.recentFormList.length>0?true:false,
                       child:  Column(
                         children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               title(title: 'recent_forms'.tr),
                               InkWell(
                                   onTap: () => Get.to(() => ActiveFormScreen(from:'dashboard')),
                                   child: title(title: 'all'.tr)
                               )
                             ],
                           ),
                           SizedBox(
                             height: 10,
                           ),

                           ///recent forms
                           SizedBox(
                             height: 110,
                             child: _recentFormHorizontalList(),
                           ),

                           const SizedBox(
                             height: 20,
                           ),
                         ],
                       )
                     ),
                   ),

                    title(title: 'ongoing_project'.tr),

                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(child: _ongoingProjectList())
                  ],
                ),
              ),
            )
          ],
        ),
        /*    body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ///top statistics

              Wrap(
                children: [
                  statisticsCard(
                      title: 'Active Forms',
                      data: '09/13',
                      icon: Icons.account_balance_wallet,
                      position: 1,wp: 200),
                  statisticsCard(
                      title: 'Submitted',
                      data: '1817',
                      icon: Icons.account_balance_wallet,
                      position: 2,wp: 200),

                  statisticsCard(
                      title: 'Draft',
                      data: '470',
                      icon: Icons.account_balance_wallet,
                      position: 3,wp: 200),
                  statisticsCard(
                      title: 'Ready to Sync',
                      data: '02',
                      icon: Icons.account_balance_wallet,
                      position: 4,wp: 200),
                ],
              ),


          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 20,right: 20,top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [ title(title: 'Recent Forms'), title(title: 'All')],),
                  const SizedBox(height: 10,),
                  ///recent forms
                  SizedBox(
                    height: 110,
                    child:  _recentFormHorizontalList(),
                  ),

                  const SizedBox(height: 20,),
                  title(title: 'Ongoing Projects'),

                  const SizedBox(height: 10,),
                 Expanded(child:  _ongoingProjectList())
                ],
              ),
            ),
          )
          ],
        ),*/
        drawer: Obx(() => drawer(
            _controller.name.value,
            _controller.designation.value,
            wp: wp!(30))),


        floatingActionButton: FloatingActionButton.extended(
            onPressed: ()=>_controller.getAllData(true),
            backgroundColor: primaryColor,
            label: Row(children: [const Icon(AppIcons.reload),const SizedBox(width: 8,),Text('load'.tr)],)
        ),
      ),
    );
  }

  Widget _recentFormHorizontalList() {
    return Obx(()=>ListView.separated(
        itemCount: _controller.recentFormList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, i) {
          return InkWell(
            onTap: () {
              Get.to(() => FormDetailsScreen());
            },
            child: recentFormCard(
                title: _controller.recentFormList[i].displayName??'', subTitle:  _controller.recentFormList[i].projectName??''),
          );
        },
        separatorBuilder: (ctx, i) => const SizedBox(
          width: 8,
        ),
      ),
    );
  }

  _ongoingProjectList() {
    return GetX<DashboardController>(
      init: DashboardController(),
      builder: (controller) => controller.isLoadingProject.value
          ? const Center(child: CircularProgressIndicator())
          : _controller.projectList.isEmpty
              ? noDataFound()
              : ListView.separated(
                  itemCount: _controller.projectList.length,
                  itemBuilder: (ctx, i) {
                    return InkWell(
                      onTap: () => Get.to(() => ProjectDetailsScreen(_controller.projectList[i])),
                      child: ongoingProjectCard(
                          title: _controller.projectList[i].projectName ?? '',
                          formCount: int.tryParse(_controller.projectList[i].noOfForms ?? '0') ??0,
                          dateRange: '${"timeline".tr} ${Utils.dateFormat.format(DateTime.tryParse(_controller.projectList[i].startDate!)!)} - ${Utils.dateFormat.format(DateTime.tryParse(_controller.projectList[i].endDate!)!)}',
                          status: _controller.projectList[i].status == '1'?true:false),
                    );
                  },
                  separatorBuilder: (ctx, i) => const SizedBox(
                    width: 8,
                  ),
                ),
    );
  }
}
