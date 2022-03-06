import 'package:app_builder/controllers/list_controller.dart';
import 'package:app_builder/list_definition/model/dto/list_item_action.dart';
import 'package:app_builder/list_definition/model/dto/list_item_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'base_list_page.dart';

class ListDetailsPage extends BaseListPage {
  final ListController controller = Get.find<ListController>();
  final List<ListItemContent> contents;
  final List<ListItemAction> actions;
  final String title;

  ListDetailsPage(
      {required this.title, this.contents = const [], this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        toolbarHeight: 90,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '$title Details',
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text('Profile'),
          ),
          SizedBox(height: 10),
          Card(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Container(
              padding: EdgeInsets.all(10),
              child: findListItem(context, contents, contents.length),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text('Actions'),
          ),
          Expanded(
            child: Card(
              margin: EdgeInsets.all(10),
              child: Container(
                height: double.infinity,
                child: ListView.separated(
                  itemCount: actions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.content_paste_outlined),
                      title: Text(actions[index].actionName!),
                      trailing: Icon(Icons.arrow_right),
                      onTap: () => controller.openForm(actions[index]),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      color: Colors.black,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
