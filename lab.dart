void main(List<String> args) {
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
  print("" ?? "folder");
  // print(List<num>.generate(5, (i) => (i)));
}