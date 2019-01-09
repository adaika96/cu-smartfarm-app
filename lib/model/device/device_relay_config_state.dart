import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
// {
//   "Relay1": {
//       "detail": "off",
//       "mode": "manual"
//   },
//   "Relay2": {
//       "detail": "off",
//       "mode": "manual"
//   },
//   "Relay3": {
//       "detail": "on",
//       "mode": "manual"
//   },
//   "Relay4": {
//       "detail": "on",
//       "mode": "manual"
//   },
//   "Relay5": {
//       "detail": "on",
//       "mode": "manual"
//   }
// }

enum RelayMode { Auto, Manual, Scheduled, Indeterminated }

@immutable
class DeviceRelayConfig {
  final RelayMode mode;
  final dynamic detail;
  final Map<RelayMode, IconData> _iconMap = {
    RelayMode.Manual: Icons.touch_app,
    RelayMode.Auto: Icons.play_circle_outline,
    RelayMode.Scheduled: Icons.alarm,
    RelayMode.Indeterminated: Icons.cached,
  };

  DeviceRelayConfig({String mode, this.detail}): this.mode =
      (mode == "auto") ? RelayMode.Auto :
      (mode == "scheduled") ? RelayMode.Scheduled :
      (mode == "manual") ? RelayMode.Manual :
      RelayMode.Indeterminated;

  @override
  int get hashCode => mode.hashCode ^ detail.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceRelayConfig &&
          runtimeType == other.runtimeType &&
          mode == other.mode &&
          detail == other.detail;

  @override
  String toString() =>
      'DeviceRelayConfig{mode: $mode, detail: $detail}';

  IconData get icon {
    return this._iconMap[this.mode];
  }
}

@immutable
class DeviceRelaysConfig {
  final List<DeviceRelayConfig> relayConfigs;

  DeviceRelaysConfig({this.relayConfigs});

  factory DeviceRelaysConfig.initState() => DeviceRelaysConfig(relayConfigs: [
        DeviceRelayConfig(mode: "Indeterminated", detail: null),
        DeviceRelayConfig(mode: "Indeterminated", detail: null),
        DeviceRelayConfig(mode: "Indeterminated", detail: null),
        DeviceRelayConfig(mode: "Indeterminated", detail: null),
        DeviceRelayConfig(mode: "Indeterminated", detail: null)
      ]);

  factory DeviceRelaysConfig.FromJSON(String jRelayConfig) {
    var relayConfigs = List<DeviceRelayConfig>();
    Map<String, dynamic> relayStateMap = jsonDecode(jRelayConfig);
    for (var i = 1; i <= 5; i++) {
      var relayMode = jsonDecode(jsonEncode(relayStateMap["Relay$i"]));
      relayConfigs.add(
        DeviceRelayConfig(
          mode: relayMode["mode"] as String,
          detail: relayMode["detail"]
        )
      );
    }
    return DeviceRelaysConfig(relayConfigs: relayConfigs);
  }

  DeviceRelaysConfig setRelayState(int relayIndex, {String mode, dynamic detail}) {
    relayConfigs[relayIndex] = DeviceRelayConfig(
      detail: detail,
      mode: mode
    );
    // return New Object instead
    return DeviceRelaysConfig(relayConfigs: this.relayConfigs);
  }

  @override
  int get hashCode => relayConfigs.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceRelaysConfig &&
          runtimeType == other.runtimeType &&
          relayConfigs == other.relayConfigs;

  @override
  String toString() =>
      "DeviceRelaysConfig: " + relayConfigs.asMap().keys.fold("", (result, index)=>"$result Relay${index+1}{${relayConfigs[index]}}\n");
}
