import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_intent/android_intent.dart';
import 'dart:convert';
import './app_item.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences prefs;

  var numberOfInstalledApps;
  List apps = [];
  Map iconPool = Map.from({});
  List iconList = [];
  var wallpaper;

  @override
  initState() {
    super.initState();
    SharedPreferences.getInstance().then((ins) {
      prefs = ins;
      _initMyState();
    });
  }

  _initMyState() async {
    var jsonApps = await _loadAllAppFromPref();
    if (jsonApps == null) {
      var allApps = await this._loadAllApps();
      jsonApps = await this._storeAllAppToPref(allApps);
    }
    setState(() {
      this.apps.addAll(jsonApps);
    });
  }

  _goMiHome() async {
    AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: 'android.intent.category.HOME',
        package: 'com.miui.home');
    await intent.launch();
  }

  _operateList() async {
    List apps = await this._loadAllApps();
    Map _iconPool = Map.from({});
    apps.forEach((app) {
      print(app.appName);
      try {
        _iconPool[app.packageName] = app.icon;
      } catch (err) {
        print('no icon');
        print(err);
      }
    });
    setState(() {
      print('set pool');
      print(_iconPool);
      iconPool = _iconPool;
    });
    print(iconPool);
  }

  _loadAllAppFromPref() async {
    var rawList = prefs.getString('appList');
    if (rawList == null) {
      return null;
    }
    List jsonApps = jsonDecode(rawList);
    if (jsonApps.length == 0) {
      return null;
    }
    return jsonApps;
  }

  _loadAllApps() async {
    List<dynamic> allApps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true);
    return allApps;
  }

  _storeAllAppToPref(allApps) async {
    List<Map> json = [];
    allApps.forEach((app) {
      json.add({'pkg': app.packageName, 'title': app.appName});
    });
    await prefs.setString('appList', jsonEncode(json));
    return json;
  }

  _debug() async {
    await _initMyState();
    print('debug');
    print(apps);
    print(iconList);
    var _cc = apps.map((app) {
      return iconPool[app['pkg']];
    }).toList();
    setState(() {
      print('add icon list');
      this.iconList.removeRange(0, this.iconList.length);
      this.iconList.addAll(_cc);
    });
  }

  _clearAllApps() async {
    apps.removeRange(0, apps.length);
    setState(() {
      apps = apps;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return new MaterialApp(
      title: 'AppList',
      home: new Scaffold(
          body: AppItem(apps: apps, iconList: iconList),
          floatingActionButton: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: '122',
                  onPressed: _clearAllApps,
                  tooltip: 'Remove',
                  child: Icon(Icons.delete_outline),
                ),
                FloatingActionButton(
                  heroTag: null,
                  onPressed: _debug,
                  tooltip: 'Debug',
                  child: Icon(Icons.developer_board),
                ),
                FloatingActionButton(
                  heroTag: null,
                  onPressed: _operateList,
                  tooltip: 'Reload',
                  child: Icon(Icons.format_paint),
                ),
                FloatingActionButton(
                  heroTag: null,
                  onPressed: _goMiHome,
                  tooltip: 'MiHome',
                  child: Icon(Icons.home),
                )
              ]),
          backgroundColor: Colors.black),
    );
  }
}
