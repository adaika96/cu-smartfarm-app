import 'package:redux/redux.dart';
import '../actions/users.dart';
import '../model/device/device_controller.dart';
import '../model/app_state.dart';

final devControllerReducer = combineReducers<DeviceController>([
  TypedReducer<DeviceController, NewDevController>(_newDevController),
]);

DeviceController _newDevController(DeviceController state, NewDevController action) {
  if(state != null){
    state.disconnect();
  }
  return new DeviceController(
    action.devices,
    action.token
  );
}
