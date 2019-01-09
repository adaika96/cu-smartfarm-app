import 'package:flutter/material.dart';

class RelayStateWidget extends StatelessWidget {
  final List<bool> relayState;
  final Function handleToggleRelayState;

  RelayStateWidget({this.relayState, this.handleToggleRelayState});

  @override
  Widget build(BuildContext context) {
    return relayState.length == 5 ? Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: this.relayState
          .asMap()
          .keys
          .map((index) => Column(children: <Widget>[
                Text("Relay${index + 1}"),
                Switch(
                  value: this.relayState[index],
                  onChanged: (newState) {
                    handleToggleRelayState(index, newState);
                  },
                )
              ]))
          .toList()
    ) : Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[new CircularProgressIndicator()],);
  }
}
