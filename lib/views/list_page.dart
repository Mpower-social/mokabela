import 'package:app_builder/controllers/list_controller.dart';
import 'package:app_builder/list_definition/model/dto/list_item_action.dart';
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
    var size = MediaQuery.of(context).size;

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
      ),
      body: GetX<ListController>(
        init: listController,
        builder: (controller) {
          return ListView.builder(
            itemCount: controller.listItems.length,
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
                                ? findListItem(context, controller, index,
                                    controller.listItems[index].contents.length)
                                : findListItem(context, controller, index, 3);
                          }),
                        ),
                        controller.listItems[index].actions.length > 0
                            ? Container(
                                padding: EdgeInsets.only(left: 10),
                                child: PopupMenuButton(
                                  onSelected: controller.openForm,
                                  itemBuilder: (context) => List.generate(
                                    controller.listItems[index].actions.length,
                                    (actionIndex) =>
                                        PopupMenuItem<ListItemAction>(
                                      value: controller.listItems[index]
                                          .actions[actionIndex],
                                      child: Text(
                                        controller.listItems[index]
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
                    '${controller.listItems[index].contents[contentIndex].name}: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: controller.listItems[index].contents[contentIndex].value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
