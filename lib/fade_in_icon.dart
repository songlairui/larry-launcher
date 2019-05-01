import 'package:flutter/material.dart';

class FadeInIcon extends StatefulWidget {
  final bytes;
  final id;

  FadeInIcon({@required this.id, @required this.bytes});

  @override
  _FadeInIcon createState() {
    print('key: $key');
    return _FadeInIcon();
  }
}

class _FadeInIcon extends State<FadeInIcon> {
  @override
  void initState() {
    super.initState();

    print('-c- $this');
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('-u- $oldWidget $this');
  }

  @override
  Widget build(BuildContext ctx) {
    var bytes = widget.bytes;
    bool blank = bytes == null;
    return new AnimatedOpacity(
      opacity: blank ? 1.0 : 0.3,
      duration: Duration(microseconds: 1500),
      child: new Icon(
        Icons.ac_unit,
        size: 48,
        color: Colors.lightBlueAccent,
      ),
    );

//    return new Image.memory(
//      bytes,
//      fit: BoxFit.scaleDown,
//      width: 48,
//    );
  }
}
