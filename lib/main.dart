import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_intent/android_intent.dart';
import 'dart:convert';
import './app_list.dart';
import './icon_cache.dart';
import './log_stage.dart';

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
  List<String> logs = <String>['~~~ 梦游天姥吟留别  ~~~ ', '天姥连天向天横'];
  IconFileCache fileCache;
  var wallpaper;

  double opacityLevel = 1.0;

  @override
  initState() {
    super.initState();
    SharedPreferences.getInstance().then((ins) {
      prefs = ins;
      _initMyState();
    });
  }

  Future<Map> _iconLoader(String pkgName, int forceCache) async {
    print('加载 $pkgName 图标');
    ApplicationWithIcon curApp = await DeviceApps.getApp(pkgName, true);
    int ttl = 86400;
    return {'ttl': ttl, 'bytes': curApp.icon};
  }

  _initMyCache() async {
    if (fileCache == null) {
      fileCache =
          await IconFileCache.fromDefault(loader: _iconLoader, scan: true);
    }
    return fileCache;
  }

  _initMyState() async {
    await this._initMyCache();
    var jsonApps = await _loadAllAppFromPref();
    if (jsonApps == null) {
      var allApps = await this._loadAllApps();
      jsonApps = await this._storeAllAppToPref(allApps);
    }
    setState(() {
      this.apps.addAll(jsonApps);
    });
    print('_initMyState');
    this._loadAllIcons();
  }

  _goMiHome() async {
    AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: 'android.intent.category.HOME',
        package: 'com.miui.home');
    await intent.launch();
  }

  _operateList() async {
    print('_operateList');
    _changeOpacity();
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
        includeSystemApps: true, onlyAppsWithLaunchIntent: true);
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

  _loadAllIcons() async {
    List allIcons = new List(apps.length);
    this.iconList.length = apps.length;
    List<Future> _futures = <Future>[];

    apps.asMap().forEach((i, app) {
      _futures.add(fileCache.getBytes(app['pkg']).then((r) {
        if (r == null) {
          print('no icon');
        }
        setState(() {
          app['icon'] = r;
//          this.iconList[i] = r;
        });
      }));
    });

    await Future.wait(_futures);
    print('me');

    return allIcons;
  }

  _debug() async {
    await _initMyState();
    print('debug');
  }

  _clearAllApps() async {
    setState(() {
      iconList.removeRange(0, this.iconList.length);
      apps.removeRange(0, apps.length);
    });
  }

  void _changeOpacity() {
    setState(() {
      opacityLevel = opacityLevel == 0 ? 1.0 : 0.0;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      title: 'AppList',
      home: Scaffold(
          body: OrientationBuilder(builder: (ctx, orientation) {
            var children = <Widget>[
              Expanded(
                  child: Container(
                      child: LogState(
                logs: logs,
                opacity: opacityLevel,
              ))),
              Expanded(child: AppItem(apps: apps))
            ];
            if (orientation == Orientation.portrait) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              );
            } else {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              );
            }
          }),
          floatingActionButton: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 36),
                  child: FloatingActionButton(
                    heroTag: '122',
                    onPressed: _clearAllApps,
                    tooltip: 'Remove',
                    child: Icon(Icons.delete_outline),
                    mini: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 38),
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: _debug,
                    tooltip: 'Debug',
                    child: Icon(Icons.developer_board),
                    mini: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 40),
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: _operateList,
                    tooltip: 'Reload',
                    child: Icon(Icons.format_paint),
                    mini: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: FloatingActionButton.extended(
                      heroTag: null,
                      onPressed: _goMiHome,
                      tooltip: 'MiHome',
                      icon: Icon(Icons.home),
                      label: Text('系统桌面')),
                ),
              ]),
          backgroundColor: Colors.black),
    );
  }
}
