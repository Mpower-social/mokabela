import 'package:app_builder/controllers/list_controller.dart';
import 'package:app_builder/list_definition/model/dto/list_item_action.dart';
import 'package:app_builder/views/filter_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ListPage extends StatelessWidget {
  late final ListController listController;
  final String title;
  final int listId;

  ListPage({required this.title, required this.listId}) {
    listController = ListController(listId: listId);
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
                                    controller,
                                    index,
                                    controller.filteredListItems[index].contents
                                        .length)
                                : findListItem(context, controller, index, 3);
                          }),
                        ),
                        controller.filteredListItems[index].actions.length > 0
                            ? Container(
                                padding: EdgeInsets.only(left: 10),
                                child: PopupMenuButton(
                                  onSelected: controller.openForm,
                                  itemBuilder: (context) => List.generate(
                                    controller.filteredListItems[index].actions
                                        .length,
                                    (actionIndex) =>
                                        PopupMenuItem<ListItemAction>(
                                      value: controller.filteredListItems[index]
                                          .actions[actionIndex],
                                      child: Text(
                                        controller.filteredListItems[index]
                                            .actions[actionIndex].actionName!,
                                      ),
                                    ),
                                  ),
                                ),
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

  Widget findListItem(
      BuildContext context, ListController controller, int index, int length) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        length,
        (contentIndex) => RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(
                text:
                    '${controller.filteredListItems[index].contents[contentIndex].name}: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: controller
                    .filteredListItems[index].contents[contentIndex].value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
