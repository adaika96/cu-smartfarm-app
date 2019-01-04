// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:meta/meta.dart';
import './user_session.dart';

@immutable
class AppState {
  final UserSession userSession;
  final String wsToken;
  final String errmsg;
  final List<String> devices;

  AppState({
    this.userSession = const UserSession(),
    this.wsToken = "",
    this.errmsg = "",
    this.devices = const []
  });

  AppState copyWith({
    UserSession userSession,
    String wsToken,
    List<String> devices,
    String errmsg
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
