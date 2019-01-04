import 'package:flutter/material.dart';
import '../../const.dart' as constants;
import '../../api/httpAPI.dart' as httpapi;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key); // Constructor

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterPage> {
  TextEditingController username = TextEditingController(),
      password = TextEditingController(),
      address = TextEditingController(),
      nationalID = TextEditingController(),
      email = TextEditingController();
  String province;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool autoValidate = false;

  String validateNationalID(String nationalID) {
    RegExp nationalIDValidator = new RegExp(r'^[0-9]{13}$');
    int summation = 0;
    if (!nationalIDValidator.hasMatch(nationalID))
      return "National ID is incorrect";
    for (var i = 0; i < 12; i++) {
      summation += (nationalID.codeUnitAt(i) - 48) * (13 - i);
    }
    if (((11 - (summation % 11)) % 10) != (nationalID.codeUnitAt(12) - 48))
      return "National ID is incorrect";
    return null;
  }

  void onClickRegister() {
    if (_formKey.currentState.validate()) {
      if (province != null) {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          duration: Duration(minutes: 1),
          content: new Row(
            children: <Widget>[
              new CircularProgressIndicator(),
              new Text("  Registering...")
            ],
          ),
        ));
        httpapi.RegistrationAPI({
          "username": username.text,
          "password": password.text,
          "province": province,
          "address": address.text,
          "nationalID": nationalID.text,
          "email": email.text,
        }).then((response) {
          Map<String, dynamic> result = jsonDecode(response.body);
          if (response.statusCode == 200 && result['success'] as bool == true) {
            _scaffoldKey.currentState.hideCurrentSnackBar();
            Navigator.pop(context, <Widget>[
              new Icon(
                Icons.info_outline,
                color: Colors.blueAccent,
              ),
              new Text("  Registration success.")
            ]);
          }else{
            throw(result['message']);
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
      } else {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Row(
            children: <Widget>[
              new Icon(
                Icons.error,
                color: Colors.red,
              ),
              new Text("  Please specify province")
            ],
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Smart Farm User registeration"),
        ),
        body: Center(
            child: Container(
                width: 0.9 * MediaQuery.of(context).size.width,
                child: ListView(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 30),
                        child: Text("User Registration",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w300)),
                      )
                    ],
                  ),
                  Container(
                    child: Form(
                        key: _formKey,
                        autovalidate: autoValidate,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: TextFormField(
                                controller: username,
                                decoration:
                                    InputDecoration(labelText: 'Username'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Username cannot be empty';
                                  }
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              child: TextFormField(
                                controller: password,
                                obscureText: true,
                                decoration:
                                    InputDecoration(labelText: 'Password'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Password cannot be empty';
                                  }
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              child: TextFormField(
                                controller: email,
                                decoration: InputDecoration(labelText: 'Email'),
                                validator: (value) {
                                  RegExp emailValidator = new RegExp(
                                      r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                                  if (!emailValidator.hasMatch(value)) {
                                    return 'Email is invalid';
                                  }
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              child: TextFormField(
                                  controller: address,
                                  decoration:
                                      InputDecoration(labelText: 'Address'),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Address cannot be empty';
                                    }
                                  }),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              child: TextFormField(
                                  controller: nationalID,
                                  decoration:
                                      InputDecoration(labelText: 'National ID'),
                                  keyboardType: TextInputType.number,
                                  validator: validateNationalID),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              child: new DropdownButton<String>(
                                items: constants.AvailableProvince.map(
                                    (String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    province = value;
                                  });
                                },
                                hint: Text("Province"),
                                value: province,
                                isExpanded: true,
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
                        onClickRegister();
                      },
                      color: Colors.red[900],
                      textColor: Colors.white,
                      child: Text("Register"),
                    ),
                  )
                ]))));
  }
}
