import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m_survey/res/color.dart';
import 'package:percent_indicator/percent_indicator.dart';

Widget formCard(
    {String title = '',
    String subTittle = '',
    String date = '',
    int totalSubmission = 0,
    int totalForm = 0,
    int submittedForm = 0}) {
  return Card(
    color: white.withOpacity(.8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Row(
      children: [
        Flexible(
          flex: 1,
          child: Container(
            constraints: const BoxConstraints(minHeight: 120),
            decoration: BoxDecoration(
                color: green,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10))),
          ),
        ),
        Flexible(
          flex: 40,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          maxLines: 3),
                      Visibility(
                          visible: subTittle.isEmpty ? false : true,
                          child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(subTittle,
                                  style: const TextStyle(fontSize: 12),
                                  maxLines: 3))),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            color: grey,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(date),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Submission: ${totalSubmission.toString()}',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: '$submittedForm'.toString(),
                              style: TextStyle(fontSize: 16, color: green),
                            ),
                            TextSpan(
                              text: '/$totalForm'.toString(),
                              style: TextStyle(fontSize: 16, color: black),
                            )
                          ]))
                        ],
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: CircularPercentIndicator(
                    radius: 40.0,
                    lineWidth: 8.0,
                    percent: submittedForm / 1000,
                    center: Text(
                      '${(submittedForm * 10) / 100}%',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    progressColor: Colors.green,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    ),
  );
}
