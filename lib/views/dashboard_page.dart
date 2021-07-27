import 'package:app_builder/controllers/dashboard_controller.dart';
import 'package:app_builder/controllers/sync_controller.dart';
import 'package:app_builder/views/module_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends StatelessWidget {
  final dashboardController = DashboardController();
  final syncController = SyncController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GetX<DashboardController>(
          init: dashboardController,
          builder: (controller) {
            var isEmpty = controller.moduleItem.value == null;

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: ModulePage(
                title: "Modules",
                showAppBar: false,
                moduleItems:
                    isEmpty ? [] : controller.moduleItem.value!.children,
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(child: Obx(() {
          return syncController.communicationWithServer.value
              ? SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                )
              : Icon(
                  Icons.sync,
                  size: 30,
                );
        }), onPressed: () async {
          if (!syncController.communicationWithServer.value) {
            await syncController.startSync();
          }

          await dashboardController.fetchModuleConfig();
        }),
      ),
    );
  }
}
