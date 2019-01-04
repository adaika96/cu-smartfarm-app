import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';

import './containers/login/login.dart';
import './containers/register/register.dart';
import './reducers/app_state_reducer.dart';
import './model/app_state.dart';
import './middlewares/apiRequest.dart';
import './actions/users.dart';
import './const.dart' as constants;
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final store = Store<AppState>(appReducer,
      initialState: AppState(), middleware: [ApiRequestMiddleware]);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
          title: 'CU Smart Farm',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.red,
          ),
          routes: {
            "/": (context) {
              return MyHomePageContainer();
            },
            "/register": (context) {
              return RegisterPage();
            }
          },
        ));
  }
}

class _MyHomePageViewModel {
  final String loginStatus;
  final String errmsg;
  final Function(String, String) onLogin;

  _MyHomePageViewModel({
    @required this.loginStatus,
    @required this.errmsg,
    @required this.onLogin,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _MyHomePageViewModel &&
          runtimeType == other.runtimeType &&
          loginStatus == other.loginStatus &&
          errmsg == other.errmsg;

  @override
  int get hashCode => loginStatus.hashCode ^ errmsg.hashCode;
}

class MyHomePageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _MyHomePageViewModel>(
      distinct: true,
      converter: (Store<AppState> store) {
        return new _MyHomePageViewModel(
            errmsg: store.state.errmsg,
            loginStatus: store.state.userSession.loginStatus,
            onLogin: (String username, String password) {
              store.dispatch(LoginPendingAction(username, password));
            });
      },
      builder: (context, loginViewModel) {
        return MyHomePage(
          handleLogin: loginViewModel.onLogin,
          loginStatus: loginViewModel.loginStatus,
          errmsg: loginViewModel.errmsg,
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String loginStatus;
  final String errmsg;
  final Function handleLogin;

  MyHomePage(
      {Key key,
      @required this.loginStatus,
      @required this.errmsg,
      this.handleLogin})
      : super(key: key ?? Key("__loginpage__"));

  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (widget.loginStatus == "pending") {
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
    }else if (widget.loginStatus == "success") {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Row(
          children: <Widget>[
            new Icon(
              Icons.info_outline,
              color: Colors.blue,
            ),
            new Text("Login success")
          ],
        ),
      ));
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
