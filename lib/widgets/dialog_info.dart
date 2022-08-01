import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_survey/app_icons_icons.dart';
import 'package:m_survey/res/color.dart';
import 'package:m_survey/widgets/common_button.dart';

 infoDialog(
{
  String title = '',
  String msg = '',
  String confirmText = 'Yes',
  String cancelText = 'No',
  Function? onOkTap,
  Function? onCancelTap,
  Color bgColor = Colors.white
}){
   return showDialog(
      context: Get.context!, 
      builder: (ctx){
        return CupertinoAlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    onTap: ()=>Get.back(),
                    child: const Icon(AppIcons.cross,size: 18,)
                ),

              ),
              Text(title,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              const SizedBox(height: 10,),
              Text(msg),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: cancelText.isEmpty?false:true,
                    child: commonButton(
                        text: cancelText,
                        bg: primaryColor,
                        tap: ()=>onCancelTap!(),
                        width: 100,
                        height: 40
                    ),
                  ),

                  commonButton(
                      text: confirmText,
                      bg: green,
                      tap: ()=>onOkTap!(),
                      width: 100,
                      height: 40
                  )
                ],
              )
            ],
          ),
        );
      });
}