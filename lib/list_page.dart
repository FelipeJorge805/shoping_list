import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_list/main.dart';
import 'list_item.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var mostCommon10 = appState.commonItems.keys.take(10).toList();
    mostCommon10 = mostCommon10.map((item) => item.replaceFirst(item[0], item[0].toUpperCase())).toList();

    if (appState.shoppingList.isEmpty && appState.favoritesList.isEmpty) {
      return const Center(
        child: Text(textAlign: TextAlign.center, 'No items yet.\n\n You can later create lists based on favorites and most common items \n\nClick the + button to add items to your list.'),
      );
    }

    if (appState.shoppingList.isEmpty && appState.favoritesList.isNotEmpty) {
      return Column(
        //mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(textAlign: TextAlign.center, "Select items from favorites and most common.\n Add them to your current list.\n Or start an empty list."),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Align(child: Text("Favorites", style: TextStyle(fontSize: 16)))),
              Expanded(child: Align(child: Text('Most Common', style: TextStyle(fontSize: 16),))),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: double.infinity,
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left:8,bottom: 8,top: 8,right: 4), //gets the container away from the edge
                  //alignment: Alignment.topLeft,
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.5-12, 
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    //shrinkWrap: true,
                    padding: const EdgeInsets.all(4),
                    itemCount: appState.favoritesList.length,
                    itemBuilder: (context, index) {
                      return FavoriteListItem(name: appState.favoritesList[index], key: ValueKey(index), icon: true);
                    }
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left:4,bottom: 8,top: 8,right: 8), //gets the container away from the edge
                  //alignment: Alignment.topLeft,
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.5-12, 
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    //shrinkWrap: true,
                    itemCount: mostCommon10.length,
                    itemBuilder: (context, index) {
                      return FavoriteListItem(name: mostCommon10[index], key: ValueKey(index), icon: false);
                    }
                  ),
                ),
                //Text('Add some items to your list by tapping the + button below.'),
              ],
            ),
          ),
          const Spacer(),
          const Text('Add new or selected items to your list with the + button.'),
        ],
      );
    }

    return ListTile(
      /*leading: //save button
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: () => {appState.addCurrentListToHistory(), appState.shoppingList.clear(),}
        ),*/
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
        children: [
          Text(appState.currentlistName),
          Text(appState.currentDate)
        ]
      ),
      /*Dismissible(
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
      ),*/
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
              child: ListItem(label: item.label, checked: item.checked, origin: "current")
            )
        ],
      ),
    );
  }
}

class FavoriteListItem extends StatefulWidget {
  final String name;
  final bool icon;

  const FavoriteListItem({required Key key, required this.name, required this.icon}) : super(key: key);

  @override
  FavoriteListItemState createState() => FavoriteListItemState();
}

class FavoriteListItemState extends State<FavoriteListItem> {
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
        leading: widget.icon ? Icon(Icons.favorite, size: 16, color: selected ? Colors.grey : null) : null,
        onTap: () {
          if(!selected) {
            appState.addSelectedItem(widget.name);
          } else {
            appState.removeSelectedItem(widget.name);
          }
          setState(() {
            selected = !selected;
          });
        },
      ),
    );
  }
}