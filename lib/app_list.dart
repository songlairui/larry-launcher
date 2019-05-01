import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import './fade_in_icon.dart';

class AppItem extends StatefulWidget {
  final apps;

  AppItem({Key key, @required this.apps}) : super(key: key);

  @override
  ItemState createState() => ItemState();
}

class ItemState extends State<AppItem> {
  Widget _buildRow(pkgInfo) {
    return GestureDetector(
      onTap: () async {
        DeviceApps.openApp(pkgInfo['pkg']);
      },
      child: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FadeInIcon(bytes: pkgInfo['icon']),
          Expanded(
              child: Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                children: <Widget>[
                  Text(
                    pkgInfo['title'],
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 10.0,
                      fontFamily: "Georgia",
                    ),
                  ),
                ],
              )),
            ],
          )),
        ]),
        color: Colors.black26,
      ),
    );
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
