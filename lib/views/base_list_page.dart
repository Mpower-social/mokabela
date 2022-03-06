import 'package:app_builder/list_definition/model/dto/list_item.dart';
import 'package:app_builder/list_definition/model/dto/list_item_content.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class BaseListPage extends StatelessWidget {
  Widget findListItem(
      BuildContext context, List<ListItemContent> contents, int length) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        length,
        (contentIndex) => RichText(
          text: TextSpan(
            style: GoogleFonts.roboto(
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: '${contents[contentIndex].name}: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: contents[contentIndex].value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
