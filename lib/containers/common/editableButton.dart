import 'package:flutter/material.dart';

import './editDialog.dart';
class EditableButton extends StatefulWidget {
  final int width, maxLength;
  final String initValue;
  final String title;
  final Function onSubmit;

  const EditableButton({Key key, this.initValue, this.width, @required this.onSubmit, this.title, this.maxLength}) : super(key: key);

  @override
  _EditableButtonState createState() => _EditableButtonState();

}

class _EditableButtonState extends State<EditableButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        child: Row(
          // alignment: WrapAlignment.center,
          // crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(widget.initValue, style: TextStyle(fontSize: 12), textAlign: TextAlign.center,),
            ),
            Icon(Icons.edit, size: 12,)
          ],
        ),
        onPressed: () async {
          String newDesc = await editDialog(context, initialVal: widget.initValue, title: widget.title, maxLength: widget.maxLength);
          if(newDesc != null){
            widget.onSubmit(newDesc);
          }
        },
      );
      // :Wrap(
      //   alignment: WrapAlignment.center,
      //   children: <Widget>[
      //     // Container(
      //     //   width: widget.width  ?? 50,
      //     //   height: 20,
      //       // child:
      //       TextField(controller: _text,),
      //     // ),
      //     IconButton(icon: Icon(Icons.check), onPressed: (){
      //       setState(() {
      //         widget.onSubmit(_text.text);
      //         isEditing = false;
      //       });
      //     },),
      //     IconButton(icon: Icon(Icons.clear), onPressed: (){setState((){isEditing = false;});},)
      //   ],
      // );
  }
}
