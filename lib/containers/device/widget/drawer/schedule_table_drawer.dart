import 'package:flutter/material.dart';

class ScheduleDrawer extends CustomPainter {
  final int hourTickCount;
  final List<dynamic> schedule;
  final int startRange, endRange, rangeWidth;
  //final List<List<num>> scheduled;

  ScheduleDrawer({this.hourTickCount, this.schedule, List<int> range})
      : this.startRange = range.first,
        this.endRange = range.last,
        this.rangeWidth = range.last - range.first;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)),
        new Paint()..color = Colors.black);
    for (var i = 1; i < hourTickCount + 1; i++) {
      canvas.drawRect(
          Rect.fromPoints(Offset(i * (size.width / hourTickCount), 0),
              Offset(i * (size.width / hourTickCount) + 1, 0.7 * size.height)),
          new Paint()..color = Colors.white);
    }
    for (var timeSlot in schedule) {
      if (timeSlot["startHour"] == null || timeSlot["endHour"] == null) {
        continue;
      }
      //1440
      int _startMins = timeSlot["startHour"] * 60 + timeSlot["startMin"];
      int _endMins = timeSlot["endHour"] * 60 + timeSlot["endMin"];

      _startMins -= this.startRange;
      _endMins -= this.startRange;

      canvas.drawRect(
          Rect.fromPoints(
              Offset(_startMins * (size.width / this.rangeWidth), 0.5 * size.height),
              Offset(_endMins * (size.width / this.rangeWidth), 0.5 * size.height + 1)),
          new Paint()..color = Colors.red);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
