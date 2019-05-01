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
  var wallpaper;

  @override
  initState() {
    super.initState();
    SharedPreferences.getInstance().then((ins) {
      prefs = ins;
      _loadAllAppFromPref().then((jsonApps) {
        if (jsonApps == null) {
          return this._storeAllAppToPref();
        }
        return jsonApps;
      }).then((jsonApps) {
        setState(() {
          this.apps.addAll(jsonApps);
        });
      });
    });
  }

  _goMiHome() async {
    AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: 'android.intent.category.HOME',
        package: 'com.miui.home');
    await intent.launch();
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

  _storeAllAppToPref() async {
    List<Application> allApps = await DeviceApps.getInstalledApplications(
        includeSystemApps: true, onlyAppsWithLaunchIntent: true);
    List<Map> json = [];
    allApps.forEach((app) {
      json.add({'pkg': app.packageName, 'title': app.appName});
    });
    await prefs.setString('appList', jsonEncode(json));
    return json;
  }

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
