import 'package:flutter/material.dart';
import 'package:m_survey/res/color.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../models/local/all_form_list_data.dart';
import '../../utils/utils.dart';

Widget formCard({
  required AllFormsData data,
  GestureTapCallback? onTap,
}) {
  return Card(
    clipBehavior: Clip.hardEdge,
    color: white.withOpacity(.8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              constraints: const BoxConstraints(minHeight: 132),
              decoration: BoxDecoration(
                  color: data.status == 'true' ? activeColor : inactiveColor,
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
                        Text(data.title ?? '',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            maxLines: 3),
                        Visibility(
                          visible:
                              (data.projectName ?? '').isEmpty ? false : true,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(data.projectName ?? '',
                                style: const TextStyle(fontSize: 12),
                                maxLines: 3),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(
                              Icons.date_range,
                              color: grey,
                              size: 18,
                            ),
                            SizedBox(width: 5),
                            Text(Utils.dateFormat
                                .format(DateTime.parse(data.createdAt!))),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Total Submission: ${(data.totalSubmission ?? 0).toString()}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Column(
                      children: [
                        CircularPercentIndicator(
                          radius: 40.0,
                          lineWidth: 8.0,
                          percent: (data.totalSubmission ?? 0) / 1000,
                          center: Text(
                            '${((data.totalSubmission ?? 0) * 10) / 100}%',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          progressColor: Colors.green,
                        ),
                        SizedBox(height: 12),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${data.totalSubmission ?? 0}'.toString(),
                                style: TextStyle(fontSize: 16, color: green),
                              ),
                              TextSpan(
                                text: ' / ${data.target ?? 0}'.toString(),
                                style: TextStyle(fontSize: 16, color: black),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
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
