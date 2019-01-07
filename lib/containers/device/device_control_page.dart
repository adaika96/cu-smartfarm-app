import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';

// import '../../actions/users.dart';
// import '../../model/device_info.dart';
import '../../model/app_state.dart';
import '../../model/ws.dart';
// import './addDevice/add_device_page.dart';
// import './editDevice/remove_device_dialog.dart';
// import './editDevice/edit_device_dialog.dart';

class DevicePageContainer extends StatelessWidget {
  final String deviceID;

  DevicePageContainer({this.deviceID});

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
            wsAPI: wsAPI);
      },
    );
  }
}

class DevicePage extends StatefulWidget {
  final String deviceID;
  final WebSocketAPIConnection wsAPI;

  DevicePage({Key key, this.deviceID, this.wsAPI}) : super(key: key); // Constructor

  @override
  _DevicePage createState() => new _DevicePage();
}

@immutable
class _DevicePage extends State<DevicePage> {

  @override
  void initState(){
    print("On ${widget.deviceID}");
    widget.wsAPI.statusBlocs[widget.deviceID].state.listen((a){
      print(a);
    });
    widget.wsAPI.errorReportBloc.state.listen((a){
      print(a);
    });
  }
  GlobalKey<ScaffoldState> _DevicePageScaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _DevicePageScaffoldKey,
      appBar: AppBar(
        title: Text('DevicePage'),
      ),
      body: Center()
    );
  }
}
