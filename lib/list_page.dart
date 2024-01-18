import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_list/file_storage.dart';
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
          onDismissed: (direction) => {     //clear current list button
              appState.shoppingList.clear(),
              FileStorage().saveDataToFile('current.txt', ''),
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
            onPressed: () => {  //save current list button
              appState.addCurrentListToHistory(),
              appState.shoppingList.clear(),
              FileStorage().saveDataToFile('current.txt', ''),
              FileStorage().saveDataToFile('history.txt', appState.allLists.map((e) => e.map((e) => e.toString()).join(",")).join("\n")),
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
                if(direction == DismissDirection.startToEnd) {  //favorite item
                  appState.addFavoriteItem(item),
                  FileStorage().saveDataToFile('favorites.txt', appState.favoritesList.map((e) => e.label).join("\n")),
                },
                if(direction == DismissDirection.endToStart) {  //delete item
                  appState.removeItem(item.label),
                  FileStorage().saveDataToFile('current.txt', appState.shoppingList.map((e) => e.toString()).join("\n")),
                  }
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
              child: ListItem(label: item.label, checked: item.checked,)
              )
        ],
      ),
    );
  }
}
