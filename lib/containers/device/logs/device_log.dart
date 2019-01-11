import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../../../model/app_state.dart';
import '../../../api/httpAPI.dart' as httpapi;

class DeviceSensorLogsReportContainer extends StatelessWidget {
  final String deviceID;
  final String deviceName;

  DeviceSensorLogsReportContainer({this.deviceID, this.deviceName});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, String>(
      distinct: true,
      converter: (Store<AppState> store) {
        return store.state.userSession.httpToken;
      },
      builder: (context, httpToken) {
        return DeviceSensorLogsViewer(
          deviceID: deviceID,
          httpToken: httpToken,
          deviceName: deviceName,
        );
      },
    );
  }
}

class DeviceSensorLogsViewer extends StatefulWidget {
  final String deviceID;
  final String deviceName;
  final String httpToken;

  DeviceSensorLogsViewer({Key key, this.deviceID, this.deviceName, this.httpToken}) : super(key: key);

  @override
  _DeviceSensorLogsViewerState createState() => _DeviceSensorLogsViewerState();
}

class _DeviceSensorLogsViewerState extends State<DeviceSensorLogsViewer> {
  charts.Series humidLogs, soilLogs, tempLogs;
  List<dynamic> logsData;

  void loadLogs(){
    setState(() {
      humidLogs = null;
      soilLogs = null;
      tempLogs = null;
    });
    httpapi.GetDeviceSensorLog(widget.httpToken, widget.deviceID).then(
      (response){
        var data = jsonDecode(response.body);
        List columns =  data["data"]["columns"];
        logsData = data["data"]["values"];
        int humidityIndex = columns.indexOf("Humidity");
        int soilIndex = columns.indexOf("Soil");
        int tempIndex = columns.indexOf("Temp");
        int timeIndex = columns.indexOf("time");
        setState(() {
          humidLogs = new charts.Series<dynamic, DateTime>(
            id: 'Humidity',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (dynamic sales, _) => DateTime.fromMillisecondsSinceEpoch(sales[timeIndex] * 1000),
            measureFn: (dynamic sales, _) => sales[humidityIndex],
            data: logsData,
          );
          soilLogs = new charts.Series<dynamic, DateTime>(
            id: 'Soil',
            colorFn: (_, __) => charts.MaterialPalette.cyan.shadeDefault,
            domainFn: (dynamic sales, _) => DateTime.fromMillisecondsSinceEpoch(sales[timeIndex] * 1000),
            measureFn: (dynamic sales, _) => sales[soilIndex],
            data: logsData,
          );
          tempLogs = new charts.Series<dynamic, DateTime>(
            id: 'Temp',
            colorFn: (_, __) => charts.MaterialPalette.cyan.shadeDefault,
            domainFn: (dynamic sales, _) => DateTime.fromMillisecondsSinceEpoch(sales[timeIndex] * 1000),
            measureFn: (dynamic sales, _) => sales[tempIndex],
            data: logsData,
          );
        });
      }
    );
  }

  @override
    void initState() {
      super.initState();
      loadLogs();
    }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Sensor logs (${widget.deviceName})"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.replay),
            onPressed: loadLogs,
          )
        ],
      ),
      body: Center(
        child: humidLogs == null ? CircularProgressIndicator() :
        Container(
          width: 0.95 * MediaQuery.of(context).size.width,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Humidity", style: TextStyle(fontSize: 16)),
              Container(
                height: 0.20 * MediaQuery.of(context).size.height,
                child: charts.TimeSeriesChart(
                  [humidLogs],
                  animate: false,
                  domainAxis:  new charts.DateTimeAxisSpec(
                    tickFormatterSpec:
                      new charts.AutoDateTimeTickFormatterSpec(
                        minute: new charts.TimeFormatterSpec(
                          format: 'hh:mm', transitionFormat: 'hh:mm'
                        )
                      )
                    ),
                ),
              ),
              Text("Soil moisture", style: TextStyle(fontSize: 16)),
              Container(
                height: 0.20 * MediaQuery.of(context).size.height,
                child: charts.TimeSeriesChart(
                  [soilLogs],
                  animate: false,
                  domainAxis:  new charts.DateTimeAxisSpec(
                    tickFormatterSpec:
                      new charts.AutoDateTimeTickFormatterSpec(
                        minute: new charts.TimeFormatterSpec(
                          format: 'hh:mm', transitionFormat: 'hh:mm'
                        )
                      )
                    ),
                ),
              ),
              Text("Temperature", style: TextStyle(fontSize: 16)),
              Container(
                height: 0.20 * MediaQuery.of(context).size.height,
                child: charts.TimeSeriesChart(
                  [tempLogs],
                  animate: false,
                  domainAxis:  new charts.DateTimeAxisSpec(
                    tickFormatterSpec:
                      new charts.AutoDateTimeTickFormatterSpec(
                        minute: new charts.TimeFormatterSpec(
                          format: 'hh:mm', transitionFormat: 'hh:mm'
                        )
                      )
                    ),
                ),
              )
            ],
            ),
        )
      )
    );
  }
}