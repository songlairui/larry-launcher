import 'package:flutter/material.dart';

class LogState extends StatelessWidget {
  final List<String> logs;
  final double opacity;

  LogState({this.logs, @required this.opacity});

  @override
  Widget build(BuildContext ctx) {
    var children = <Widget>[];

    logs.forEach((str) {
      children.add(new Text(str,
          textAlign: TextAlign.center,
          softWrap: true,
          style: new TextStyle(color: Colors.yellowAccent)));
    });
    children.add(AnimatedOpacity(
      opacity: opacity,
      duration: Duration(seconds: 1),
      child: new Text(
        '对此欲倒东南倾',
        style: new TextStyle(color: Colors.white),
      ),
    ));
    return new Row(
      children: <Widget>[
        Expanded(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.end, children: children))
      ],
    );
  }
}
