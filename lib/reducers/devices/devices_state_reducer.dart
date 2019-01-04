import '../../model/device_info.dart';
import './devices_isLoading_state.dart';
import './devices_errmsg_reducer.dart';
import './devices_list_reducer.dart';

// We create the Devices reducer to devide fucking big reducer into many smaller reducers!
OwnedDevice devicesReducer(OwnedDevice state, action) {
  return new OwnedDevice(
    isLoading: isLoadingDevicesReducer(state.isLoading, action),
    errmsg: errmsgReducer(state.errmsg, action),
    devices: devicesListReducer(state.devices, action)
  );
}
