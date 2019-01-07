import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

import '../device_info.dart';

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
    return 'ErrorMessage{ErrorMessage: $errmsg, Endpoint: $endpoint';
  }
}

class DevicePageStatusBLoC extends Bloc<Map<String, dynamic>, DeviceState> {
  final String deviceID;

  DevicePageStatusBLoC(this.deviceID);

  @override
  DeviceState get initialState => DeviceState(humidity: 0, relayStates: [false], soil: 0, temp: 0);

  @override
  Stream<DeviceState> mapEventToState(DeviceState currentState, Map<String, dynamic> message) async* {
    if(message["t"] == "report" && message["d"] == this.deviceID){
      yield DeviceState.FromMap(jsonDecode(jsonEncode(message["payload"])));
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