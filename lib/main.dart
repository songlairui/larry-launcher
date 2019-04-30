import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

void main() => runApp(new MyApp());

class AppItem extends StatefulWidget {
  AppItem({@required this.apps});

  final apps;

  @override
  ItemState createState() => ItemState(apps: apps);
}

class ItemState extends State<AppItem> {
  ItemState({@required this.apps});

  final apps;

//  var icon;

  @override
  initState() async {
    super.initState();

//    setState(() {
////      _installedApps.addAll(apps);
//    });
//    DeviceApps.getInstalledApplications(
//            includeAppIcons: false,
//            onlyAppsWithLaunchIntent: true,
//            includeSystemApps: true)
//        .then((apps) {
//      setState(() {
//        _installedApps.addAll(apps);
//      });
//    });
  }

  Widget _buildRow(Application pkgInfo) {
    return GestureDetector(
      onTap: () async {
        print(pkgInfo);
        print(pkgInfo.appName);
//        print(pkgInfo.icon);
        DeviceApps.openApp(pkgInfo.packageName);
//        ApplicationWithIcon curApp =
//            await DeviceApps.getApp(pkgInfo.packageName, true);
//
//        print('set');
//        print(curApp.icon);
      },
      child: Container(
        child: new Column(children: [
//          icon == null
//              ? null
//              : new Image.memory(
//                  icon,
//                  fit: BoxFit.scaleDown,
//                  width: 32,
//                ),
          new Text(
            pkgInfo.appName,
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
    print('apps');
    print(apps);
    if (apps == null) {
      return new Text("waiting");
    }
    return new GridView.count(
        crossAxisCount: 5,
        childAspectRatio: 0.9,
        children: new List.generate(apps.length, (i) {
          return _buildRow(apps[i]);
        }));
  }

  @override
  Widget build(BuildContext ctx) {
    return _buildAppList();
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var numberOfInstalledApps;
  List<Application> apps = <Application>[];
  var wallpaper;

  @override
  initState() async {
    super.initState();

    List<Application> allApps = await DeviceApps.getInstalledApplications(
        includeSystemApps: true, onlyAppsWithLaunchIntent: true);
    setState(() {
      apps.addAll(allApps);
    });
  }

  _goMiHome() async {}

  @override
  Widget build(BuildContext ctx) {
    return new MaterialApp(
      title: 'AppList',
      home: new Scaffold(
          body: AppItem(apps: apps),
          floatingActionButton: FloatingActionButton(
            onPressed: _goMiHome,
            tooltip: 'MiHome',
            child: Icon(Icons.home),
          ),
          backgroundColor: Colors.black),
    );
  }
}
