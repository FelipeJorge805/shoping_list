import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_list/main.dart';

class ListItem extends StatefulWidget{
  String label;
  ListItem({Key? key, required this.label}) : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool? _value = false;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    

    var textController = TextEditingController();
    //textController.clear();
    //textController.selection = TextSelection.fromPosition(TextPosition(offset: textController.value.text.length));
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      value: _value, 
      onChanged: (newValue) => setState(() => _value = newValue),
      title: TextField(
        //autofocus: _focus,
        controller: textController..text = widget.label, 
        onSubmitted: (newName) => {
          //if(newName == "") newName = "New Item",
          appState.updateName(widget.label, newName),
          widget.label = newName,
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Item',
        ),
      )
    );
  }
}
