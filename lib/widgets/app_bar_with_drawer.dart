import 'package:flutter/material.dart';
import 'package:m_survey/views/notification_screen.dart';
import 'package:get/get.dart';
import '../res/color.dart';

AppBar baseAppBarWithDrawer(
    {BuildContext? context, Function? onLeadingTap, String title = ''}) {
  return AppBar(
    backgroundColor: primaryColor,
    iconTheme: IconThemeData(color: Colors.white),
    elevation: 0,
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    ),
    centerTitle: true,
    /* leading: IconButton(
      onPressed: (){},
      icon: const Icon(AppIcons.burger,color: Colors.white,),
    ),*/
    actions: [
      /*Padding(
        padding: const EdgeInsets.only(right: 10),
        child: InkWell(
          onTap: () => Get.to(() => NotificationScreen()),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              const Icon(
                Icons.notifications_none,
                size: 30,
              ),
              Visibility(
                visible: true,
                child: Container(
                  height: 20,
                  constraints:
                      const BoxConstraints(minHeight: 20, minWidth: 20),
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(100)),
                  child: const Text(
                    '3',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      )*/
    ],
  );
}
