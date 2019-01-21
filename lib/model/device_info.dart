import 'package:meta/meta.dart';

@immutable
class DeviceShortInfo {
  final String name;
  final String id;

  DeviceShortInfo({this.name, this.id});

  @override
  String toString() {
    return '_DeviceShortInfo{name: $name, deviceID: $id}';
  }
}

@immutable
class OwnedDevice {
  final bool isLoading;
  final String errmsg;
  final List<DeviceShortInfo> devices;

  const OwnedDevice(
      {this.isLoading = true, this.errmsg = "", this.devices = const []});

  @override
  int get hashCode => isLoading.hashCode ^ devices.hashCode ^ errmsg.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OwnedDevice &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          errmsg == other.errmsg &&
          devices == other.devices;

  @override
  String toString() {
    return 'OwnedDevice{isLoading: $isLoading, devices: $devices, errmsg : $errmsg}';
  }
}

@immutable
class DeviceState {
  final num soil;
  final num humidity;
  final num temp;
  final List<bool> relayStates;
  final List<String> relayDesc;

  const DeviceState(
      {@required this.soil,
      @required this.humidity,
      @required this.temp,
      @required this.relayStates,
      @required this.relayDesc});

  factory DeviceState.FromMap(Map<String, dynamic> state,
      {List<String> relayDesc}) {
    List<bool> relayStates = List();
    for (var i = 1; i <= 5; i++) {
      relayStates.add(state["Relay$i"] == "on");
    }
    return DeviceState(
        soil: state["Soil"],
        humidity: state["Humidity"],
        temp: state["Temp"],
        relayStates: relayStates,
        relayDesc: relayDesc ?? ["", "", "", "", ""]);
  }

  DeviceState changeRelayDesc({List<String> newRelayDesc}) {
    return DeviceState(
        soil: soil,
        humidity: humidity,
        temp: temp,
        relayStates: relayStates,
        relayDesc: newRelayDesc);
  }

  @override
  int get hashCode =>
      soil.hashCode ^ humidity.hashCode ^ temp.hashCode ^ relayStates.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceState &&
          runtimeType == other.runtimeType &&
          soil == other.soil &&
          humidity == other.humidity &&
          temp == other.temp &&
          relayStates == other.relayStates;

  @override
  String toString() =>
      'AppState{Soil: $soil, Humid: $humidity, temp: $temp, relayStates: $relayStates}';
}
