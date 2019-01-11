library cu_smartfarm_app.httpapi;

import 'package:http/http.dart' as http;
import 'dart:convert';


import '../actions/device_bloc.dart';
import '../const.dart' as constants;

// {
// 	"deviceID":/* HERE */,
// 	"param":{
//  /* HERE */
//  }
// }

Future<http.Response> RegistrationAPI(Map<String, String> args) {
  return http.post("http://${constants.ServerIP}/api/v1/register", body: args);
}

Future<http.Response> LoginAPI(Map<String, String> args) {
  return http.post("http://${constants.ServerIP}/api/v1/login", body: args);
}

Future<http.Response> CheckTokenAPI(String token) {
  return http.get("http://${constants.ServerIP}/api/v1/user/checkStatus",
      headers: {"Authorization": "Bearer " + token});
}

Future<http.Response> GetDeviceAPI(String token) {
  return http.get("http://${constants.ServerIP}/api/v1/user/myDevices",
      headers: {"Authorization": "Bearer " + token});
}

Future<http.Response> AddDeviceAPI(String token, Map<String, String> param) {
  return http
      .post("http://${constants.ServerIP}/api/v1/user/addDevice", headers: {
    "Authorization": "Bearer " + token
  }, body: {
    "payload": jsonEncode({
      "deviceID": param["id"],
      "param": {"deviceSecret": param["secret"], "deviceName": param["name"]}
    })
  });
}

Future<http.Response> RemoveDeviceAPI(String token, String deviceID) {
  return http
      .post("http://${constants.ServerIP}/api/v1/user/removeDevice", headers: {
    "Authorization": "Bearer " + token
  }, body: {
    "payload": jsonEncode({
      "deviceID": deviceID,
    })
  });
}

Future<http.Response> RenameDeviceAPI(String token, Map<String, String> param) {
  return http
      .post("http://${constants.ServerIP}/api/v1/user/renameDevice", headers: {
    "Authorization": "Bearer " + token
  }, body: {
    "payload": jsonEncode({
      "deviceID": param["id"],
      "param": {"name": param["name"]}
    })
  });
}

Future<http.Response> GetDeviceRelayAPI(String token, String deviceID) {
  return http
      .post("http://${constants.ServerIP}/api/v1/user/getDeviceInfo", headers: {
    "Authorization": "Bearer " + token
  }, body: {
    "payload": jsonEncode({
      "deviceID": deviceID,
    })
  });
}

Future<http.Response> SetDeviceRelayAPI(String token, String deviceID, SetDeviceRelaysConfig config) {
  return http
      .post("http://${constants.ServerIP}/api/v1/user/setDevice", headers: {
    "Authorization": "Bearer " + token
  }, body: {
    "payload": jsonEncode({
      "deviceID": deviceID,
      "param": {
        "relayID": "Relay${config.relayIndex + 1}",
        "state": {"mode": config.mode, "detail": config.detail}
      }
    })
  });
}

Future<http.Response> GetDeviceSensorLog(String token, String deviceID) {
  return http
      .post("http://${constants.ServerIP}/api/v1/user/getDeviceLog", headers: {
    "Authorization": "Bearer " + token
  }, body: {
    "payload": jsonEncode({
      "deviceID": deviceID,
      "param": {
        "limit": 1000
      }
    })
  });
}
