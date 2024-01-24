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
        onDismissed: (direction) => {     //clear current list button
            appState.clearShoppingList(),
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
            appState.clearShoppingList(),
            appState.addCurrentListToHistory(),
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
                  appState.addFavoriteItem(item.label),
                },
                if(direction == DismissDirection.endToStart) {  //delete item
                  appState.removeItem(item.label),
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
              resizeDuration: null,
              child: ListItem(label: item.label, checked: item.checked,)
            )
        ],
      ),
    );
  }
}

class FavoriteListItem extends StatefulWidget {
  final String name;

  const FavoriteListItem({required Key key, required this.name}) : super(key: key);

  @override
  _FavoriteListItemState createState() => _FavoriteListItemState();
}

class _FavoriteListItemState extends State<FavoriteListItem> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        selectedTileColor: Colors.blue,
        selected: selected,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        horizontalTitleGap: 10,
        minLeadingWidth: 0,
        minVerticalPadding: 0,
        contentPadding: const EdgeInsets.all(5),
        title: Text(widget.name),
        leading: Icon(Icons.favorite, size: 16, color: selected ? Colors.grey : null),
        onTap: () {
          setState(() {
            selected = !selected;
          });
          appState.addSelectedItem(widget.name);
        },
      ),
    );
  }
}