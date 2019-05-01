import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_intent/android_intent.dart';
import 'package:file_cache/file_cache.dart';
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
  FileCache fileCache;
  var wallpaper;

  @override
  initState() {
    super.initState();
    SharedPreferences.getInstance().then((ins) {
      prefs = ins;
      _initMyState();
    });
  }

  _initMyCache() async {
    if (fileCache == null) {
      fileCache = await FileCache.fromDefault();
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

  Future _loadIconByPkgName(pkgName) async {
    print('加载 $pkgName 图标');
    ApplicationWithIcon curApp = await DeviceApps.getApp(pkgName, true);
    var cacheIcon = curApp.icon;
    fileCache.store(
        pkgName,
        new CacheEntry(
            url: pkgName, bytes: cacheIcon, ctime: new DateTime.now(), ttl: 1));
    return cacheIcon;
  }

  Future _loadIconWhetherCache(pkgName) async {
//    print('pkgName: $pkgName');
    var cacheIcon = await fileCache.getBytes(pkgName);
//    print('cacheIcon: $cacheIcon');
    if (cacheIcon == null) {
      cacheIcon = await _loadIconByPkgName(pkgName);
    }
    return cacheIcon;
  }

  _loadAllIcons() async {
    List allIcons = new List(apps.length);
    List<Future> _futures = <Future>[];

    Future _setMe(i, pkgName) {
      return _loadIconWhetherCache(pkgName).then((r) {
        allIcons[i] = r;
      });
    }

    apps.asMap().forEach((i, app) {
      _futures.add(_setMe(i, app['pkg']));
    });

    await Future.wait(_futures);
    print('me');

    setState(() {
      this.iconList.removeRange(0, this.iconList.length);
      this.iconList.addAll(allIcons);
      print('add icon list');
    });
    return allIcons;
  }

  _debug() async {
    await _initMyState();
    print('debug');
    print(apps);
    print(iconList);

    await _loadAllIcons();
  }

  _clearAllApps() async {
    setState(() {
      iconList.removeRange(0, this.iconList.length);
      apps.removeRange(0, apps.length);
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
