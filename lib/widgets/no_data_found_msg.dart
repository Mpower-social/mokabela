import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

noDataFound({String msg = 'no_data_found'}){
  return Center(child: Text(msg.tr));
}