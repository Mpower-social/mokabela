import 'package:flutter/material.dart';
import 'package:m_survey/constans/constant.dart';
import 'package:m_survey/res/color.dart';
import 'package:get/get.dart';
import 'package:m_survey/views/notification_screen.dart';

AppBar baseAppBar(
    {Function? onLeadingTap, String title = '', String from = ''}) {
  return AppBar(
    backgroundColor: primaryColor,
    iconTheme: IconThemeData(color: Colors.white),
    title: Text(title, style: TextStyle(color: Colors.white)),
    centerTitle: true,
    leading: IconButton(
      icon: const Icon(Icons.keyboard_backspace),
      onPressed: () => onLeadingTap ?? Get.back(),
    ),
    actions: [
      /* Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Visibility(
          visible: from == Constant.NOTIFICATION?false:true,
          child: InkWell(
            onTap: ()=>Get.to(()=>NotificationScreen()),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                const Icon(Icons.notifications_none,size: 30,),

                Visibility(
                  visible:true,
                  child: Container(
                    height: 20,
                    constraints: const BoxConstraints(
                        minHeight: 20,
                        minWidth: 20
                    ),
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(100)
                    ),

                    child: const Text('3',style: TextStyle(
                        color: Colors.white
                    ),),
                  ),
                ),
              ],
            ),
          ),
        ),
      )*/
    ],
  );
}
