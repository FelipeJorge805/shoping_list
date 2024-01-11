import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_list/main.dart';
import 'list_item.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return ListTile(
        /*leading: //save button
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => {appState.addCurrentListToHistory(), appState.shoppingList.clear(),}
          ),*/
        title: Dismissible(
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
          onDismissed: (direction) => {
              appState.shoppingList.clear(),
            },
          confirmDismiss:(direction) => showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Clear list?"),
                content: const Text("Are you sure you want to clear the entire list?\nYou can save it instead by tapping instead of swiping."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Clear"),
                  ),
                ],
              );
            },
          ),
          child: TextButton.icon(
            onPressed: () => {
              appState.addCurrentListToHistory(),
              appState.shoppingList.clear(),
            },
            label: const Text('Current list'),
            icon: //save icon
              const Icon(Icons.save_alt),
          )
        ),
        subtitle: ListView(
        children: [
          for (var item in appState.shoppingList) 
            Dismissible(
              key: UniqueKey(),
              onDismissed:(direction) => {
                if(direction == DismissDirection.startToEnd) appState.addFavoriteItem(item),
                if(direction == DismissDirection.endToStart) appState.removeItem(item.label),
                },
              background: Container(
                alignment: AlignmentDirectional.centerStart,
                color: Colors.green,
                child: const Icon(Icons.favorite_border),
                ),
              secondaryBackground: Container(
                alignment: AlignmentDirectional.centerEnd,
                color: Colors.red,
                child: const Icon(Icons.cancel),
                ),
              movementDuration: const Duration(milliseconds: 100),
              resizeDuration: const Duration(milliseconds: 150),
              child: ListItem(label: item.label)
              )
        ],
      ),
    );
  }
}
