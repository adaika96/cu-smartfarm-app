import 'package:meta/meta.dart';

import './user_session.dart';
import './device_info.dart';
import './ws.dart';

@immutable
class AppState {
  final UserSession userSession;
  final WebSocketAPIConnection wsAPI;
  final String errmsg;
  final OwnedDevice devices;

  AppState({
    this.userSession = const UserSession(),
    this.wsAPI = null,
    this.errmsg = "",
    this.devices = const OwnedDevice(),
  });

  AppState copyWith({
    UserSession userSession,
    WebSocketAPIConnection wsAPI,
    String errmsg,
    OwnedDevice devices
  }) {
    return AppState(
      userSession: userSession ?? this.userSession,
      wsAPI: wsAPI ?? this.wsAPI,
      devices: devices ?? this.devices,
      errmsg: errmsg ?? this.errmsg,
    );
  }

  @override
  int get hashCode =>
      userSession.hashCode ^ wsAPI.hashCode ^ devices.hashCode ^ errmsg.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          userSession == other.userSession &&
          wsAPI == other.wsAPI &&
          errmsg == other.errmsg &&
          devices == other.devices;

  @override
  String toString() {
    return 'AppState{UserSession: $userSession, devices: $devices, errmsg: $errmsg}';
  }
}
