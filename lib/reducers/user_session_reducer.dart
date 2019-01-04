import 'package:redux/redux.dart';
import '../actions/users.dart';
import '../model/user_session.dart';

final userReducer = combineReducers<UserSession>([
  TypedReducer<UserSession, LoginSuccessAction>(_loginSuccessState),
  TypedReducer<UserSession, LoginPendingAction>(_loginPendingState),
  TypedReducer<UserSession, LoginFailureAction>(_loginFailureState),
]);

UserSession _loginSuccessState(UserSession state, LoginSuccessAction action) {
  return UserSession(httpToken: action.token, username: action.username, loginStatus: "success");
}

UserSession _loginPendingState(UserSession state, LoginPendingAction action) {
  return UserSession(loginStatus: "pending");
}

UserSession _loginFailureState(UserSession state, LoginFailureAction action) {
  return UserSession(loginStatus: "failure", errmsg: action.errmsg);
}