import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m_survey/app_icons_icons.dart';
import 'package:m_survey/controllers/dashboard_controller.dart';
import 'package:m_survey/res/color.dart';
import 'package:get/get.dart';
import 'package:m_survey/utils/utils.dart';
import 'package:m_survey/widgets/dialog_info.dart';
import 'package:m_survey/widgets/icon_button.dart';

Widget drawer(String name, String designation, {required wp}){
  DashboardController controller = Get.find();
  return Drawer(
    backgroundColor: primaryColor,
    width: Get.width,
    child: Column(
      children: [
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(AppIcons.cross,size: 25,color: white,),
              onPressed: ()=>Get.back(),
            ),
          ),
        ),

        ///header
        Icon(AppIcons.account,size: 100,color: white,),
        const SizedBox(height: 10,),
        Text(name,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: white
          ),),
        const SizedBox(height: 5,),
        Text(designation,
          style: TextStyle(
              fontSize: 16,
              color: white
          ),),

        const SizedBox(height: 20,),
        ///list

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.settings,size: 25,color: white,),
                  title: Text('Settings',
                    style: TextStyle(
                        fontSize: 20,color: white
                    ),),
                ),

                ListTile(
                  leading: Icon(AppIcons.ongoing,size: 25,color: white,),
                  title: Text('Ongoing projects',
                    style: TextStyle(
                        fontSize: 20,color: white
                    ),),
                ),

                ListTile(
                  leading: Icon(AppIcons.archive,size: 25,color: white,),
                  title: Text('Archived projects',
                    style: TextStyle(
                        fontSize: 20,color: white
                    ),),
                ),

                ListTile(
                  leading: Icon(AppIcons.about,size: 25,color: white,),
                  title: Text('About',
                    style: TextStyle(
                        fontSize: 20,color: white
                    ),),
                ),

                ListTile(
                  leading: Icon(AppIcons.logout,size: 25,color: white,),
                  title: Text('Logout',
                    style: TextStyle(
                        fontSize: 20,color: white
                    ),),
                  onTap: (){
                    infoDialog(
                        title: 'Alert',
                        msg: 'Are you sure to Logout?',
                        confirmText: 'Yes',
                        cancelText: 'No',
                        onCancelTap: ()=>Get.back(),
                        onOkTap: ()=>Utils.logoutOperation()
                    );
                  },
                )
              ],
            ),
          ),
        ),

        Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconButton(
                  onTap: ()=>controller.getAllData(true),
                  icon: AppIcons.reload,
                  title: 'Load',width: wp),
              const SizedBox(width: 30,),
              iconButton(
                  onTap: ()=>controller.getAllData(true),
                  icon: AppIcons.sync_icon,
                  title: 'Sync',width: wp)
            ],
          ),
        ),

        const SizedBox(height: 20,)
      ],
    ),
  );
}

