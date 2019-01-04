import 'package:meta/meta.dart';

@immutable
class UserSession {
  final String httpToken;
  final String username;
  final String loginStatus;
  final String errmsg;

  const UserSession({
    this.httpToken = "",
    this.username = "",
    this.loginStatus = "",
    this.errmsg = ""
  });

  @override
  int get hashCode =>
      httpToken.hashCode ^
      loginStatus.hashCode ^
      username.hashCode ^
      errmsg.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSession &&
          runtimeType == other.runtimeType &&
          httpToken == other.httpToken &&
          loginStatus == other.loginStatus &&
          username == other.username &&
          errmsg == other.errmsg;

  @override
  String toString() {
    return """UserSession{
      username: $username,
      loginStatus: $loginStatus,
      token: $httpToken,
      errmsg: $errmsg
    }
    """;
  }
}
