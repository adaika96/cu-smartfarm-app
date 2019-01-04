class LoginPendingAction {
  final String username;
  final String password;

  LoginPendingAction(this.username, this.password);
}

// class LoginPendingAction{}

class LoginSuccessAction {
  final String token;
  final String username;

  LoginSuccessAction(this.token, this.username);
}

class LoginFailureAction {
  final String errmsg;

  LoginFailureAction(this.errmsg);
}

class QueryDeviceAction {}

class ReceivedDeviceAction {
  final List<String> devices;

  ReceivedDeviceAction(this.devices);
}