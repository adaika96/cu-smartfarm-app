class ReceivedDeviceRelaysConfig {
  final String jsonState;

  ReceivedDeviceRelaysConfig({this.jsonState});
}

class SetDeviceRelaysConfig {
  final int relayIndex;
  final String mode;
  final dynamic detail;

  SetDeviceRelaysConfig(this.relayIndex, {this.mode, this.detail});
}