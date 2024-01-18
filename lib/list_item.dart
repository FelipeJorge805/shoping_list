import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_list/file_storage.dart';
import 'package:shoping_list/main.dart';

class ListItem extends StatefulWidget{
  String label;
  bool checked = false;
  ListItem({Key? key, required this.label, required this.checked}) : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return "$label-$checked";
  }
}

class _ListItemState extends State<ListItem> {
  bool? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.checked;
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    

    var textController = TextEditingController();
    //textController.clear();
    //textController.selection = TextSelection.fromPosition(TextPosition(offset: textController.value.text.length));
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      value: _value,
      onChanged: (newValue) => setState(() => {
          _value = newValue,
          widget.checked = newValue!,
          appState.changeCheckState(widget.label, newValue),
          FileStorage().saveDataToFile('current.txt', appState.shoppingList.map((e) => e.toString()).join("\n")),
        }
      ),
      title: TextField(
        //autofocus: _focus,
        controller: textController..text = widget.label, 
        onSubmitted: (newName) => {
          appState.updateName(widget.label, newName),
          widget.label = newName,
          FileStorage().saveDataToFile('current.txt', appState.shoppingList.map((e) => e.toString()).join("\n")),
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Item',
        ),
      )
    );
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return _value.toString();
  }
}
