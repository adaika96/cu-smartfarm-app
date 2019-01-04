import 'package:redux/redux.dart';
import '../../actions/users.dart';

final errmsgReducer = combineReducers<String>([
  TypedReducer<String, QueryDeviceFailureAction>(_setDevicesErrMsg),
]);

String _setDevicesErrMsg(String state, dynamic action) {
  try {
    return action.errmsg;
  } catch (e) {
    return "Some error occured";
  }
}
