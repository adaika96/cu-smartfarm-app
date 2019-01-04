import 'package:flutter/material.dart';

import '../../../api/httpAPI.dart' as httpapi;
import '../../../model/device_info.dart';

Future<bool> confirmDeletion(BuildContext context, DeviceShortInfo dev, String token) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm deletion?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure to delete "${dev.name}" device?'),
              Text(''),
              Text("""This action may cause another user can full-control on this device and then irreversible""", style: TextStyle(fontSize: 12),),
            ],
          ),
        ),
        actions: <Widget>[
          MaterialButton(
            color: Colors.red,
            textColor: Colors.white,
            child: Text('Yes'),
            onPressed: () async {
              await httpapi.RemoveDeviceAPI(token, dev.id);
              Navigator.of(context).pop(true);
            },
          ),
          MaterialButton(
            color: Colors.black,
            textColor: Colors.white,
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  );
}