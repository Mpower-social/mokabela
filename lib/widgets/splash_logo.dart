import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

splashLogoHolder(
    String imageOne,
    String imageTwo,
    String from,
    double imHeight,double imWidth,
){
  return Container(
    margin: EdgeInsets.only(left: 30,right: 30,top: 30),
    child: Column(
      children: [
        Visibility(
            visible: from == 'bottom'?true:false,
            child: Text('Implemented By',
              style: TextStyle(
                  color: Colors.amber[600],
                  fontWeight: FontWeight.bold
              ),)
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                constraints: BoxConstraints(
                  minHeight:imHeight,
                  maxWidth: imWidth
                ),
                child: Image.asset(imageOne)),
            Container(
                constraints: BoxConstraints(
                    minHeight:imHeight,
                    maxWidth: imWidth
                ),
                child: Image.asset(imageTwo))
          ],
        ),
      ],
    ),
  );
}