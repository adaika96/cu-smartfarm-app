import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

import '../../const.dart' as constants;
import '../../actions/device_bloc.dart';
import '../../api/httpAPI.dart' as httpapi;
import './bloc/device_relay_sensor_bloc.dart';
import './bloc/device_relay_config_bloc.dart';

class DeviceController {
  WebSocketChannel _conn;
  String _wsToken;
  String _httpToken;
  Map<String, DeviceRelayAndSensorLiveStatusBLoC> statusBlocs;
  Map<String, DeviceRelayConfigBLoC> devRelayConfig;
  DevicePageAPIResultBLoC errorReportBloc;

  // WebSocketAPIConnection(this._conn, this._wsToken);

  DeviceController(List<String> devices, String token) {
    statusBlocs = new Map();
    devRelayConfig = new Map();
    errorReportBloc = new DevicePageAPIResultBLoC();
    devices.forEach((devname) {
      statusBlocs[devname] = DeviceRelayAndSensorLiveStatusBLoC(deviceID: devname, httpToken: token);
      devRelayConfig[devname] =
          DeviceRelayConfigBLoC(deviceID: devname, httpToken: token);
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
    this._httpToken = token;
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

  // Wrapper for DeviceRelayConfigBLoC.dispatch(SetDeviceRelaysConfig)
  void setDevice(String deviceID, int relayIndex, Map<String, dynamic> state) {
    this.devRelayConfig[deviceID].dispatch(SetDeviceRelaysConfig(relayIndex,
        mode: state["mode"], detail: state["detail"]));
  }

  // Wrapper for DeviceRelayConfigBLoC.dispatch(SetDeviceRelaysConfig)
  void setRelayDesc(String deviceID, int relayIndex, String desc) {
    httpapi.SetRelayDescAPI(_httpToken, deviceID, relayIndex, desc).then((_) {
      this.statusBlocs[deviceID].dispatch({
        "t": "relayDescChanged",
        "payload": {"relayIndex": relayIndex, "newRelayDesc": desc}
      });
    });
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
      other is DeviceController &&
          runtimeType == other.runtimeType &&
          _conn == other._conn &&
          _wsToken == other._wsToken &&
          statusBlocs == other.statusBlocs;

  @override
  String toString() {
    return 'WebSocketAPIConnection{_wsToken: $_wsToken}';
  }
}
