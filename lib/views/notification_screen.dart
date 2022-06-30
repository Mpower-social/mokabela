import 'package:flutter/material.dart';
import 'package:m_survey/app_icons_icons.dart';
import 'package:m_survey/constans/constant.dart';
import 'package:m_survey/controllers/notification_controller.dart';
import 'package:m_survey/res/color.dart';
import 'package:m_survey/res/screen_size.dart';
import 'package:m_survey/widgets/app_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotificationScreen extends StatelessWidget {
  Function? hp;
  Function? wp;

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    hp = Screen(MediaQuery.of(context).size).hp;
    return SafeArea(
      child: Scaffold(
        appBar: baseAppBar(title: 'Notifications',from:Constant.NOTIFICATION),

        body: GetX<NotificationController>(
          init: NotificationController(),
          builder: (controller) => ListView.separated(
            itemCount: controller.notificationList.length,
            itemBuilder: (ctx, i) {
              return Slidable(
                key: const ValueKey(0),
                direction: Axis.horizontal,
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  extentRatio: .165,
                  children: [
                    SlidableAction(
                      flex: 1,
                      padding: const EdgeInsets.all(0),
                      onPressed: (ctx) => null,
                      backgroundColor: red,
                      foregroundColor: Colors.white,
                      icon: AppIcons.delete,
                    ),
                  ],
                ),
                child: Container(
                  width: wp!(100),
                  color: grey.withOpacity(.2),
                  child: Row(
                    children: [
                      Container(
                        height: wp!(15),
                        width: wp!(15),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: wp!(1.5),top: 10,bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(400),
                          border: Border.all(color: grey.withOpacity(.4)),
                          color: white
                        ),
                        child: const Text('A',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      ),
                      SizedBox(width: 10,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('A Form has beeen assign to you',style: TextStyle(fontSize: 16),),
                          SizedBox(height: 5,),
                          Text('01 feb 2022, 630pm',style: TextStyle(color: grey),)
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (ctx, i) {
              return const SizedBox(
                height: 5,
              );
            },
          ),
        ),
      ),
    );
  }
}
