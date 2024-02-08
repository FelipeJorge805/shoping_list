import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_list/list_item.dart';
import 'package:shoping_list/main.dart';

import 'history_list_item.dart';

class HistoryPage extends StatefulWidget{
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var history = appState.history;

    if (history.isEmpty) {
      return const Center(
        child: Text('No history yet.'),
      );
    }

    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, listIndex) {
        var list = history[listIndex].list;
        return GestureDetector(
          onLongPress: () {
            showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Make this list your current list?"),
                  content: const Text("Are you sure you want to make this list your current list?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        appState.addAllToCurrent(list, overwrite: false);
                        Navigator.of(context).pop(true);
                      },
                      child: const Text("Add"),
                    ),
                    TextButton(
                      onPressed: () {
                        appState.addAllToCurrent(list, overwrite: true);
                        Navigator.of(context).pop(true);
                      },
                      child: const Text("Overwrite"),
                    ),
                  ],
                );
              },
            );
          },
          child: Dismissible(
            key: UniqueKey(),
            background: Container(
              alignment: AlignmentDirectional.centerStart,
              color: Colors.red,
              child: const Icon(Icons.cancel),
            ),
            secondaryBackground: Container(
              alignment: AlignmentDirectional.centerEnd,
              color: Colors.red,
              child: const Icon(Icons.cancel),
            ),
            onDismissed: (direction) {
              setState(() {
                history.removeAt(listIndex);
                appState.removeListFromHistory();
                //appState.removeListName(appState.listNames[listIndex]);
              });
            },
            confirmDismiss:
              appState.settings["confirmHistoryDeletion"]! ? 
                (direction) => showDialog<bool>(
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
                )
              : null,
            child: history[listIndex] = HistoryListItem(
              name: history[listIndex].name, 
              date: history[listIndex].date,
              list: List.from(list.map((item) => ListItem(label: item.label, checked: item.checked, origin: "history-$listIndex"))),
              expanded: history[listIndex].expanded,
            )
          ),
        );
      },
    );
  }
}