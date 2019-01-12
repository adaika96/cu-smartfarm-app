import 'dart:convert';
import 'dart:math';
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
  int limit = 1000;
  num minLoggedTemp, maxLoggedTemp, minLoggedHumid, maxLoggedHumid;

  void loadLogs(){
    setState(() {
      humidLogs = null;
      soilLogs = null;
      tempLogs = null;
    });
    httpapi.GetDeviceSensorLog(widget.httpToken, widget.deviceID, limit).then(
      (response){
        var data = jsonDecode(response.body);
        List columns =  data["data"]["columns"];
        logsData = data["data"]["values"];
        int humidityIndex = columns.indexOf("Humidity");
        int soilIndex = columns.indexOf("Soil");
        int tempIndex = columns.indexOf("Temp");
        int timeIndex = columns.indexOf("time");
        var _tempList = logsData.map((records)=>(records[tempIndex])).where((temp)=>(temp!=null)).toList();
        _tempList.sort();
        minLoggedTemp = _tempList[0];
        maxLoggedTemp = _tempList.last;
        var _humidList = logsData.map((records)=>(records[humidityIndex])).where((temp)=>(temp!=null)).toList();
        _humidList.sort();
        minLoggedHumid = _humidList[0];
        maxLoggedHumid = _humidList.last;
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
            icon: Icon(Icons.remove),
            onPressed: (){
              setState(() {
                limit += 200;
                loadLogs();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              setState(() {
                if (limit - 200 > 0){
                  limit -= 200;
                  loadLogs();
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.replay),
            onPressed: loadLogs,
          ),
        ],
      ),
      body: Center(
        child: humidLogs == null ? CircularProgressIndicator() :
        Container(
          width: 0.95 * MediaQuery.of(context).size.width,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                children: <Widget>[Text("Displaying latest $limit record(s)")],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              Text("Humidity", style: TextStyle(fontSize: 16)),
              // Container(
              //   height: 0.20 * MediaQuery.of(context).size.height,
              //   child: charts.TimeSeriesChart(
              //     [humidLogs],
              //     animate: false,
              //     behaviors: [new charts.RangeAnnotation(
              //       [20, 40, 60, 80, 100].map(
              //         (annotationPoint)=>
              //           new charts.LineAnnotationSegment(annotationPoint,
              //           charts.RangeAnnotationAxisType.measure,
              //           color: charts.MaterialPalette.gray.shade300,
              //           labelPosition: charts.AnnotationLabelPosition.outside,
              //           labelStyleSpec: charts.TextStyleSpec(fontSize: 8),
              //           startLabel: "${annotationPoint - 20} - $annotationPoint")
              //       ).toList()
              //     )],
              //     domainAxis:  new charts.DateTimeAxisSpec(
              //       tickFormatterSpec:
              //         new charts.AutoDateTimeTickFormatterSpec(
              //           minute: new charts.TimeFormatterSpec(
              //             format: 'hh:mm', transitionFormat: 'hh:mm'
              //           )
              //         )
              //       ),
              //   ),
              // ),
              Container(
                height: 0.17 * MediaQuery.of(context).size.height,
                child: charts.TimeSeriesChart(
                  [humidLogs],
                  animate: false,
                  behaviors: [new charts.RangeAnnotation(
                    new List<num>.generate(5, (i) => minLoggedHumid.floor() + ((maxLoggedHumid.ceil() - minLoggedHumid.floor()) / 5) * i).map(
                      (annotationPoint)=>
                        new charts.LineAnnotationSegment(annotationPoint,
                        charts.RangeAnnotationAxisType.measure,
                        labelPosition: charts.AnnotationLabelPosition.outside,
                        labelStyleSpec: charts.TextStyleSpec(fontSize: 5),
                        color: charts.MaterialPalette.gray.shade300,
                        endLabel: "$annotationPoint - ${(annotationPoint + (maxLoggedHumid.ceil() - minLoggedHumid.floor()) / 5).toStringAsFixed(1)}")
                    ).toList()
                  )],
                  primaryMeasureAxis: charts.NumericAxisSpec(
                    viewport: charts.NumericExtents(minLoggedHumid.floor(),maxLoggedHumid.ceil()),
                    showAxisLine: false
                  ),
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
                height: 0.17 * MediaQuery.of(context).size.height,
                child: charts.TimeSeriesChart(
                  [tempLogs],
                  animate: false,
                  behaviors: [new charts.RangeAnnotation(
                    new List<num>.generate(5, (i) => minLoggedTemp.floor() + ((maxLoggedTemp.ceil() - minLoggedTemp.floor()) / 5) * i).map(
                      (annotationPoint)=>
                        new charts.LineAnnotationSegment(annotationPoint,
                        charts.RangeAnnotationAxisType.measure,
                        labelPosition: charts.AnnotationLabelPosition.outside,
                        labelStyleSpec: charts.TextStyleSpec(fontSize: 5),
                        color: charts.MaterialPalette.gray.shade300,
                        endLabel: "$annotationPoint - ${(annotationPoint + (maxLoggedTemp.ceil() - minLoggedTemp.floor()) / 5).toStringAsFixed(1)}")
                    ).toList()
                  )],
                  primaryMeasureAxis: charts.NumericAxisSpec(
                    viewport: charts.NumericExtents(minLoggedTemp.floor(),maxLoggedTemp.ceil()),
                    showAxisLine: false
                  ),
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