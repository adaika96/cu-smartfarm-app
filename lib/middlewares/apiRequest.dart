import 'package:redux_epics/redux_epics.dart';
import 'dart:convert';

import '../model/app_state.dart';
import '../actions/users.dart';
import '../api/httpAPI.dart';

Stream<dynamic> Login(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions.where((action) => action is LoginPendingAction).asyncMap(
      (action) =>
          LoginAPI({"username": action.username, "password": action.password}).then((resp) {
            Map<String, dynamic> result = jsonDecode(resp.body);
            if (resp.statusCode == 200) {
              return LoginSuccessAction(
                  result["token"] as String, action.username);
            } else {
              return LoginFailureAction(result['message'] as String);
            }
        }).catchError((error) {
          return LoginFailureAction(error.toString());
        }));
}

final ApiRequestMiddleware =
    new EpicMiddleware(combineEpics<AppState>([Login]));
