import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../res/color.dart';

Widget ongoingProjectCard({
  String title = '',
  int formCount = 0,
  String dateRange = '',
  bool status = false
}){
  return Card(
    color: white.withOpacity(.8),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
    ),
    child: Container(
      height: 80,
      constraints: const BoxConstraints(
        minHeight: 80
      ),
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Row(
        children: [
          Flexible(
            flex: 4,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,style: TextStyle(fontSize: 15,color: black)),
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: primaryColor
                        ),
                        child: Text(formCount.toString(),style: TextStyle(color: white),),
                      ),
                      const SizedBox(width: 5,),
                      const Text('Forms')
                    ],
                  )
                ],
              ),

          ),

          Flexible(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: status?green:red
                  ),
                ),
                Text(dateRange,style: const TextStyle(fontSize: 13),maxLines: 3),
              ],
            ),
          )
        ],
      ),
    ),
  );
}