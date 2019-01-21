import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

import '../../device_info.dart';
import '../../../api/httpAPI.dart' as httpapi;

@immutable
class ErrorMessage {
  final String errmsg;
  final String endpoint;

  const ErrorMessage({this.errmsg, this.endpoint});

  @override
  int get hashCode =>
      errmsg.hashCode ^ endpoint.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErrorMessage &&
          runtimeType == other.runtimeType &&
          errmsg == other.errmsg &&
          endpoint == other.endpoint;

  @override
  String toString() {
    return 'ErrorMessage{ErrorMessage: $errmsg, Endpoint: $endpoint}';
  }
}

class DeviceRelayAndSensorLiveStatusBLoC extends Bloc<Map<String, dynamic>, DeviceState> {
  final String deviceID;

  DeviceRelayAndSensorLiveStatusBLoC({this.deviceID, String httpToken}){
    httpapi.GetRelayDescAPI(httpToken, deviceID).then(
      (resp){
        var data = jsonDecode(resp.body);
        List receivedRelayDesc = List<String>.from(data["data"]);
        for (var i = 0; i < receivedRelayDesc.length; i++) {
          dispatch({
            "t": "relayDescChanged",
            "payload": {
              "relayIndex": i,
              "newRelayDesc": receivedRelayDesc[i] == "" ? "Relay${i+1}" : receivedRelayDesc[i]
            }
          });
        }
      }
    );
  }

  @override
  DeviceState get initialState => DeviceState(
    humidity: 0,
    relayStates: [null, null, null, null, null],
    soil: 0,
    temp: 0,
    relayDesc: ["Relay1", "Relay2", "Relay3", "Relay4", "Relay5"]
  ); // Must call API

  @override
  Stream<DeviceState> mapEventToState(DeviceState currentState, Map<String, dynamic> message) async* {
    if(message["t"] == "report" && message["d"] == this.deviceID){
      yield DeviceState.FromMap(jsonDecode(jsonEncode(message["payload"])), relayDesc: currentState.relayDesc);
    }else if (message["t"] == "relayDescChanged") {
      currentState.relayDesc[message["payload"]["relayIndex"]] = message["payload"]["newRelayDesc"];
      yield currentState.changeRelayDesc(newRelayDesc: List.from(currentState.relayDesc));
    }
  }
}

class DevicePageAPIResultBLoC extends Bloc<Map<String, dynamic>, ErrorMessage> {

  @override
  ErrorMessage get initialState => ErrorMessage(endpoint: "", errmsg: "");

  @override
  Stream<ErrorMessage> mapEventToState(ErrorMessage currentState, Map<String, dynamic> message) async* {
    if(message["t"] == "response" && !(message["status"]["success"])){
      yield ErrorMessage(endpoint: message["e"], errmsg: message["status"]["errmsg"]);
    }
  }
}