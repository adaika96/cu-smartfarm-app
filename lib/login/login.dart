import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key); // Constructor

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController username = TextEditingController(),
      password = TextEditingController();
  void onClickDummy() {
    print(username.text);
    print(password.text);
  }

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
