
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m_survey/res/color.dart';

Widget recentFormCard({
  String title = '',
  String subTitle = ''
}){
  return Card(
    color: white.withOpacity(.8),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
    ),
    child: SizedBox(
      width: 120,
      height: 110,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                  color: green,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10))
              ),
            ),
          ),

          Flexible(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,style: const TextStyle(fontSize: 15),maxLines: 3),
                  const SizedBox(height: 5,),
                  Text(subTitle,style: TextStyle(fontSize: 14,color: grey),)
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}