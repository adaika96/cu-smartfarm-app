import 'package:flutter/material.dart';

import '../../../api/httpAPI.dart' as httpapi;
import '../../../model/device_info.dart';
import './relay_config_main_editor.dart';
import '../../../actions/device_bloc.dart';
import '../../../model/device/device_relay_config_state.dart';

Future<SetDeviceRelaysConfig> editRelayConfigDialog(BuildContext context, {int relayIndex, RelayMode currentMode, currentDetail}) async {
  GlobalKey<RelayConfigEditorState> _key = GlobalKey();
  String currentStringifiedMode;
  switch (currentMode) {
    case RelayMode.Auto:
      currentStringifiedMode = "auto";
      break;
    case RelayMode.Manual:
      currentStringifiedMode = "manual";
      break;
    case RelayMode.Scheduled:
      currentStringifiedMode = "scheduled";
      break;
    default:
      return Future.delayed(Duration(milliseconds: 1)).then((_)=>SetDeviceRelaysConfig(relayIndex, detail: currentDetail, mode: "")) ;
  }
  return showDialog<SetDeviceRelaysConfig>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Relay Configuration"),
        content: RelayConfigEditor(relayIndex: relayIndex, key: _key, initDetail: currentDetail, initMode: currentStringifiedMode),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            child: MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(_key.currentState.value);
              },
              color: Colors.black,
              textColor: Colors.white,
              child: Text("OK"),
            ),
          )
        ],
      );
    },
  );
}
