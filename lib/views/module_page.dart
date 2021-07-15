import 'package:app_builder/module/model/dto/module_item.dart';
import 'package:app_builder/utils/constant_util.dart';
import 'package:app_builder/views/list_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ModulePage extends StatelessWidget {
  final List<ModuleItem> moduleItems;
  final String title;

  ModulePage({required this.title, this.moduleItems = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
        ),
        itemCount: moduleItems.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Card(
              shadowColor: Colors.green,
              child: InkWell(
                onTap: () {
                  if (moduleItems[index].listId != null) {
                    Get.to(() => ListPage(
                          title: moduleItems[index].label.english!,
                          listId: moduleItems[index].listId!,
                        ));
                  } else if (moduleItems[index].xformId != null) {
                    Get.snackbar(
                      'Warning!',
                      'Related form not found.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  } else {
                    Get.to(
                        () => ModulePage(
                              title: moduleItems[index].label.english!,
                              moduleItems: moduleItems[index].children,
                            ),
                        preventDuplicates: false);
                  }
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              child: moduleItems[index].imgId != null &&
                                      moduleItems[index].imgId!.isNotEmpty
                                  ? CachedNetworkImage(
                                      width: 25,
                                      height: 25,
                                      imageUrl:
                                          '${ConstantUtil.imageBaseUrl}${moduleItems[index].imgId}',
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    )
                                  : Icon(Icons.turned_in_not),
                            ),
                            moduleItems[index].children.isNotEmpty
                                ? Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.arrow_right_alt,
                                      size: 35,
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              moduleItems[index].label.english!,
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          );
        },
      ),
    );
  }
}
