import 'package:flutter/material.dart';

class ErrorMsgWidget extends StatelessWidget {
  final String errmsg;

  ErrorMsgWidget({this.errmsg});

  @override
  Widget build(BuildContext context) {
    return Column(
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
              errmsg,
              textAlign: TextAlign.center,
            )
          ],
        )
      ],
    );
  }
}
