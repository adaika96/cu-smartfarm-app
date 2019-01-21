import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/time_picker_formfield.dart';
import 'package:intl/intl.dart';

import './drawer/schedule_table_drawer.dart';

@immutable
class RelayManualConfigDetailEditor extends StatefulWidget {

  final String initVal;

  RelayManualConfigDetailEditor({this.initVal = "off", Key key}) : super(key: key);

  @override
  RelayManualDetailEditorState createState() => RelayManualDetailEditorState();

}

class RelayManualDetailEditorState extends State<RelayManualConfigDetailEditor> {
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
            val = newState ? "on": "off";
          });
        },
      )
    );
  }
}

@immutable
class RelayAutoConfigDetailEditor extends StatefulWidget {
  final Map<String, dynamic> initVal;

  RelayAutoConfigDetailEditor({this.initVal, Key key}) : super(key: key);

  @override
  RelayAutoConfigDetailEditorState createState() => RelayAutoConfigDetailEditorState();

}

class RelayAutoConfigDetailEditorState extends State<RelayAutoConfigDetailEditor> {
  Map<String, dynamic> _val;
  Map<String, dynamic> get val {
    return {
      "sensor": _val["sensor"],
      "symbol": _val["symbol"],
      "trigger": num.parse(textInput.text)
    };
  }
  TextEditingController textInput = TextEditingController();
  @override
    void initState() {
      if(widget.initVal != null){
        textInput.text = "${widget.initVal["trigger"]}";
        _val = widget.initVal;
      }else{
        _val = Map<String, dynamic>();
      }
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Text("Turn on relay when: "),
          margin: EdgeInsets.symmetric(vertical: 10),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              flex: 1,
              child:
                DropdownButtonHideUnderline(
                  child: new DropdownButton<String>(
                      isExpanded: true,
                      items: ["humidity", "soil", "temp"].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _val["sensor"] = value;
                        });
                      },
                      hint: Text("Sensor"),
                      value: _val["sensor"],
                    ),
                )
              ),
            Expanded(
              flex: 1,
              child:
                DropdownButtonHideUnderline(
                  child:
                    new DropdownButton<String>(
                      isExpanded: true,
                      items: ["<", ">"].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _val["symbol"] = value;
                        });
                      },
                      hint: Text("less / more"),
                      value: _val["symbol"],
                    ),
                )
            ),
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: textInput,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Set point',
                  contentPadding: EdgeInsets.all(5),
                  border: InputBorder.none
                ),
              )
            ),
          ],
        )
      ],
    );
  }
}

@immutable
class RelayScheduledConfigDetailEditor extends StatefulWidget {
  final List<dynamic> initVal;

  RelayScheduledConfigDetailEditor({this.initVal, Key key}) : super(key: key);

  @override
  RelayScheduledConfigDetailEditorState createState() => RelayScheduledConfigDetailEditorState();

}

class RelayScheduledConfigDetailEditorState extends State<RelayScheduledConfigDetailEditor> {
  List<dynamic> schedule;
  List<dynamic> get val {
    return schedule;
  }
  var timeEditorList = <Widget>[];
  @override
    void initState() {
      if(widget.initVal != null){
        schedule = widget.initVal;
      }else{
        schedule = [];
      }
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          height: 0.1 * MediaQuery.of(context).size.height,
          child: CustomPaint(
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
            painter: ScheduleDrawer(hourTickCount: 12, schedule: schedule),
          )
        ),
        Container(
          height: 0.28 * MediaQuery.of(context).size.height,
          child: ListView(
            children: (){
              var timeEditorList = <Widget>[];
              for (int index = 0; index < schedule.length; index++) {
                var timeSlot = schedule[index];
                timeEditorList.add(
                  new Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child:
                          new TimePickerFormField(
                            format: DateFormat("HH:mm"),
                            decoration: InputDecoration(labelText: 'Start'),
                            initialValue: timeSlot["startHour"] == null ? null : TimeOfDay(
                              hour: timeSlot["startHour"],
                              minute: timeSlot["startMin"]
                            ),
                            initialTime: timeSlot["startHour"] == null ? null : TimeOfDay(
                              hour: timeSlot["startHour"],
                              minute: timeSlot["startMin"]
                            ),
                            onChanged: (t) => setState((){
                              if(t != null){
                                timeSlot["startHour"] = t.hour;
                                timeSlot["startMin"] = t.minute;
                              }
                            }),
                          ),
                      ),
                      Expanded(
                        flex: 2,
                        child:
                          new TimePickerFormField(
                            format: DateFormat("HH:mm"),
                            decoration: InputDecoration(labelText: 'End'),
                            initialValue: timeSlot["endHour"] == null ? null : TimeOfDay(
                              hour: timeSlot["endHour"],
                              minute: timeSlot["endMin"]
                            ),
                            initialTime: timeSlot["endHour"] == null ? null : TimeOfDay(
                              hour: timeSlot["endHour"],
                              minute: timeSlot["endMin"]
                            ),
                            onChanged: (t) => setState((){
                              if (t != null) {
                                timeSlot["endHour"] = t.hour;
                                timeSlot["endMin"] = t.minute;
                              }
                            }),
                          ),
                      ),
                    ],
                  )
                );
              }
              return timeEditorList;
            }()
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 85,
              child: MaterialButton(
                textColor: Colors.red,
                onPressed: (){
                  setState(() {
                    schedule.add({});
                  });
                },
                child: Row(
                  children: <Widget>[
                    Text("Add"),
                    Icon(Icons.add)
                  ],
                ),
              ),
            ),
            Container(
              width:110,
              child: MaterialButton(
                textColor: Colors.black,
                onPressed: (){
                  setState(() {
                    schedule.removeLast();
                  });
                },
                child: Row(
                  children: <Widget>[
                    Text("Remove"),
                    Icon(Icons.remove_circle)
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}