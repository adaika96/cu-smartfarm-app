import 'package:redux_epics/redux_epics.dart';
import 'dart:convert';

import '../model/app_state.dart';
import '../actions/users.dart';
import '../api/httpAPI.dart';

Stream<dynamic> Login(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions.where((action) => action is LoginPendingAction).asyncMap(
      (action) =>
          LoginAPI({"username": action.username, "password": action.password})
              .then((resp) {
            Map<String, dynamic> result = jsonDecode(resp.body);
            if (resp.statusCode == 200) {
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

final ApiRequestMiddleware =
    new EpicMiddleware(combineEpics<AppState>([Login, GetDevice]));
