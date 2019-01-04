import '../model/device_info.dart';
import 'dart:convert';
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

class QueryDevicePendingAction {}

class QueryDeviceSuccessAction {
  final List<DeviceShortInfo> devices;

  QueryDeviceSuccessAction({this.devices});

  factory QueryDeviceSuccessAction.From(List<dynamic> deviceResponse) {
    List<DeviceShortInfo> devices = [];
    for (var devInfo in deviceResponse) {
      Map<String, dynamic> mappedDevInfo = jsonDecode(jsonEncode(devInfo));
      devices.add(DeviceShortInfo(id: mappedDevInfo["deviceID"], name: mappedDevInfo["name"]));
    }
    return QueryDeviceSuccessAction(devices: devices);
  }
}

class QueryDeviceFailureAction {
  final String errmsg;

  QueryDeviceFailureAction(this.errmsg);
}
