import 'package:app_builder/user/model/user.dart';
import 'package:app_builder/views/dashboard_page.dart';
import 'package:app_builder/views/side_bar.dart';
import 'package:flutter/material.dart';

class SideBarLayout extends StatelessWidget {
  final User user;

  SideBarLayout({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DashboardPage(),
          SideBar(
            user: user,
          ),
        ],
      ),
    );
  }
}
