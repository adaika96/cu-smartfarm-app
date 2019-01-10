import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import './relay_config_chart_drawer.dart';
import '../dialog/relay_config_editor_dialog.dart';
import '../../../model/device/device_relay_config_state.dart';
import '../../../actions/device_bloc.dart';

class RelayConfigChart extends StatelessWidget {
  final DeviceRelaysConfig relaysConfig;
  final Function setRelayConfig;

  RelayConfigChart({this.relaysConfig, this.setRelayConfig});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: CustomPaint(
            size: Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height
            ),
            painter: RelayConfigChartDrawer(relaysConfig: relaysConfig),
          )
        ),
        Positioned(
          left: 0.2 * 0.3 * MediaQuery.of(context).size.width,
          child: Column(
            children: (){
              var buttonList = <Widget>[
              ];
              for (var i = 0; i < relaysConfig.relayConfigs.length; i++) {
                buttonList.add(
                  Container(
                    // color: Colors.red,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle
                    ),
                    margin: EdgeInsets.only(top: (i > 0 ? (0.2 * 0.44) : (0.1 * 0.44)) * MediaQuery.of(context).size.height),
                    child: IconButton(
                      color: Colors.white,
                      icon:Icon(relaysConfig.relayConfigs[i].icon),
                      onPressed: () async {
                        SetDeviceRelaysConfig newRelayConfig = await editRelayConfigDialog(context,
                          relayIndex: i,
                          currentDetail: relaysConfig.relayConfigs[i].detail,
                          currentMode: relaysConfig.relayConfigs[i].mode
                        );
                        if (newRelayConfig != null) {
                          setRelayConfig(newRelayConfig);
                        }
                      },
                    ),
                  )
                );
              }
              return buttonList;
            }()
          )
        )
      ],
    );
  }
}
