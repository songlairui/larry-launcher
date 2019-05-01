import 'package:flutter/material.dart';

class FadeInIcon extends StatefulWidget {
  final bytes;

  FadeInIcon({Key key, @required this.bytes}) : super(key: key);

  @override
  _FadeInIcon createState() {
    return _FadeInIcon();
  }
}

class _FadeInIcon extends State<FadeInIcon> {
  @override
  Widget build(BuildContext ctx) {
    var bytes = widget.bytes;
    return bytes == null
        ? Icon(
            Icons.ac_unit,
            size: 48,
            color: Colors.lightBlueAccent,
          )
        : new Image.memory(
            bytes,
            fit: BoxFit.scaleDown,
            width: 48,
          );
  }
}
