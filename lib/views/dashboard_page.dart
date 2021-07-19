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
    return Scaffold(
      body: GetX<DashboardController>(
        init: dashboardController,
        builder: (controller) {
          return ModulePage(
            title: "Modules",
            moduleItems: controller.moduleItems,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.sync),
          onPressed: () async {
            await syncController.startSync();
            await dashboardController.fetchModuleConfig();
          }),
    );
  }
}
