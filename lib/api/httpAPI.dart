library cu_smartfarm_app.httpapi;

import 'package:http/http.dart' as http;

import '../const.dart' as constants;


Future<http.Response> RegistrationAPI(Map<String, String> args) {
  return http.post("http://${constants.ServerIP}/api/v1/register",body: args);
}

Future<http.Response> LoginAPI(Map<String, String> args) {
  return http.post("http://${constants.ServerIP}/api/v1/login",body: args);
}
