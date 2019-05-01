import 'package:flutter/material.dart';

class FadeInIcon extends StatefulWidget {
  FadeInIcon({@required this.bytes, this.id});

  final bytes;
  final id;

  @override
  _FadeInIcon createState() {
    return _FadeInIcon();
  }
}

class _FadeInIcon extends State<FadeInIcon> {
  @override
  Widget build(BuildContext ctx) {
    var bytes = widget.bytes;
    if (bytes == null) {
      return new Icon(
        Icons.ac_unit,
        size: 48,
        color: Colors.lightBlueAccent,
      );
    }
    return new Image.memory(
      bytes,
      fit: BoxFit.scaleDown,
      width: 48,
    );
  }
}
