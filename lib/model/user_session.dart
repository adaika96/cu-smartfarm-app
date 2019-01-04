// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:meta/meta.dart';

@immutable
class UserSession {
  final String httpToken;
  final String username;
  final String loginStatus;

  const UserSession({
    this.httpToken = "",
    this.username = "",
    this.loginStatus = ""
  });

  @override
  int get hashCode =>
      httpToken.hashCode ^
      loginStatus.hashCode ^
      username.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSession &&
          runtimeType == other.runtimeType &&
          httpToken == other.httpToken &&
          loginStatus == other.loginStatus &&
          username == other.username;

  @override
  String toString() {
    return 'UserSession{username: $username, loginStatus: $loginStatus}';
  }
}
