import 'package:flutter/material.dart';
import 'package:m_survey/res/color.dart';

iconButton({
  IconData? icon,
  String title = '',
  Color bg = Colors.white,
  Color? textColor,
  double height = 45,
  double width = 45,
  Function? onTap
}) {
  textColor ??= primaryColor;
  return ElevatedButton(
      onPressed: ()=>onTap!(),
      style: ElevatedButton.styleFrom(
          primary: bg,
          fixedSize: Size(width,height),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
          )
      ),
      child: Row(
        children: [
          Icon(icon,color: textColor,),
          const SizedBox(width: 8,),
          Text(title,style: TextStyle(color: textColor,fontWeight: FontWeight.bold),)
        ],
      )
  );
}