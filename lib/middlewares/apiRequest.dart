import 'package:redux_epics/redux_epics.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

import '../model/app_state.dart';
import '../actions/users.dart';
import '../api/httpAPI.dart';

Stream<dynamic> CheckIsExistingTokenExpired(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
      .where((action) => action is CheckIsTokenExpired)
      .asyncMap((action) async {
    final tokenFile =
        File('${(await getApplicationDocumentsDirectory()).path}/.token');
    if (await tokenFile.exists()) {
      print("toke");
      final token = tokenFile.readAsStringSync();
      try {
        final resp = await CheckTokenAPI(token);
        Map<String, dynamic> result = jsonDecode(resp.body);
        if (resp.statusCode == 200) {
          return LoginSuccessAction(token, result["username"]);
        }
      } catch (_) {}
    }
  });
}

Stream<dynamic> Login(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions.where((action) => action is LoginPendingAction).asyncMap(
      (action) =>
          LoginAPI({"username": action.username, "password": action.password})
              .then((resp) async {
            Map<String, dynamic> result = jsonDecode(resp.body);
            if (resp.statusCode == 200) {
              final tokenFile = File(
                  '${(await getApplicationDocumentsDirectory()).path}/.token');
              tokenFile.writeAsString(result["token"] as String);

              return LoginSuccessAction(
                  result["token"] as String, action.username);
            }
            return LoginFailureAction(result['message']);
          }).catchError((error) {
            return LoginFailureAction(error.toString());
          }));
}

Stream<dynamic> GetDevice(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions.where((action) => action is QueryDevicePendingAction).asyncMap(
      (action) => GetDeviceAPI(store.state.userSession.httpToken).then((resp) {
            Map<String, dynamic> result = jsonDecode(resp.body);
            if (resp.statusCode == 200) {
              return QueryDeviceSuccessAction.From(result["data"]);
            }
            return QueryDeviceFailureAction(result["message"]);
          }).catchError((error) {
            return QueryDeviceFailureAction(error.toString());
          }));
}

Stream<dynamic> CreateWSConn(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions.where((action) => action is EnsureSocketConnection).map(
      (action) {
        print("eiei");
        return NewWebSocketConnection(
          devices: store.state.devices.devices.map((dev) => (dev.id)).toList(),
          token: store.state.userSession.httpToken);
        }
      );
}

final ApiRequestMiddleware = new EpicMiddleware(
    combineEpics<AppState>([Login, GetDevice, CheckIsExistingTokenExpired, CreateWSConn]));
