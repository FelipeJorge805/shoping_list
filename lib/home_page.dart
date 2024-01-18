import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_list/favorites_page.dart';
import 'package:shoping_list/file_storage.dart';
import 'package:shoping_list/history_page.dart';
import 'package:shoping_list/list_page.dart';
import 'package:shoping_list/main.dart';

import 'list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.storage});

  final FileStorage storage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.storage.readFile('favorites.txt').then((String value) {
      if(value == "") return;
      setState(() {
        context.read<MyAppState>().favoritesList = List.of(value.split("\n").map((e) => ListItem(label: e, checked: false)));
      });
    });
    widget.storage.readFile('current.txt').then((String value) {
      if(value == "") return;
      setState(() {
        context.read<MyAppState>().shoppingList = Set.of(value.split("\n").map((e) => ListItem(label: e.split("-")[0], checked: e.split("-")[1] == "true")));
      });
    });
    widget.storage.readFile('history.txt').then((String value) {
      if(value == "") return;
      setState(() {
        context.read<MyAppState>().allLists = List.of(value.split("\n").map((e) => Set.from(e.split(",").map((e) => ListItem(label: e.split("-")[0], checked: e.split("-")[1] == "true")))));
        //context.read<MyAppState>().allLists = jsonDecode(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontStyle: FontStyle.italic
    );
    var appState = context.watch<MyAppState>(); 

    Widget page;
      switch(selectedIndex){
        case 0:
          page = const ListPage();
        case 1:
          page = const FavoritesPage();
        case 2:
          page = const HistoryPage();
        case 3:
          page = const Placeholder();
        default:
            throw UnimplementedError('No widget for $selectedIndex');
      }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: Center(child: Text("List", style: style,)),
            leading: const Icon(Icons.menu),
            backgroundColor: theme.colorScheme.primary,
          ),
          floatingActionButton: selectedIndex == 0 ? FloatingActionButton(
            onPressed: () => {
              appState.lastCreated = ListItem(key: const Key('Item'),label: "", checked: false),
              appState.addItemToList(),
            },
            /*showDialog<void>(
              //anchorPoint: Offset(dx, dy),
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: TextField(
                    autofocus: true,
                    autocorrect: true,
                    enableSuggestions: true,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'New Item'),
                    onSubmitted: (String value) => {
                      if(value != ""){
                        appState.lastCreated = ListItem(label: value), 
                        appState.addItemToList(),
                      },
                      Navigator.pop(context)
                    },
                  ),
                );
              }
            ),*/
            backgroundColor: theme.colorScheme.primary,
            child: const Icon(Icons.add),
          ) : null,
          bottomNavigationBar: SafeArea(
                  bottom: true,
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    //fixedColor: theme.colorScheme.primary,
                    backgroundColor: theme.colorScheme.onPrimary, 
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.format_list_numbered),
                        label: 'Lists',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite_border),
                        label: 'Favorites',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.history),
                        label: 'History',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: 'Settings',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
          ),
          body: Row(
            children: [
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}