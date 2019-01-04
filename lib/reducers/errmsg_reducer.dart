import 'package:redux/redux.dart';
import '../actions/users.dart';
import '../model/user_session.dart';

final errmsgReducer = combineReducers<String>([
  TypedReducer<String, LoginFailureAction>(_setErrMsgWhenLoginFailureState),
]);

String _setErrMsgWhenLoginFailureState(String state, LoginFailureAction action) {
  return action.errmsg;
}