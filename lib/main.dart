import 'package:flutter/material.dart';
import 'package:launcher_assist/launcher_assist.dart';

void main() => runApp(new MyApp());

class AppItem extends StatefulWidget {
  @override
  ItemState createState() => ItemState();
}

class ItemState extends State<AppItem> {
  final List<dynamic> _installedApps = <dynamic>[];

  @override
  initState() {
    super.initState();
    LauncherAssist.getAllApps().then((apps) {
      setState(() {
        _installedApps.addAll(apps);
      });
    });
  }

  Widget _buildRow(pkgInfo) {
    return GestureDetector(
      onTap: () {
        print(pkgInfo["package"]);
        LauncherAssist.launchApp(pkgInfo["package"]);
      },
      child: Container(
        child: new Image.memory(
          pkgInfo["icon"],
          fit: BoxFit.scaleDown,
          width: 36,
        ),
        color: Colors.black26,
      ),
    );
  }

  Widget _buildAppList() {
    return new GridView.count(
        crossAxisCount: 5,
        childAspectRatio: 0.9,
        children: new List.generate(_installedApps.length, (i) {
          return _buildRow(_installedApps[i]);
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
  var appss;
  var wallpaper;

  @override
  initState() {
    super.initState();
    LauncherAssist.getAllApps().then((apps) {
      setState(() {
        numberOfInstalledApps = apps.length;
        appss = apps;
      });
    });
  }

  _goMiHome() {
    print('com.miui.home');
    LauncherAssist.launchApp('com.miui.home');
  }

  @override
  Widget build(BuildContext ctx) {
    return new MaterialApp(
      title: 'AppList',
      home: new Scaffold(
          body: AppItem(),
          floatingActionButton: FloatingActionButton(
            onPressed: _goMiHome,
            tooltip: 'MiHome',
            child: Icon(Icons.home),
          ),
          backgroundColor: Colors.black),
    );
  }
}
