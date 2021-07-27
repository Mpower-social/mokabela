import 'package:app_builder/controllers/list_controller.dart';
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
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                sortColumnIndex: controller.currentSortColumn.value,
                sortAscending: controller.isAscending.value,
                headingRowColor: MaterialStateProperty.all(Colors.amber),
                columns: List.generate(
                  controller.tableHeaders.length,
                  (index) {
                    return DataColumn(
                      onSort: (columnIndex, _) => controller.sort(columnIndex),
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
