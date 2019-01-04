import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';

import './containers/register/register.dart';
import './containers/loginpage/login_page.dart';
import './containers/homepage/home_page.dart';

import './middlewares/apiRequest.dart';
import './model/app_state.dart';
import './reducers/app_state_reducer.dart';

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
              return LoginPageContainer();
            },
            "/register": (context) {
              return RegisterPage();
            },
            "/home": (context) {
              return HomePageContainer();
            }
          },
        ));
  }
}
