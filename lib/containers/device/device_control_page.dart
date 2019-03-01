import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';

import '../../model/app_state.dart';
import '../../model/device_info.dart';
import '../../model/device/device_controller.dart';
import '../../model/device/device_relay_config_state.dart';

import '../../actions/users.dart';
import '../common/errorText.dart';
import './widget/relay_state.dart';
import './widget/relay_config_overview.dart';
import './logs/device_log.dart';

class _DevicePageViewModel {
  final DeviceController devController;
  final Function recreateDevController;

  _DevicePageViewModel({this.devController, this.recreateDevController});

  @override
  int get hashCode => devController.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _DevicePageViewModel &&
          runtimeType == other.runtimeType &&
          devController == other.devController;
}

class DevicePageContainer extends StatelessWidget {
  final String deviceID;
  final String deviceName;

  DevicePageContainer({this.deviceID, this.deviceName});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _DevicePageViewModel>(
      distinct: true,
      converter: (Store<AppState> store) {
        return _DevicePageViewModel(devController: store.state.devController, recreateDevController: (){
          store.dispatch(EnsureSocketConnection());
        });
      },
      builder: (context, vm) {
        vm.devController.pollDevice(deviceID);
        return DevicePage(
          deviceID: deviceID,
          devController: vm.devController,
          deviceName: deviceName,
          recreateDevController: vm.recreateDevController,
        );
      },
    );
  }
}

class DevicePage extends StatefulWidget {
  final String deviceID;
  final String deviceName;
  final DeviceController devController;
  final Function recreateDevController;

  DevicePage({Key key, this.deviceID, this.deviceName, this.devController, this.recreateDevController})
      : super(key: key); // Constructor

  @override
  _DevicePage createState() => new _DevicePage();
}

@immutable
class _DevicePage extends State<DevicePage> {

  GlobalKey<ScaffoldState> _DevicePageScaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _DevicePageScaffoldKey,
        appBar: AppBar(
          title: Text('Dashboard (${widget.deviceName})', style: TextStyle(fontSize: 16)),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.equalizer),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => DeviceSensorLogsReportContainer(
                      deviceID: widget.deviceID,
                      deviceName: widget.deviceName,
                    ),
                  ),
                );
                // widget.devController.pollDevice(widget.deviceID);
              },
            ),
            IconButton(
              icon: Icon(Icons.replay),
              onPressed: (){
                widget.recreateDevController();
                // widget.devController.pollDevice(widget.deviceID);
              },
            )
          ],
        ),
        body: Center(
          child: Container(
            width: 0.9 * MediaQuery.of(context).size.width,
            height: 0.8 * MediaQuery.of(context).size.height,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: StreamBuilder<DeviceState>(
                    stream: widget.devController.statusBlocs[widget.deviceID].state,
                    builder: (BuildContext context, AsyncSnapshot<DeviceState> snapshot) {
                      return snapshot.connectionState == ConnectionState.active ? RelayStateWidget(
                        relayState: snapshot.data.relayStates,
                        handleToggleRelayState: (int index, bool newState){
                          widget.devController.setDevice(widget.deviceID, index, {
                            "mode": "manual",
                            "detail": snapshot.data.relayStates[index],
                          });
                        },
                        relayDesc: snapshot.data.relayDesc,
                        handleChangeRelayDesc: (int index, String desc){
                          // httpapi.SetRelayDescAPI(widget.devController., deviceID, relayIndex, desc)
                          widget.devController.setRelayDesc(widget.deviceID, index, desc);
                        },
                      ): Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[new CircularProgressIndicator()]);
                    }
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: StreamBuilder<DeviceRelaysConfig>(
                    stream: widget.devController.devRelayConfig[widget.deviceID].state,
                    builder: (BuildContext context, AsyncSnapshot<DeviceRelaysConfig> snapshot) {
                      return Wrap(
                        children: <Widget>[
                          snapshot.connectionState == ConnectionState.active ? RelayConfigChart(relaysConfig: snapshot.data, setRelayConfig: (newConfig){
                            print("[newConfig] >> $newConfig");
                            widget.devController.devRelayConfig[widget.deviceID].dispatch(newConfig);
                          },):
                          Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[new CircularProgressIndicator()])
                        ],
                      );
                    }
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: StreamBuilder<DeviceState>(
                    stream: widget.devController.statusBlocs[widget.deviceID].state,
                    builder: (BuildContext context, AsyncSnapshot<DeviceState> snapshot) {
                      return snapshot.connectionState == ConnectionState.active ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Column(children: <Widget>[Icon(Icons.settings_input_component), Text("Humidity \n(${snapshot.data.humidity.toStringAsFixed(1)}%)", textAlign: TextAlign.center)]),
                          Column(children: <Widget>[Icon(Icons.settings_input_component), Text("Soil \n(${snapshot.data.soil.toStringAsFixed(1)}%)", textAlign: TextAlign.center)]),
                          Column(children: <Widget>[Icon(Icons.settings_input_component), Text("Temp \n(${snapshot.data.temp.toStringAsFixed(1)}°C)", textAlign: TextAlign.center)])
                        ],
                      ) : Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[new CircularProgressIndicator()],);
                    }
                  ),
                  flex: 1,
                ),
              ],
            )
          )
        ));
  }
}
