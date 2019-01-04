import 'package:redux/redux.dart';
import '../../actions/users.dart';
import '../../model/device_info.dart';

final devicesListReducer = combineReducers<List<DeviceShortInfo>>([
  TypedReducer<List<DeviceShortInfo>, QueryDeviceSuccessAction>(_setDeviceList),
]);

List<DeviceShortInfo> _setDeviceList(List<DeviceShortInfo> state, QueryDeviceSuccessAction action){
  return action.devices;
}