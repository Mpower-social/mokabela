import 'package:app_builder/controllers/list_controller.dart';
import 'package:app_builder/views/filter_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'base_list_page.dart';

class ListPage extends BaseListPage {
  late final ListController listController;
  final String title;
  final int listId;

  ListPage({required this.title, required this.listId}) {
    listController = Get.put(ListController(listId: listId));
  }

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
          title,
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: listController.fetchDataAndUpdate,
            icon: Obx(() {
              return listController.communicationWithServer.value
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    )
                  : Icon(Icons.sync);
            }),
            color: Colors.black,
          ),
          Obx(
            () {
              return listController.filterItems.isNotEmpty
                  ? IconButton(
                      onPressed: () async {
                        await Get.to(
                            () => FilterPage(listController.filterItems));
                        listController.onFilterApply();
                      },
                      icon: Icon(Icons.filter_alt_outlined),
                      color: Colors.black,
                    )
                  : SizedBox();
            },
          ),
          /*Container(
            child: Stack(
              children: [
                Icon(
                  Icons.sync,
                  color: Colors.black,
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '0',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),*/
        ],
      ),
      body: GetX<ListController>(
        init: listController,
        builder: (controller) {
          return ListView.builder(
            itemCount: controller.filteredListItems.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: InkWell(
                  onTap: () {
                    controller.expandList[index].value =
                        !controller.expandList[index].value;
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Obx(() {
                            return controller.expandList[index].value
                                ? findListItem(
                                    context,
                                    controller
                                        .filteredListItems[index].contents,
                                    controller.filteredListItems[index].contents
                                        .length)
                                : findListItem(
                                    context,
                                    controller
                                        .filteredListItems[index].contents,
                                    3);
                          }),
                        ),
                        controller.filteredListItems[index].actions.length > 0
                            ? InkWell(
                                onTap: () => controller.moveToDetailPage(
                                    title.split(' ').first,
                                    controller.filteredListItems[index]),
                                child: Icon(Icons.arrow_forward_ios),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
