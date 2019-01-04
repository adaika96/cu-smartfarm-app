import '../model/app_state.dart';
import './user_session_reducer.dart';
import './errmsg_reducer.dart';

// We create the State reducer by combining many smaller reducers into one!
AppState appReducer(AppState state, action) {
  print(action);
  return new AppState(
    userSession: userReducer(state.userSession, action),
    errmsg: errmsgReducer(state.errmsg, action),
  );
}
