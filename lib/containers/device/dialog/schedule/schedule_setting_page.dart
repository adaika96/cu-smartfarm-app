import 'package:flutter/material.dart';
import '../relay_config_detail_editor.dart';

class ScheduleEditPage extends StatefulWidget {
  final bool initRepeat;
  final List<dynamic> initSchedule;

  ScheduleEditPage({Map<String, dynamic> initVal, Key key})
      : initRepeat = (initVal == null) ? false : (initVal["repeat"] ?? false),
        initSchedule = (initVal == null) ?  [] : (initVal["schedules"] ?? []),
        super(key: key);
  // ScheduleEditPage({Key key}) : super(key: key); // Constructor

  @override
  _ScheduleEditPage createState() => new _ScheduleEditPage();
}

@immutable
class _ScheduleEditPage extends State<ScheduleEditPage> {
  bool repeat;
  GlobalKey<RelayScheduledConfigDetailEditorState> _scheduleEditorKey =
      new GlobalKey<RelayScheduledConfigDetailEditorState>();
  @override
    void initState() {
      repeat = widget.initRepeat;
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Schedule Edit'),
        ),
        body: Center(
            child: Container(
                width: 0.9 * MediaQuery.of(context).size.width,
                child: ListView(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("Repeat everyday"),
                        Switch(
                          value: repeat,
                          onChanged: (newState) {
                            setState((){
                              repeat = newState;
                            });
                          },
                        ),
                      ],
                    ),
                    Container(
                        height: 0.45 * MediaQuery.of(context).size.height,
                        margin: EdgeInsets.symmetric(
                            vertical:
                                0.05 * MediaQuery.of(context).size.height),
                        child: RelayScheduledConfigDetailEditor(key: _scheduleEditorKey, initVal: widget.initSchedule)),
                    MaterialButton(
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop({
                          "repeat": repeat,
                          "schedules": _scheduleEditorKey.currentState.val
                        });
                      },
                    )
                  ],
                ))));
  }
}
