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
      "param": {"deviceSecret": param["secret"], "deviceName": param["name"], "deviceDesc":""}
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
      .post("http://${constants.ServerIP}/api/v1/user/editDevice", headers: {
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
      .post("http://${constants.ServerIP}/api/v1/user/setRelay", headers: {
    "Authorization": "Bearer " + token
  }, body: {
    "payload": jsonEncode({
      "deviceID": deviceID,
      "param": {
        "relayID": "Relay${config.relayIndex + 1}",
        "state": {"mode": config.mode, "detail": config.detail}
      }
    })
  }).then((resp){
    print("Response >> ${resp.body}");
  });
}

Future<http.Response> GetDeviceSensorLog(String token, String deviceID, int limit) {
  return http
      .post("http://${constants.ServerIP}/api/v1/user/getDeviceLog", headers: {
    "Authorization": "Bearer " + token
  }, body: {
    "payload": jsonEncode({
      "deviceID": deviceID,
      "param": {
        "limit": limit
      }
    })
  });
}

Future<http.Response> SetRelayDescAPI(String token, String deviceID, int relayIndex, String desc) {
  return http.post("http://${constants.ServerIP}/api/v1/user/setRelayName", headers: {
    "Authorization": "Bearer " + token
  }, body: {
    "payload": jsonEncode({
      "deviceID": deviceID,
      "param": {
        "relayID": "Relay${relayIndex + 1}",
        "desc": desc
      }
    })
  });
}

Future<http.Response> GetRelayDescAPI(String token, String deviceID) {
  return http.post("http://${constants.ServerIP}/api/v1/user/getRelayNames", headers: {
    "Authorization": "Bearer " + token
  }, body: {
    "payload": jsonEncode({
      "deviceID": deviceID
    })
  });
}