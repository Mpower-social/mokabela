import 'package:flutter/cupertino.dart';
import 'package:m_survey/res/color.dart';

Widget statisticsCard(
    {String title = '',
    String data = '',
    IconData? icon,
    int position = 1,
    double wp = 0}) {
  return Container(
    width: wp,
    constraints: const BoxConstraints(minHeight: 100),
    decoration: BoxDecoration(
        color: primaryColor,
        border: Border(
          top: BorderSide(width: .25, color: white),
          left: BorderSide(
              width: .25, color: position == 1 | 3 ? primaryColor : white),
          right: BorderSide(
              width: .25, color: position == 2 | 4 ? primaryColor : white),
        )),
    child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Icon(
                CupertinoIcons.arrow_right,
                color: white,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 30, color: primaryColorWithOp),
              Text(
                data,
                style: TextStyle(
                    color: white, fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
