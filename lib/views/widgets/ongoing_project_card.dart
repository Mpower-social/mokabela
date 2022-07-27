import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/local/project_list_data.dart';
import '../../res/color.dart';
import '../../utils/utils.dart';
import '../project_details_screen.dart';

Widget ongoingProjectCard(ProjectListFromLocalDb project) {
  return Card(
    color: Color(0xFFF2F3F4),
    elevation: 2,
    shadowColor: grey,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: InkWell(
      onTap: () => Get.to(() => ProjectDetailsScreen(project)),
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 80,
        constraints: const BoxConstraints(minHeight: 80),
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    project.projectName ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: project.status == '1'
                          ? Color(0xFF65905D)
                          : Color(0xFFFA4A3B)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: primaryColor),
                      child: Text(
                        (project.totalForms??0).toString(),
                        style: TextStyle(color: white),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text('Forms')
                  ],
                ),
                Flexible(
                  child: Text(
                      '${"timeline".tr} ${Utils.dateFormat.format(DateTime.tryParse(project.startDate!)!)} - ${Utils.dateFormat.format(DateTime.tryParse(project.endDate!)!)}',
                      style: const TextStyle(fontSize: 13),
                      maxLines: 3),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
