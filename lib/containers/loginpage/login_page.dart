import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';

import '../../model/app_state.dart';
import './loginWidget/widget.dart';
import '../../actions/users.dart';
import '../../const.dart' as constants;

class _LoginPageViewModel {
  final String loginStatus;
  final String errmsg;
  final Function(String, String) onLogin;
  final Function(BuildContext) onLoginSuccess;

  _LoginPageViewModel({
    @required this.loginStatus,
    @required this.errmsg,
    @required this.onLogin,
    @required this.onLoginSuccess,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _LoginPageViewModel &&
          runtimeType == other.runtimeType &&
          loginStatus == other.loginStatus &&
          errmsg == other.errmsg;

  @override
  int get hashCode => loginStatus.hashCode ^ errmsg.hashCode;
}

class LoginPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _LoginPageViewModel>(
      distinct: true,
      converter: (Store<AppState> store) {
        print(store.state.userSession);
        return new _LoginPageViewModel(
            errmsg: store.state.userSession.errmsg,
            loginStatus: store.state.userSession.loginStatus,
            onLogin: (String username, String password) {
              store.dispatch(LoginPendingAction(username, password));
            },
            onLoginSuccess: (BuildContext cContext) {
              store.dispatch(QueryDevicePendingAction());
              Navigator.pushReplacementNamed(cContext, "/home");
            });
      },
      builder: (context, loginViewModel) {
        return LoginPage(
          handleLogin: loginViewModel.onLogin,
          loginStatus: loginViewModel.loginStatus,
          errmsg: loginViewModel.errmsg,
          onLoginSuccess: loginViewModel.onLoginSuccess,
        );
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  final String loginStatus;
  final String errmsg;
  final Function handleLogin;
  final Function onLoginSuccess;

  LoginPage(
      {Key key,
      @required this.loginStatus,
      @required this.errmsg,
      @required this.handleLogin,
      @required this.onLoginSuccess})
      : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (widget.loginStatus == "pending") {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Row(
          children: <Widget>[
            new CircularProgressIndicator(),
            new Text("  Logging in...")
          ],
        ),
      ));
    } else if (widget.loginStatus == "failure") {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Row(
          children: <Widget>[
            new Icon(
              Icons.error,
              color: Colors.red,
            ),
            new Text(
              constants.escapeOverflowText(widget.errmsg),
            )
          ],
        ),
      ));
    } else if (widget.loginStatus == "success") {
      new Future.delayed(const Duration(milliseconds: 500), () {
        widget.onLoginSuccess(context);
      });
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('User Authentication'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Container(
                width: 0.9 * MediaQuery.of(context).size.width,
                child: new LoginForm(onLogin: widget.handleLogin),
              )
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: 0.9 * MediaQuery.of(context).size.width,
                  child: MaterialButton(
                    onPressed: () async {
                      final result =
                          await Navigator.pushNamed(context, "/register");
                      if (result != null) {
                        _scaffoldKey.currentState.showSnackBar(new SnackBar(
                          content: new Row(
                            children: result as List<Widget>,
                          ),
                        ));
                      }
                    },
                    color: Colors.black,
                    textColor: Colors.white,
                    child: Text("Register"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
