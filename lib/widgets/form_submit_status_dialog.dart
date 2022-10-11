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
                  child: list.length==0?noDataFound(msg: 'no_form_found'):ListView.separated(
                      itemCount: list.length,
                      itemBuilder: (ctx,i){
                        return Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: grey),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(list[i].formName),
                              Text(list[i].status==true?'Success':'Failed'),
                            ],
                          ),
                        );
                      },

                    separatorBuilder: (ctx,i)=>SizedBox(height: 5,),
                  ),
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