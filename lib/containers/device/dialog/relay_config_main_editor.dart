import 'package:flutter/material.dart';
import '../../../actions/device_bloc.dart';
import './relay_config_detail_editor.dart';

class RelayConfigEditor extends StatefulWidget {
  final String initMode;
  final dynamic initDetail;
  final int relayIndex;

  RelayConfigEditor({this.relayIndex, this.initMode = "manual", this.initDetail, Key key}) : super(key: key);


  @override
  RelayConfigEditorState createState() {
    return RelayConfigEditorState();
  }

}

class RelayConfigEditorState extends State<RelayConfigEditor> {
  String mode;
  GlobalKey<RelayManualDetailEditorState>  _manualDetailEditorKey = GlobalKey();
  GlobalKey<RelayAutoConfigDetailEditorState>  _autoDetailEditorKey = GlobalKey();
  final _availableMode = ["manual", "auto", /*"scheduled"*/];

  SetDeviceRelaysConfig get value{
    return SetDeviceRelaysConfig.Safe(
      widget.relayIndex,
      mode: mode,
      detail: mode == "manual" ? _manualDetailEditorKey.currentState.val : _autoDetailEditorKey.currentState.val
    );
  }

  @override
    void initState() {
      mode = widget.initMode;
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case "manual":
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new DropdownButton<String>(
              items: _availableMode.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  mode = value;
                });
              },
              hint: Text("Mode"),
              value: mode,
            ),
            RelayManualConfigDetailEditor(initVal: (widget.initDetail is String) ? widget.initDetail : null, key: _manualDetailEditorKey,)
          ],
        );
      case "auto":
        return Container(
          height: 0.25 * MediaQuery.of(context).size.height,
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: new DropdownButton<String>(
                    isExpanded: true,
                    items: _availableMode.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        mode = value;
                      });
                    },
                    hint: Text("Mode"),
                    value: mode,
                  ),
                ),
                RelayAutoConfigDetailEditor(initVal: (widget.initDetail is Map) ? widget.initDetail : null, key: _autoDetailEditorKey,)
              ],
            ),
        );
      case "scheduled":
        return Container(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: new DropdownButton<String>(
                    isExpanded: true,
                    items: _availableMode.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        mode = value;
                      });
                    },
                    hint: Text("Mode"),
                    value: mode,
                  ),
                ),
                RelayScheduledConfigDetailEditor(initVal: (widget.initDetail is Map) ? widget.initDetail : null, key: _autoDetailEditorKey,)
              ],
            ),
        );
    }
  }

}