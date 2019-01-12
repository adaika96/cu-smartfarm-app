import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../../actions/device_bloc.dart';

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
      val = widget.initVal;
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
  final Map<String, dynamic> initVal;

  RelayScheduledConfigDetailEditor({this.initVal, Key key}) : super(key: key);

  @override
  RelayScheduledConfigDetailEditorState createState() => RelayScheduledConfigDetailEditorState();

}

class RelayScheduledConfigDetailEditorState extends State<RelayScheduledConfigDetailEditor> {
  List<Map<String, int>> schedule = [
    {
      "startHour": 8,
      "startMin": 0,
      "endHour": 9,
      "endMin": 0,
    },
    {
      "startHour": 9,
      "startMin": 30,
      "endHour": 10,
      "endMin": 0,
    },
    {
      "startHour": 11,
      "startMin": 30,
      "endHour": 13,
      "endMin": 30,
    },
    {
      "startHour": 15,
      "startMin": 0,
      "endHour": 17,
      "endMin": 0,
    }
  ];
  charts.Series relayStates;
  Map<String, dynamic> get val {
    return {
      "repeat": true,
      "timeslots": [
        {
          "startHour": 8,
          "startMin": 0,
          "endHour": 9,
          "endMin": 0,
        }
      ]
    };
  }
  TextEditingController textInput = TextEditingController();
  List _expandSchdule(List<Map<String, int>> schedule){
    List unRolled = schedule.fold([], (unRolling, timeslot){
      int startMinuteSum = timeslot["startHour"] * 60 + timeslot["startMin"] - 1;
      int endMinuteSum = timeslot["endHour"] * 60 + timeslot["endMin"] + 1;
      return unRolling + [
        [startMinuteSum ~/ 60, startMinuteSum % 60, 0],
        [timeslot["startHour"], timeslot["startMin"], 1],
        [timeslot["endHour"], timeslot["endMin"], 1],
        [endMinuteSum ~/ 60, endMinuteSum % 60, 0],
      ];
    });
    unRolled.insert(0, [0, 0, 0]);
    unRolled.add([23, 59, 0]);
    return unRolled;
  }
  @override
    void initState() {
      var stateTimeline = _expandSchdule(schedule);
      relayStates =  new charts.Series<dynamic, DateTime>(
        id: 'Relay State',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (dynamic timepoint, _) {
          DateTime now = DateTime.now();
          return DateTime(now.year, now.month, now.day, timepoint[0], timepoint[1]);
        },
        measureFn: (dynamic timepoint, _) => timepoint[2],
        data: stateTimeline
      );
      if(widget.initVal != null){
      }else{
      }
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 0.2 * MediaQuery.of(context).size.height,
          child: charts.TimeSeriesChart(
            [relayStates],
            animate: false,
            domainAxis:  new charts.DateTimeAxisSpec(
              tickFormatterSpec:
                new charts.AutoDateTimeTickFormatterSpec(
                  minute: new charts.TimeFormatterSpec(
                    format: 'hh:mm', transitionFormat: 'hh:mm'
                  )
                )
              ),
          ),
        )
      ],
    );
  }
}