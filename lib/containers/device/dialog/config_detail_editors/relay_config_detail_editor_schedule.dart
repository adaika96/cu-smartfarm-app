import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/time_picker_formfield.dart';
import 'package:intl/intl.dart';
import '../../widget/schedule_timeline.dart';

getMin(h, m) => (60 * h + m);

@immutable
class RelayScheduledConfigDetailEditor extends StatefulWidget {
  final List<dynamic> initVal;

  RelayScheduledConfigDetailEditor({this.initVal, Key key}) : super(key: key);

  @override
  RelayScheduledConfigDetailEditorState createState() =>
      RelayScheduledConfigDetailEditorState();
}

class RelayScheduledConfigDetailEditorState
    extends State<RelayScheduledConfigDetailEditor> {
  List<dynamic> schedule;
  List<dynamic> get val {
    var sh = "startHour", sm = "startMin", eh = "endHour", em = "endMin";
    var cts = schedule
        .where((ts) =>
            ts != null &&
            ts.containsKey(sh) &&
            ts.containsKey(sm) &&
            ts.containsKey(eh) &&
            ts.containsKey(em) &&
            getMin(ts[sh], ts[sh]) < getMin(ts[eh], ts[em]))
        .toList();

    cts.sort((a, b) =>
        (a[sh] == null || b[sh] == null) ? -1 : a[sh].compareTo(b[sh]));

    return cts.length > 0
        ? cts.asMap().keys.skip(1).fold(<dynamic>[cts[0]], (cps, i) {
            var ctsi = cts[i], _cts = cts[i - 1];
            return getMin(ctsi[sh], ctsi[sm]) < getMin(_cts[eh], _cts[em])
                ? cps.take(cps.length - 1).toList() +
                    [
                      {
                        sh: _cts[sh],
                        sm: _cts[sm],
                        eh: ctsi[eh],
                        em: ctsi[em],
                      }
                    ]
                : cps + [ctsi];
          })
        : [];
  }

  var timeEditorList = <Widget>[];
  @override
  void initState() {
    if (widget.initVal != null) {
      schedule = widget.initVal;
    } else {
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
            child: ScheduleTimeline(
              schedule: this.val,
            )),
        Container(
          height: 0.28 * MediaQuery.of(context).size.height,
          child: ListView(children: () {
            var timeEditorList = <Widget>[];
            for (int index = 0; index < schedule.length; index++) {
              var timeSlot = schedule[index];
              timeEditorList.add(new Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: new TimePickerFormField(
                      format: DateFormat("HH:mm"),
                      decoration: InputDecoration(labelText: 'Start'),
                      initialValue: timeSlot["startHour"] == null
                          ? null
                          : TimeOfDay(
                              hour: timeSlot["startHour"],
                              minute: timeSlot["startMin"]),
                      initialTime: timeSlot["startHour"] == null
                          ? null
                          : TimeOfDay(
                              hour: timeSlot["startHour"],
                              minute: timeSlot["startMin"]),
                      onChanged: (t) => setState(() {
                            if (t != null) {
                              timeSlot["startHour"] = t.hour;
                              timeSlot["startMin"] = t.minute;
                            }
                          }),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: new TimePickerFormField(
                      format: DateFormat("HH:mm"),
                      decoration: InputDecoration(labelText: 'End'),
                      initialValue: timeSlot["endHour"] == null
                          ? null
                          : TimeOfDay(
                              hour: timeSlot["endHour"],
                              minute: timeSlot["endMin"]),
                      initialTime: timeSlot["endHour"] == null
                          ? null
                          : TimeOfDay(
                              hour: timeSlot["endHour"],
                              minute: timeSlot["endMin"]),
                      onChanged: (t) => setState(() {
                            if (t != null) {
                              timeSlot["endHour"] = t.hour;
                              timeSlot["endMin"] = t.minute;
                            }
                          }),
                    ),
                  ),
                ],
              ));
            }
            return timeEditorList;
          }()),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 85,
              child: MaterialButton(
                textColor: Colors.red,
                onPressed: () {
                  setState(() {
                    var sh = "startHour",
                        sm = "startMin",
                        eh = "endHour",
                        em = "endMin";
                    if (schedule
                            .where((ts) =>
                                ts == null ||
                                !ts.containsKey(sh) ||
                                !ts.containsKey(sm) ||
                                !ts.containsKey(eh) ||
                                !ts.containsKey(em))
                            .length ==
                        0) schedule.add({});
                  });
                },
                child: Row(
                  children: <Widget>[Text("Add"), Icon(Icons.add)],
                ),
              ),
            ),
            Container(
              width: 110,
              child: MaterialButton(
                textColor: Colors.black,
                onPressed: () {
                  setState(() {
                    schedule.removeLast();
                  });
                },
                child: Row(
                  children: <Widget>[Text("Remove"), Icon(Icons.remove_circle)],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
