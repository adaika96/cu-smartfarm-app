import 'package:flutter/material.dart';

@immutable
class RelayAutoConfigDetailEditor extends StatefulWidget {
  final Map<String, dynamic> initVal;

  RelayAutoConfigDetailEditor({this.initVal, Key key}) : super(key: key);

  @override
  RelayAutoConfigDetailEditorState createState() =>
      RelayAutoConfigDetailEditorState();
}

class RelayAutoConfigDetailEditorState
    extends State<RelayAutoConfigDetailEditor> {
  Map<String, dynamic> _val;
  Map<String, dynamic> get val {
    return {
      "sensor": _val["sensor"],
      "symbol": _val["symbol"],
      "trigger": num.parse(textInput.text)
    };
  }

  TextEditingController textInput = TextEditingController();
  @override
  void initState() {
    if (widget.initVal != null) {
      textInput.text = "${widget.initVal["trigger"]}";
      _val = widget.initVal;
    } else {
      _val = Map<String, dynamic>();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Text("Turn on relay when: "),
          margin: EdgeInsets.symmetric(vertical: 10),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
                flex: 1,
                child: DropdownButtonHideUnderline(
                  child: new DropdownButton<String>(
                    isExpanded: true,
                    items: ["humidity", "soil", "temp"].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _val["sensor"] = value;
                      });
                    },
                    hint: Text("Sensor"),
                    value: _val["sensor"],
                  ),
                )),
            Expanded(
                flex: 1,
                child: DropdownButtonHideUnderline(
                  child: new DropdownButton<String>(
                    isExpanded: true,
                    items: ["<", ">"].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _val["symbol"] = value;
                      });
                    },
                    hint: Text("less / more"),
                    value: _val["symbol"],
                  ),
                )),
            Expanded(
                flex: 1,
                child: TextFormField(
                  controller: textInput,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Set point',
                      contentPadding: EdgeInsets.all(5),
                      border: InputBorder.none),
                )),
          ],
        )
      ],
    );
  }
}
