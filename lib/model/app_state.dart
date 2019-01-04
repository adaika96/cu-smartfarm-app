import 'package:meta/meta.dart';

import './user_session.dart';
import './device_info.dart';

@immutable
class AppState {
  final UserSession userSession;
  final String wsToken;
  final String errmsg;
  final OwnedDevice devices;

  AppState({
    this.userSession = const UserSession(),
    this.wsToken = "",
    this.errmsg = "",
    this.devices = const OwnedDevice(),
  });

  AppState copyWith({
    UserSession userSession,
    String wsToken,
    String errmsg,
    OwnedDevice devices
  }) {
    return AppState(
      userSession: userSession ?? this.userSession,
      wsToken: wsToken ?? this.wsToken,
      devices: devices ?? this.devices,
      errmsg: errmsg ?? this.errmsg,
    );
  }

  @override
  int get hashCode =>
      userSession.hashCode ^ wsToken.hashCode ^ devices.hashCode ^ errmsg.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          userSession == other.userSession &&
          wsToken == other.wsToken &&
          errmsg == other.errmsg &&
          devices == other.devices;

  @override
  String toString() {
    return 'AppState{UserSession: $userSession, devices: $devices, errmsg: $errmsg}';
  }
}
