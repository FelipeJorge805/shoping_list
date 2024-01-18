import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_list/file_storage.dart';
import 'package:shoping_list/list_item.dart';
import 'package:shoping_list/main.dart';

class HistoryPage extends StatefulWidget{
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    var history = context.watch<MyAppState>().allLists;

    if (history.isEmpty) {
      return const Center(
        child: Text('No history yet.'),
      );
    }

    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, listIndex) {
        var list = history[listIndex];
        return Dismissible(
          key: UniqueKey(),
          background: Container(
            alignment: AlignmentDirectional.centerEnd,
            color: Colors.red,
            child: const Icon(Icons.cancel),
          ),
          secondaryBackground: Container(
            alignment: AlignmentDirectional.centerEnd,
            color: Colors.red,
            child: const Icon(Icons.cancel),
          ),
          onDismissed: (direction) => {
            history.removeAt(listIndex),
            FileStorage().saveDataToFile('history.txt', history.map((e) => e.map((e) => e.toString()).join(",")).join("\n")),
          },
          confirmDismiss: (direction) => showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Delete list?"),
                content: const Text("Are you sure you want to delete this list? This action cannot be undone."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Delete"),
                  ),
                ],
              );
            },
          ),
          child: ExpansionTile(
            title: Text("List ${listIndex + 1}"),
              children: [
                for (var item in list)
                  ListItem(label: item.label, checked: item.checked)
                ],
          ),
        );
      },
    );
  }
}
