import 'package:app_builder/controllers/list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

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
        title: Text(title),
      ),
      body: GetX<ListController>(
        init: listController,
        builder: (controller) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: List.generate(
                  controller.tableHeaders.length,
                  (index) {
                    return DataColumn(
                      label: Center(
                        child: Text(
                          controller.tableHeaders[index],
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
                rows: List.generate(
                  controller.tableContents.length,
                  (index) {
                    return DataRow(
                      cells: List.generate(
                        controller.tableContents[index].length,
                        (celllIndex) {
                          return DataCell(
                            Text(
                              controller.tableContents[index][celllIndex],
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
