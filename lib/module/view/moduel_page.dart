import 'package:app_builder/module/bloc/module_bloc.dart';
import 'package:app_builder/module/model/dto/module.dart';
import 'package:app_builder/utils/navigator_utils.dart';
import 'package:app_builder/utils/page_utils.dart';
import 'package:flutter/material.dart';

class ModulePage extends StatefulWidget {
  final List<Module>? modules;

  ModulePage({
    this.modules,
  });

  @override
  _ModulePageState createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  late double _pageHeight;
  late double _pageWidth;
  late ModuleBloc _moduleBloc;

  @override
  void initState() {
    _moduleBloc = ModuleBloc();
    _moduleBloc.getFormConfigAndGenerateTables();
    super.initState();
  }

  @override
  void dispose() {
    _moduleBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _pageWidth = PageUtils.getPageWidth(context);
    _pageHeight = PageUtils.getPageHeight(context: context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Modules'),
      ),
      body: Container(
        height: _pageHeight,
        child: SingleChildScrollView(
          child: widget.modules != null
              ? Column(
                  children: [
                    ...widget.modules!
                        .map((module) => _moduleItemWidget(module))
                        .toList(),
                  ],
                )
              : _getModulesWidget(),
        ),
      ),
    );
  }

  Widget _getModulesWidget() {
    _moduleBloc.getModules();
    return StreamBuilder<dynamic>(
        stream: _moduleBloc.modulesStreamController.streamListener,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var module = snapshot.data as Module;
            return _moduleItemWidget(module);
          } else {
            return Center(child: Text('No date found'));
          }
        });
  }

  Widget _moduleItemWidget(Module module) {
    return ListTile(
      onTap: () {
        if (module.children != null && module.children!.length > 0) {
          NavigatorUtils.push(
              context,
              ModulePage(
                modules: module.children,
              ));
        }
      },
      title: Text(
        module.label?.english ?? 'no label found',
        overflow: TextOverflow.ellipsis,
      ),
      trailing: module.children != null && module.children!.length > 0
          ? Icon(
              Icons.next_plan,
              color: Colors.red,
            )
          : Container(
              width: 1,
              height: 1,
            ),
    );
  }
}
