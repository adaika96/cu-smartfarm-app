import 'package:flutter/material.dart';

import './drawer/schedule_table_drawer.dart';
import './relay_config_detail_editor.dart';
import './schedule/schedule_setting_page.dart';
import '../../../actions/device_bloc.dart';

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
  Map<String, dynamic> _scheduleEditorVal = {
    "repeat": true,
    "schedules": []
  };
  final _availableMode = ["manual", "auto", "scheduled"];

  SetDeviceRelaysConfig get value{
    print(_scheduleEditorVal);
    return SetDeviceRelaysConfig.Safe(
      widget.relayIndex,
      mode: this.mode,
      detail: this.mode == "manual" ? _manualDetailEditorKey.currentState.val :
      this.mode == "scheduled" ? _scheduleEditorVal : _autoDetailEditorKey.currentState.val
    );
  }

  @override
    void initState() {
      mode = widget.initMode;
      if(widget.initMode == "scheduled"){
        _scheduleEditorVal = widget.initDetail ?? _scheduleEditorVal;
      }
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
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child:
                new DropdownButton<String>(
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
            Container(
              height: 50,
              child:
                CustomPaint(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (){
                      var hourTickPoint = <Widget>[];
                      List.generate(12, (i)=>(i+1)).forEach((index){
                        var _hours = index * (24/12);
                        hourTickPoint.add(
                          Expanded(
                            child: Text("${_hours < 10 ? 0 : ""}${_hours.toInt()}",textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 10),),
                          )
                        );
                      });
                      return hourTickPoint;
                    }()
                  ),
                  painter: ScheduleDrawer(hourTickCount: 12, schedule: _scheduleEditorVal["schedules"]),
              )
            ),
            Row(
              children: <Widget>[
                Text("Repeat: "),
                Switch(
                  value: _scheduleEditorVal["repeat"],
                )
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child:
                MaterialButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () async {
                    var newConfigDetail = await Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ScheduleEditPage(initVal: _scheduleEditorVal),
                      ),
                    );
                    if(newConfigDetail != null){
                      setState(() {
                        mode = "scheduled";
                        _scheduleEditorVal = newConfigDetail;
                      });
                    }
                  },
                  child: Text("Edit..."),
                ),
            ),
        ],
      );
    }
  }

}