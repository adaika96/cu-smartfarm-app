import 'package:flutter/material.dart';

import '../../common/editableButton.dart';

class RelayStateWidget extends StatelessWidget {
  final List<bool> relayState;
  final Function handleToggleRelayState;
  final List<String> relayDesc;
  final Function handleChangeRelayDesc;

  RelayStateWidget({
    @required this.relayState,
    @required this.handleToggleRelayState,
    @required this.relayDesc,
    @required this.handleChangeRelayDesc});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: this.relayState
          .asMap()
          .keys
          .map((index) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 30, minWidth: 80),
                  child:
                    EditableButton(initValue: this.relayDesc[index], onSubmit: (String newDesc){
                      relayDesc[index] = newDesc;
                      handleChangeRelayDesc(index, newDesc);
                    }, title: "Edit relay${index + 1} description", maxLength: 30,),
                ),
                this.relayState[index] == null ? new CircularProgressIndicator() : Switch(
                  value: this.relayState[index],
                  onChanged: (newState) {
                    handleToggleRelayState(index, newState);
                  },
                ),
              ]))
          .toList()
    );
  }
}
