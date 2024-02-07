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
          widget.label!="" ? appState.changeCheckState(widget, newValue) : null,
        }
      ),
      title: TextField(
        //autofocus: _focus,
        /*onTapOutside: (focus) => {                        //text works but breaks checkbox above
          appState.updateName(widget, textController.text),
          widget.label = textController.text,
        },*/
        controller: textController..text = widget.label, 
        onSubmitted: (newName) => {
          appState.updateName(widget, newName),
          widget.label = newName,
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Item',
        ),
        style: TextStyle(
          decoration: _value! ? TextDecoration.lineThrough : null,
          color: _value! ? Colors.grey : null,
        )
      )
    );
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return _value.toString();
  }
}

class NewItem extends StatefulWidget {
  final String label;
  final String origin;

  const NewItem({
    super.key,
    this.label = "New Item",
    this.origin = "New Item",
  });

  @override
  State<NewItem> createState() => _NewItemState();

  factory NewItem.fromJson(Map<String, dynamic> json) {
    String label = json['label'];
    String origin = json['origin'];
    return NewItem(label: label, origin: origin);
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'origin': origin,
    };
  }
}

class _NewItemState extends State<NewItem> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return ListTile(
      leading: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          appState.addItemToList(ListItem(label: "", checked: false, origin: "current"));
        },
      ),
      title: Text(widget.label),
    );
  }
}
