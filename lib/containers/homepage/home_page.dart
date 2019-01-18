import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';

import '../../actions/users.dart';
import '../../model/device_info.dart';
import '../../model/app_state.dart';
import '../device/device_control_page.dart';
import './addDevice/add_device_page.dart';
import './editDevice/remove_device_dialog.dart';
import './editDevice/edit_device_dialog.dart';

class _HomePageViewModel {
  final OwnedDevice deviceList;
  final String currentHTTPtoken;
  final Function onReload;
  final Function onSetupDevController;

  _HomePageViewModel(
      {this.deviceList, this.currentHTTPtoken, this.onReload, this.onSetupDevController});

  @override
  int get hashCode => deviceList.hashCode ^ currentHTTPtoken.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _HomePageViewModel &&
          runtimeType == other.runtimeType &&
          deviceList == other.deviceList &&
          currentHTTPtoken == other.currentHTTPtoken;
}

class HomePageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _HomePageViewModel>(
      distinct: true,
      converter: (Store<AppState> store) {
        return _HomePageViewModel(
            deviceList: store.state.devices,
            currentHTTPtoken: store.state.userSession.httpToken,
            onReload: () {
              store.dispatch(QueryDevicePendingAction());
            },
            onSetupDevController: () {
              store.dispatch(EnsureSocketConnection());
            });
      },
      builder: (context, vm) {
        return HomePage(
          deviceList: vm.deviceList,
          token: vm.currentHTTPtoken,
          reload: vm.onReload,
          setupDevController: vm.onSetupDevController,
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  final OwnedDevice deviceList;
  final String token;
  final Function reload;
  final Function setupDevController;

  HomePage({Key key, this.deviceList, this.token, this.reload, this.setupDevController})
      : super(key: key); // Constructor

  @override
  _HomePage createState() => new _HomePage();
}

@immutable
class _HomePage extends State<HomePage> {
  GlobalKey<ScaffoldState> _homepageScaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _homepageScaffoldKey,
      appBar: AppBar(
        title: Text('Homepage'),
      ),
      body: Center(
        child: Container(
          width: 0.9 * MediaQuery.of(context).size.width,
          child: widget.deviceList.isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new CircularProgressIndicator(),
                    new Text("Loading device...")
                  ],
                )
              : widget.deviceList.errmsg == ""
                  ? ListView.builder(
                      itemCount: widget.deviceList.devices.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        return index == 0
                            ? Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Text("Device list",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300)),
                              )
                            : ListTile(
                                onLongPress: () async {
                                  if (await editDialog(
                                      context,
                                      widget.deviceList.devices[index - 1],
                                      widget.token) != null) {
                                    widget.reload();
                                  }
                                },
                                trailing: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: IconButton(
                                    onPressed: () async {
                                      if (await confirmDeletion(
                                          context,
                                          widget.deviceList.devices[index - 1],
                                          widget.token) == true) {
                                        widget.reload();
                                      }
                                    },
                                    color: Colors.black,
                                    icon: Icon(Icons.delete),
                                  ),
                                ),
                                title: Text(
                                    widget.deviceList.devices[index - 1].name),
                                subtitle: Text("ID: " +
                                    widget.deviceList.devices[index - 1].id),
                                onTap: () {
                                  widget.setupDevController();
                                  Navigator.push(context,MaterialPageRoute(
                                      builder: (context) => DevicePageContainer(
                                        deviceID: widget.deviceList.devices[index - 1].id,
                                        deviceName: widget.deviceList.devices[index - 1].name,
                                      ),
                                    ),
                                  );
                                },
                              );
                      },
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 100,
                        ),
                        new Wrap(
                          children: <Widget>[
                            Text(
                              widget.deviceList.errmsg,
                              textAlign: TextAlign.center,
                            )
                          ],
                        )
                      ],
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "Add new devices",
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDevicePage(token: widget.token),
            ),
          );
          if (result != null) {
            widget.reload();
          }
        },
      ),
    );
  }
}
