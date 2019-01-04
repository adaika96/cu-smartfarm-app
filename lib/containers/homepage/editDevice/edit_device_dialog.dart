import 'package:flutter/material.dart';

import '../../../api/httpAPI.dart' as httpapi;
import '../../../model/device_info.dart';

Future<bool> editDialog(
    BuildContext context, DeviceShortInfo dev, String token) async {
  TextEditingController newDeviceName = TextEditingController(text: dev.name);
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Rename device"),
        content: TextFormField(
          autovalidate: true,
          controller: newDeviceName,
          decoration: InputDecoration(labelText: 'Name'),
          validator: (value) {
            if (value.isEmpty) {
              return 'Device name cannot be empty';
            }
          },
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            child: MaterialButton(
              onPressed: () async {
                await httpapi.RenameDeviceAPI(token, {
                  "id": dev.id,
                  "name": newDeviceName.text
                });
                Navigator.of(context).pop(true);
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
