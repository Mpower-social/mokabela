import 'package:flutter/material.dart';
import 'package:m_survey/app_icons_icons.dart';
import 'package:m_survey/controllers/active_form_controller.dart';
import 'package:m_survey/models/local/project_list_data.dart';
import 'package:m_survey/res/color.dart';
import 'package:m_survey/res/screen_size.dart';
import 'package:m_survey/style/common_style.dart';
import 'package:m_survey/views/widgets/form_card.dart';
import 'package:m_survey/widgets/app_bar.dart';
import 'package:get/get.dart';

class ActiveFormScreen extends StatelessWidget {
  Function? wp;
  Function? hp;
  var from = 'active';
  ActiveFormScreen({this.from='active'});
  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    hp = Screen(MediaQuery.of(context).size).hp;

    return SafeArea(
      child: Scaffold(
        appBar: baseAppBar(
            title: from=='active'?'All Active Forms':'All Forms'
        ),

        body: GetX<ActiveFormController>(
          init: ActiveFormController(),
          builder: (controller){
            return Container(
              padding: const EdgeInsets.all(10),
              height: hp!(100),
              width: wp!(100),
              child: Column(
                children: [
                  const SizedBox(height: 15,),

                  _filter(controller),

                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(child: _formList(controller))
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _filter([ActiveFormController? controller]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 6,
          child: SizedBox(
            height: 40,
            child: DropdownButtonFormField<ProjectListFromLocalDb>(
                isExpanded: true,
                value: controller?.selectedProject.value.id == 0? controller?.projectList[0]:controller?.selectedProject.value,
                items: controller?.projectList.map((e) => DropdownMenuItem<ProjectListFromLocalDb>(value: e,child: Text(e.projectName!),)).toList(),
                decoration: CommonStyle.textFieldStyle(
                  verPadding: 8,
                  horPadding: 10,
                ),
                onChanged: (v){
                  controller?.selectedProject.value = v!;
                }),
          ),
        ),

        Flexible(
          flex: 4,
          child: Container(
            constraints: const BoxConstraints(
                minHeight: 30
            ),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                border: Border.all(color: grey),
                borderRadius: BorderRadius.circular(5)
            ),
            child:const Icon(AppIcons.group_15 ,size: 25,),
          ),
        )
      ],
    );
  }

  Widget _formList([ActiveFormController? controller]) {
    return ListView.builder(
      itemCount: controller?.formList.length,
      itemBuilder: (ctx,i){
        return InkWell(
          onTap: (){},
          child: formCard(
              title: 'Student Registration 2020',
              subTittle: 'BRAC-Edu',
              date: '21-07-2022',
              totalSubmission: 750,
              totalForm: 1000,
              submittedForm: 300
          ),
        );
      },
    );
  }
}
