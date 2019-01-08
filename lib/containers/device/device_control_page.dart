import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';

// import '../../actions/users.dart';
import '../../model/app_state.dart';
import '../../model/device_info.dart';
import '../../model/ws.dart';
// import './addDevice/add_device_page.dart';
// import './editDevice/remove_device_dialog.dart';
// import './editDevice/edit_device_dialog.dart';

import '../common/errorText.dart';

class DevicePageContainer extends StatelessWidget {
  final String deviceID;
  final String deviceName;

  DevicePageContainer({this.deviceID, this.deviceName});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, WebSocketAPIConnection>(
      distinct: true,
      converter: (Store<AppState> store) {
        return store.state.wsAPI;
      },
      builder: (context, wsAPI) {
        return DevicePage(
          deviceID: deviceID,
          wsAPI: wsAPI,
          deviceName: deviceName,
        );
      },
    );
  }
}

class DevicePage extends StatefulWidget {
  final String deviceID;
  final String deviceName;
  final WebSocketAPIConnection wsAPI;

  DevicePage({Key key, this.deviceID, this.deviceName, this.wsAPI})
      : super(key: key); // Constructor

  @override
  _DevicePage createState(){
    wsAPI.pollDevice(deviceID);
    return new _DevicePage();
  }
}

@immutable
class _DevicePage extends State<DevicePage> {
  // @override
  // void initState() {
  //   print("On ${widget.deviceID}");
  //   widget.wsAPI.statusBlocs[widget.deviceID].state.listen((a) {
  //     print(a);
  //   });
  //   widget.wsAPI.errorReportBloc.state.listen((a) {
  //     print(a);
  //   });
  // }

  GlobalKey<ScaffoldState> _DevicePageScaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _DevicePageScaffoldKey,
        appBar: AppBar(
          title: Text('Dashboard (${widget.deviceName})'),
        ),
        body: Center(
          child: Container(
            width: 0.7 * MediaQuery.of(context).size.width,
            height: 0.8 * MediaQuery.of(context).size.height,
            child: StreamBuilder<DeviceState>(
              stream: widget.wsAPI.statusBlocs[widget.deviceID].state,
              builder: (BuildContext context,
                  AsyncSnapshot<DeviceState> snapshot) {
                if (snapshot.hasError)
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[ErrorMsgWidget(errmsg: snapshot.error.toString())]
                  );
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: snapshot.data.relayStates.asMap().keys.map((index) =>
                            Column(
                              children: <Widget>[
                                Text("Relay${index+1}"),
                                Switch(value: snapshot.data.relayStates[index], onChanged: (newState){
                                  widget.wsAPI.setDevice(widget.deviceID, "Relay${index+1}", {"mode": "manual","detail":newState?"on":"off"});
                                },)
                              ]
                            )
                          ).toList(),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(children: <Widget>[Icon(Icons.settings_input_component), Text("Humidity \n(${snapshot.data.humidity.toStringAsFixed(1)}%)", textAlign: TextAlign.center)]),
                            Column(children: <Widget>[Icon(Icons.settings_input_component), Text("Soil \n(${snapshot.data.soil.toStringAsFixed(1)}%)", textAlign: TextAlign.center)]),
                            Column(children: <Widget>[Icon(Icons.settings_input_component), Text("Temp \n(${snapshot.data.temp.toStringAsFixed(1)}%)", textAlign: TextAlign.center)])
                          ],
                        ),
                      ]
                    );
                  default:
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[Icon(Icons.warning)]
                    );
                }
              }),
          )
        ));
  }
}
