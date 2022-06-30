import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

singleImageHolder(
    String imageOne,
    double imHeight,double imWidth,
){
  return Container(
    margin: const EdgeInsets.only(left: 30,right: 30,top: 30),
    child: Column(
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                constraints: BoxConstraints(
                  minHeight:imHeight,
                  maxWidth: imWidth
                ),
                child: Image.asset(imageOne))
          ],
        ),
      ],
    ),
  );
}