import 'package:meta/meta.dart';

import './user_session.dart';
import './device_info.dart';
import './device/device_controller.dart';

@immutable
class AppState {
  final UserSession userSession;
  final DeviceController devController;
  final String errmsg;
  final OwnedDevice devices;

  AppState({
    this.userSession = const UserSession(),
    this.devController = null,
    this.errmsg = "",
    this.devices = const OwnedDevice(),
  });

  AppState copyWith({
    UserSession userSession,
    DeviceController devController,
    String errmsg,
    OwnedDevice devices
  }) {
    return AppState(
      userSession: userSession ?? this.userSession,
      devController: devController ?? this.devController,
      devices: devices ?? this.devices,
      errmsg: errmsg ?? this.errmsg,
    );
  }

  @override
  int get hashCode =>
      userSession.hashCode ^ devController.hashCode ^ devices.hashCode ^ errmsg.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          userSession == other.userSession &&
          devController == other.devController &&
          errmsg == other.errmsg &&
          devices == other.devices;

  @override
  String toString() {
    return 'AppState{UserSession: $userSession, devices: $devices, errmsg: $errmsg}';
  }
}
