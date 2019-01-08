import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
// import 'package:web_socket_channel/io.dart';

import '../const.dart' as constants;
import './bloc/device_page_bloc.dart';

class WebSocketAPIConnection {
  WebSocketChannel _conn;
  String _wsToken;
  Map<String, DevicePageStatusBLoC> statusBlocs;
  DevicePageAPIResultBLoC errorReportBloc;

  // WebSocketAPIConnection(this._conn, this._wsToken);

  WebSocketAPIConnection(List<String> devices, String token) {
    statusBlocs = new Map();
    errorReportBloc = new DevicePageAPIResultBLoC();
    devices.forEach((devname) {
      statusBlocs[devname] = DevicePageStatusBLoC(devname);
    });
    this._conn = IOWebSocketChannel.connect(
        'ws://${constants.ServerIP}/subscribe/ws',
        headers: {"Authorization": "Bearer " + token});
    this._conn.stream.listen((message) {
      var data = jsonDecode(message);
      if (data["token"] != null) {
        this._wsToken = data["token"];
      }
      this.statusBlocs.forEach((_, bloc) => bloc.dispatch(data));
      this.errorReportBloc.dispatch(data);
    });
  }

  // factory WebSocketAPIConnection.WithNewToken(WebSocketAPIConnection old, String token){
  //   return WebSocketAPIConnection(old._conn, token);
  // }

  void pollDevice(String deviceID) {
    var qMessage = {
      "endPoint": "pollDevice",
      "token": _wsToken,
      "payload": {
        "deviceID": deviceID,
      }
    };
    _conn.sink.add(jsonEncode(qMessage));
  }

  void setDevice(String deviceID, String relayID, Map<String, dynamic> state) {
    var qMessage = {
      "endPoint": "setDevice",
      "token": _wsToken,
      "payload": {
        "deviceID": deviceID,
        "param": {"relayID": relayID, "state": state}
      }
    };
    _conn.sink.add(jsonEncode(qMessage));
  }

  void getLatestState(String deviceID) {
    var qMessage = {
      "endPoint": "getLatestState",
      "token": _wsToken,
      "payload": {"deviceID": deviceID}
    };
    _conn.sink.add(jsonEncode(qMessage));
  }

  void disconnect() {
    this._conn.sink.close();
  }

  @override
  int get hashCode => _conn.hashCode ^ _wsToken.hashCode ^ statusBlocs.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WebSocketAPIConnection &&
          runtimeType == other.runtimeType &&
          _conn == other._conn &&
          _wsToken == other._wsToken &&
          statusBlocs == other.statusBlocs;

  @override
  String toString() {
    return 'WebSocketAPIConnection{_wsToken: $_wsToken}';
  }
}
