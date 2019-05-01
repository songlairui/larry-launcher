import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

class AppItem extends StatefulWidget {
  AppItem({@required this.apps, @required this.iconList});

  final apps;
  final iconList;

  @override
  ItemState createState() => ItemState(apps: apps, iconList: iconList);
}

class ItemState extends State<AppItem> {
  ItemState({@required this.apps, @required this.iconList});

  final apps;
  final iconList;

  @override
  initState() {
    super.initState();
    print('~~');
  }

  Widget _buildRow(pkgInfo, icon) {
    return GestureDetector(
      onTap: () async {
        print('apps');
        print(pkgInfo);
        print(icon);
//        DeviceApps.openApp(pkgInfo['pkg']);
      },
      child: Container(
        child: new Column(children: [
          icon == null
              ? new Text('no icon',
                  style: new TextStyle(color: Colors.yellowAccent))
              : new Image.memory(
                  icon,
                  fit: BoxFit.scaleDown,
                  width: 32,
                ),
          new Text(
            pkgInfo['title'],
            style: new TextStyle(
              color: Colors.white,
              fontSize: 12.0,
              fontWeight: FontWeight.w900,
              fontFamily: "Georgia",
            ),
          ),
        ]),
        color: Colors.black26,
      ),
    );
  }

  Widget _buildAppList() {
    if (apps == null) {
      return new Text(
        "waiting",
        style: new TextStyle(color: Colors.yellowAccent),
      );
    }
    return new GridView.count(
        crossAxisCount: 5,
        childAspectRatio: 0.9,
        children: new List.generate(apps.length, (i) {
          var app = apps[i];
          var icon;
          try {
            icon = iconList[i];
          } catch (e) {}
          return _buildRow(app, icon);
        }));
  }

  @override
  Widget build(BuildContext ctx) {
    return _buildAppList();
  }
}