import 'package:redux/redux.dart';
import '../actions/users.dart';
import '../model/ws.dart';
import '../model/app_state.dart';

final wsAPIReducer = combineReducers<WebSocketAPIConnection>([
  TypedReducer<WebSocketAPIConnection, NewWebSocketConnection>(_newwsAPI),
]);

WebSocketAPIConnection _newwsAPI(WebSocketAPIConnection state, NewWebSocketConnection action) {
  if(state != null){
    state.disconnect();
  }
  return new WebSocketAPIConnection(
    action.devices,
    action.token
  );
}
