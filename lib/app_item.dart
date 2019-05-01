import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import './fade_in_icon.dart';

class AppItem extends StatefulWidget {
  final apps;
  final iconList;

  AppItem({Key key, @required this.apps, @required this.iconList})
      : super(key: key);

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
  }

  Widget _buildRow(pkgInfo, icon) {
    print('_buildRow executed');
    return GestureDetector(
      onTap: () async {
        DeviceApps.openApp(pkgInfo['pkg']);
      },
      child: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FadeInIcon(bytes: icon, id: pkgInfo['pkg']),
          Text(
            pkgInfo['title'],
            textAlign: TextAlign.center,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 10.0,
              fontFamily: "Georgia",
            ),
          ),
        ]),
        color: Colors.black26,
      ),
    );
  }

  Widget _buildAppList() {
    if (apps == null || apps.length == 0) {
      return new Text(
        "waiting",
        textAlign: TextAlign.center,
        style: new TextStyle(color: Colors.yellowAccent),
      );
    }
    return GridView.builder(
        shrinkWrap: true,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
        itemCount: apps.length,
        itemBuilder: (BuildContext ctx, int idx) {
          var app = apps[idx];
          var icon;
          try {
            icon = iconList[idx];
          } catch (e) {}
          return _buildRow(app, icon);
        });
  }

  @override
  Widget build(BuildContext ctx) {
    return _buildAppList();
  }
}
