import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m_survey/models/form_data.dart';
import 'package:m_survey/res/color.dart';

Widget recentFormCard({required FormData formData}) {
  return Card(
    color: white.withOpacity(.8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: SizedBox(
      width: 120,
      height: 100,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                  color:
                      formData.status == 'true' ? activeColor : inactiveColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10))),
            ),
          ),
          Flexible(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formData.displayName ?? "",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    formData.projectName ?? "",
                    style: TextStyle(fontSize: 15, color: Color(0xFF444444)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}
