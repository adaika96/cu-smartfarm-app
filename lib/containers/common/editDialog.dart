import 'package:flutter/material.dart';

Future<String> editDialog(BuildContext context, {String initialVal, String title, int maxLength}) async {
  TextEditingController _text = TextEditingController(text: initialVal);
  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title ?? "Edit"),
        content: Container(
          width: 80,
          child: TextField(controller: _text, maxLength: maxLength,),
        ),
        actions: <Widget>[
          MaterialButton(
            color: Colors.red,
            textColor: Colors.white,
            child: Text('OK'),
            onPressed: () async {
              Navigator.of(context).pop(_text.text);
            },
          ),
          MaterialButton(
            color: Colors.black,
            textColor: Colors.white,
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          ),
        ],
      );
    },
  );
}