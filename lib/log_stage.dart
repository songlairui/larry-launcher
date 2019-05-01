import 'package:flutter/material.dart';

class LogState extends StatelessWidget {
  LogState(this.logs);

  final List<String> logs;

  @override
  Widget build(BuildContext ctx) {
    print('ctx $ctx');
    var children = <Widget>[];

    children = logs.map((str) {
      return new Text(str,
          textAlign: TextAlign.center,
          softWrap: true,
          style: new TextStyle(color: Colors.yellowAccent));
    }).toList();
    return new Row(
      children: <Widget>[Expanded(child: new Column(children: children))],
    );
  }
}
