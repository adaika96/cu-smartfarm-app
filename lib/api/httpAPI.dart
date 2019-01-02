library cu_smartfarm_app.httpapi;

import '../const.dart' as constants;
import 'package:http/http.dart' as http;

Future<http.Response> Registration(Map<String, String> args) {
  return http.post("http://${constants.ServerIP}/api/v1/register",body: args);
}