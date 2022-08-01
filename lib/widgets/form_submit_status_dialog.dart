import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_survey/models/form_submit_status.dart';
import 'package:m_survey/res/color.dart';
import 'package:m_survey/widgets/common_button.dart';
import 'package:m_survey/widgets/no_data_found_msg.dart';

showFormSubmitStatusDialog(List<FormSubmitStatus> list){
  return showDialog(
      context: Get.context!,
      builder: (ctx){
        return CupertinoAlertDialog(
          content: Container(
            height: 300,
            child: Column(
              children: [
                Text('Form Submit Status',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                SizedBox(height: 15,),
                Expanded(
                  child: list.length==0?noDataFound():ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (ctx,i){
                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(list[i].formName),
                              Text(list[i].status==true?'Success':'Failed'),
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
          actions: [
            commonButton(
                text: 'Ok',
                bg: green,
                tap: ()=>Get.back(),
                width: 100,
                height: 40
            )
          ],
        );
      });
}