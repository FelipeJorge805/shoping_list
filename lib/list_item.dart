import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_list/main.dart';

class ListItem extends StatefulWidget{
  String label;
  bool checked = false;
  final String origin;
  ListItem({
    super.key, 
    required this.label, 
    required this.checked,
    required this.origin,
  });

  @override
  State<ListItem> createState() => _ListItemState();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return "$label-$checked";
  }

  factory ListItem.fromJson(Map<String, dynamic> json) {
    String label = json['label'];
    bool checked = json['checked'];
    String origin = json['origin'];
    return ListItem(label: label, checked: checked, origin: origin);
  }

  toJson() {
    return {
      'label': label,
      'checked': checked,
      'origin': origin,
    };
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
        }
      ),
      title: TextField(
        //autofocus: _focus,
        controller: textController..text = widget.label, 
        onSubmitted: (newName) => {
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

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return _value.toString();
  }
}
