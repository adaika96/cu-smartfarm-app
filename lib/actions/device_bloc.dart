import 'package:meta/meta.dart';

class ReceivedDeviceRelaysConfig {
  final String jsonState;

  ReceivedDeviceRelaysConfig({this.jsonState});
}

class SetDeviceRelaysConfig {
  final int relayIndex;
  final String mode;
  final dynamic detail;

  SetDeviceRelaysConfig(
    this.relayIndex,
    {
      this.mode = "manual",
      detail,
    }
  ) : this.detail =
  (detail != null) ? detail :
  (mode == "auto") ? { "sensor":"temp", "trigger": 0, "symbol": ">" }:
  (mode == "scheduled") ? [] : "off"{
    print(mode);
  }

  factory SetDeviceRelaysConfig.Safe(int relayIndex, {@required String mode, @required dynamic detail}){
    switch (mode) {
      case "manual":
        if(["on", "off"].contains(detail))
          return new SetDeviceRelaysConfig(relayIndex, mode: mode, detail: detail);
        return null;
      case "auto":
        if (detail["sensor"] != null && detail["trigger"] != null && detail["symbol"] != null)
          return new SetDeviceRelaysConfig(relayIndex, mode: mode, detail: detail);
        return null;
      case "scheduled":
        if(detail["repeat"] is bool && (detail["schedules"] as List<dynamic>).length > 0)
          return new SetDeviceRelaysConfig(relayIndex, mode: mode, detail: detail);
        return null;
      default:
        return null;
    }
  }
  @override
    String toString() => 'AppState{relayIndex: $relayIndex, mode: $mode, detail: $detail}';
}