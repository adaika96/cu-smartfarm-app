import 'package:flutter/material.dart';


class LoginForm extends StatefulWidget {
  final Function(String, String) onLogin;
  LoginForm({Key key, this.onLogin}) : super(key: key); // Constructor

  @override
  _LoginFormState createState() => _LoginFormState(onLogin: onLogin);
}

class _LoginFormState extends State<LoginForm> {
  final Function(String, String) onLogin;
  TextEditingController username = TextEditingController(),
      password = TextEditingController();

  void onClickDummy() {
    onLogin(username.text, password.text);
  }

  _LoginFormState({this.onLogin});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 0.25 * MediaQuery.of(context).size.height,
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('./images/cu-engineer.png'),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("Smart Farm user login"),
            ],
          ),
          Container(
            child: Form(
              child: TextFormField(
                controller: username,
                decoration: InputDecoration(labelText: 'Username'),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Form(
              child: TextFormField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              onPressed: onClickDummy,
              color: Colors.red[900],
              textColor: Colors.white,
              child: Text("Login"),
            ),
          )
        ]);
  }
}
