import 'package:flutter/material.dart';

@immutable
class RelayManualConfigDetailEditor extends StatefulWidget {
  final String initVal;

  RelayManualConfigDetailEditor({this.initVal = "off", Key key})
      : super(key: key);

  @override
  RelayManualDetailEditorState createState() => RelayManualDetailEditorState();
}

class RelayManualDetailEditorState
    extends State<RelayManualConfigDetailEditor> {
  String val;

  @override
  void initState() {
    val = widget.initVal ?? "off";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Switch(
      value: val == "on",
      onChanged: (newState) {
        setState(() {
          val = newState ? "on" : "off";
        });
      },
    ));
  }
}
