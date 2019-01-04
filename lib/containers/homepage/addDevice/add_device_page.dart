import 'package:flutter/material.dart';
import '../../../const.dart' as constants;
import '../../../api/httpAPI.dart' as httpapi;
import 'dart:convert';

class AddDevicePage extends StatefulWidget {
  String token;
  AddDevicePage({Key key, this.token}) : super(key: key); // Constructor

  @override
  _AddDeviceFormState createState() => _AddDeviceFormState();
}

class _AddDeviceFormState extends State<AddDevicePage> {
  TextEditingController id = TextEditingController(),
      secret = TextEditingController(),
      name = TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool autoValidate = false;

  void onClickAddDevice() {
    if (_formKey.currentState.validate()) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        duration: Duration(minutes: 1),
        content: new Row(
          children: <Widget>[
            new CircularProgressIndicator(),
            new Text("  Add device...")
          ],
        ),
      ));
      httpapi.AddDeviceAPI(this.widget.token, {
        "id": id.text,
        "secret": secret.text,
        "name": name.text,
      }).then((response) {
        Map<String, dynamic> result = jsonDecode(response.body);
        if (response.statusCode == 200) {
          _scaffoldKey.currentState.hideCurrentSnackBar();
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Row(
              children: <Widget>[
                new Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                new Text("  Add device success.")
              ],
            ),
          ));
          Future.delayed(const Duration(milliseconds: 1000), () {
            Navigator.pop(context, true);
          });
        } else {
          throw (result['message']);
        }
      }).catchError((error) {
        _scaffoldKey.currentState.hideCurrentSnackBar();
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Row(
            children: <Widget>[
              new Icon(
                Icons.error,
                color: Colors.red,
              ),
              new Text(
                constants.escapeOverflowText(error.toString()),
              )
            ],
          ),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Add new device"),
        ),
        body: Center(
            child: Container(
                width: 0.9 * MediaQuery.of(context).size.width,
                child: ListView(children: [
                  Container(
                    child: Form(
                        key: _formKey,
                        autovalidate: autoValidate,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: TextFormField(
                                controller: id,
                                decoration:
                                    InputDecoration(labelText: 'Device ID'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'ID cannot be empty';
                                  }
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 30),
                              child: TextFormField(
                                  controller: secret,
                                  decoration: InputDecoration(
                                      labelText: 'Device secret'),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Device secret cannot be empty';
                                    }
                                  }),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 30),
                              child: TextFormField(
                                controller: name,
                                decoration: InputDecoration(
                                    labelText: 'Set your device name'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Device name cannot be empty';
                                  }
                                },
                              ),
                            ),
                          ],
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () {
                        setState(() {
                          autoValidate = true;
                        });
                        onClickAddDevice();
                      },
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Text("Confirm"),
                    ),
                  )
                ]))));
  }
}
