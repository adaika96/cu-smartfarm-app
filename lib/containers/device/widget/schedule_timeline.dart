import 'package:flutter/material.dart';
import './drawer/schedule_table_drawer.dart';

String getDateTimeFromMinutes(int minutes) {
  int _hours = minutes ~/ 60;
  int _minutes = minutes % 60;
  return "${_hours < 10 ? 0 : ""}${_hours.toInt()}:${_minutes < 10 ? 0 : ""}${_minutes.toInt()}";
}

List<int> getRangeMinute(List<dynamic> schedule) {
  var minutes = <int>[0, 1440];
  for (var timeSlot in schedule) {
    if (timeSlot["startHour"] != null && timeSlot["startMin"] != null) {
      minutes[0] = timeSlot["startHour"] * 60;
      break;
    }
  }
  for (var i = schedule.length - 1; i >= 0; i--) {
    if (schedule[i]["endHour"] != null && schedule[i]["endMin"] != null) {
      minutes[1] =
          (schedule[i]["endHour"] + (schedule[i]["endMin"] / 60).ceil()) * 60;
      break;
    }
  }
  return minutes;
}

@immutable
class ScheduleTimeline extends StatelessWidget {
  final List<dynamic> schedule;

  ScheduleTimeline({List<dynamic> schedule}) : this.schedule = schedule {
    this.schedule.sort((a, b) {
      if (a["startHour"] == null || b["startHour"] == null) {
        return -1;
      }
      return a["startHour"].compareTo(b["startHour"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    var x = getRangeMinute(this.schedule);
    int startRange = x.first;
    int endRange = x.last;
    return CustomPaint(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: () {
            var slotLength = 5 * ((endRange - startRange) / 60).ceil();
            var hourTickPoint = <Widget>[];
            List.generate(12, (i) => (i + 1)).forEach((index) {
              var _minutes = startRange + slotLength * index;
              hourTickPoint.add(Expanded(
                child: Text(
                  getDateTimeFromMinutes(_minutes.ceil()),
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.white, fontSize: 7),
                ),
              ));
            });
            return hourTickPoint;
          }()),
      painter: ScheduleDrawer(
          hourTickCount: 12,
          schedule: this.schedule,
          range: <int>[startRange, endRange]),
    );
  }
}
