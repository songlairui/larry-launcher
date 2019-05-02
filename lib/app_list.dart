import 'package:flutter/material.dart';
import './app_item.dart';

class AppList extends StatefulWidget {
  final apps;

  AppList({Key key, @required this.apps}) : super(key: key);

  @override
  _AppList createState() => _AppList();
}

class _AppList extends State<AppList> {
  Widget _buildRow(pkgInfo) {
    return AppItem(pkgInfo: pkgInfo);
  }

  Widget _buildAppList(apps) {
    if (apps == null || apps.length == 0) {
      return new Text(
        "waiting",
        textAlign: TextAlign.center,
        style: new TextStyle(color: Colors.yellowAccent),
      );
    }

    return new GridView.count(
        shrinkWrap: true,
        crossAxisCount: 5,
        childAspectRatio: 0.9,
        children: new List.generate(apps.length, (i) {
          var app = apps[i];
          return _buildRow(app);
        }));
  }

  @override
  Widget build(BuildContext ctx) {
    return _buildAppList(widget.apps);
  }
}
