import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import './fade_in_icon.dart';

class AppItem extends StatefulWidget {
  final pkgInfo;

  AppItem({Key key, @required this.pkgInfo}) : super(key: key);

  @override
  _AppItem createState() => _AppItem();
}

class _AppItem extends State<AppItem> {
  @override
  Widget build(BuildContext ctx) {
    var pkgInfo = widget.pkgInfo;
    return GestureDetector(
      onLongPress: () {
        print(pkgInfo['pkg']);
      },
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
        color: Colors.transparent,
      ),
    );
  }
}
