import 'package:bloc/bloc.dart';
import 'dart:convert';

import '../../../actions/device_bloc.dart';
import '../../../model/device/device_relay_config_state.dart';
import '../../../api/httpAPI.dart' as httpapi;

class DeviceRelayConfigBLoC extends Bloc<dynamic, DeviceRelaysConfig> {
  final String deviceID;
  final String httpToken;

  DeviceRelayConfigBLoC({this.deviceID, this.httpToken}) {
    httpapi.GetDeviceRelayAPI(this.httpToken, this.deviceID).then((response){
      var result = jsonDecode(response.body);
      this.dispatch(ReceivedDeviceRelaysConfig(jsonState: jsonEncode(result["data"]["state"])));
    });
  }

  @override
  DeviceRelaysConfig get initialState => DeviceRelaysConfig.initState();

  @override
  Stream<DeviceRelaysConfig> mapEventToState(DeviceRelaysConfig currentState, dynamic action) async* {
    if(action is ReceivedDeviceRelaysConfig){
      yield DeviceRelaysConfig.FromJSON(action.jsonState);
    }else if (action is SetDeviceRelaysConfig){
      httpapi.SetDeviceRelayAPI(this.httpToken, this.deviceID, action);
      yield currentState.setRelayState(action.relayIndex, mode: action.mode, detail: action.detail);
    }
  }
}