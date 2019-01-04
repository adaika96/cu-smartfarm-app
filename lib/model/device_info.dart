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

  const OwnedDevice({
    this.isLoading = true,
    this.errmsg = "",
    this.devices = const []
  });


  @override
  int get hashCode =>
      isLoading.hashCode ^ devices.hashCode ^ errmsg.hashCode;

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
