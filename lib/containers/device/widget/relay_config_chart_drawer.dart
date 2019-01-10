import 'package:flutter/material.dart';
import '../../../model/device/device_relay_config_state.dart';

@immutable
class _PaintInfo {
  final Rect line;
  final Paint paint;

  _PaintInfo({@required this.line, @required this.paint});
}

class RelayConfigChartDrawer extends CustomPainter {
  List <double> _relayComponentYPosition = [0.1, 0.3, 0.5, 0.7, 0.9];
  List <double> _sensorComponentYPosition = [0.17, 0.5, 0.83];
  List <Color> _colorSet = [Colors.red, Colors.blue, Colors.green, Colors.purpleAccent, Colors.yellowAccent[700]];

  Size _realSize;
  final double _lineFromRelayLength = 0.4;
  final double _lineFromRelayLengthForAuto = 0.7;
  final double _relayLineMargin = 4;
  final double _lineWeight = 2;
  final DeviceRelaysConfig relaysConfig;

  RelayConfigChartDrawer({this.relaysConfig});

  _PaintInfo drawOutFrom(int index){
    return _PaintInfo(
      line:
        new Rect.fromPoints(
          new Offset(0, _relayComponentYPosition[index] * _realSize.height),
          new Offset(_lineFromRelayLength * _realSize.width, _relayComponentYPosition[index] * _realSize.height + _lineWeight)
        ),
      paint: new Paint()..color = _colorSet[index]
    );
  }

  _PaintInfo drawOutFromForAuto(int index){
    return _PaintInfo(
      line:
        new Rect.fromPoints(
          new Offset(0, _relayComponentYPosition[index] * _realSize.height),
          new Offset(
            _lineFromRelayLengthForAuto *
            _realSize.width +
            (index * _relayLineMargin),

            _relayComponentYPosition[index] *
            _realSize.height +
            _lineWeight
          )
        ),
      paint: new Paint()..color = _colorSet[index]
    );
  }

  _PaintInfo drawInTo(int index, int relayIndex){
    return _PaintInfo(
      line:
        new Rect.fromPoints(
          new Offset(
            _lineFromRelayLengthForAuto *
            _realSize.width +
            (relayIndex * _relayLineMargin),

            _sensorComponentYPosition[index] *
            _realSize.height +
            ((relayIndex - 2) * _relayLineMargin)
          ),
          new Offset(
            _realSize.width,

            _sensorComponentYPosition[index] *
            _realSize.height +
            _lineWeight +
            ((relayIndex - 2) * _relayLineMargin)
          ),
        ),
      paint: new Paint()..color = _colorSet[relayIndex]
    );
  }

  _PaintInfo drawFromTo(int src, int dest){
    return _PaintInfo(
      line:
        new Rect.fromPoints(
          new Offset(
            _lineFromRelayLengthForAuto *
            _realSize.width + (src * _relayLineMargin),

            _relayComponentYPosition[src] *
            _realSize.height +
            ( _relayComponentYPosition[src] < _sensorComponentYPosition[dest] ? 0 : 2)
          ),
          new Offset(
            _lineFromRelayLengthForAuto *
            _realSize.width +
            (src * _relayLineMargin) +
            _lineWeight,

            _sensorComponentYPosition[dest] *
            _realSize.height +
            ((src - 2) * _relayLineMargin)
          ),
        ),
      paint: new Paint()..color = _colorSet[src]
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    _realSize = new Size(size.width, 0.8 * size.height);

    List<_PaintInfo> lines = List();
    for (var i = 0; i < relaysConfig.relayConfigs.length; i++) {
      // canvas.drawRect(drawOutFrom(i), new Paint()..color = _colorSet[i]);
      if(relaysConfig.relayConfigs[i].mode == RelayMode.Auto){
        lines.add(drawOutFromForAuto(i));
        switch (relaysConfig.relayConfigs[i].detail["sensor"]) {
          case "humidity":
            lines.addAll([
              drawFromTo(i, 0),
              drawInTo(0, i),
            ]);
            break;
          case "soil":
            lines.addAll([
              drawFromTo(i, 1),
              drawInTo(1, i),
            ]);
            break;
          case "temp":
            lines.addAll([
              drawFromTo(i, 2),
              drawInTo(2, i),
            ]);
            break;
          default:
        }
      }else{
        lines.add(drawOutFrom(i));
      }
    }
    lines.forEach((line)=>canvas.drawRect(line.line, line.paint));
  }

  @override
  bool shouldRepaint(RelayConfigChartDrawer oldDelegate) {
    return this.relaysConfig != oldDelegate.relaysConfig;
  }

}