import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_list/favorites_page.dart';
import 'package:shoping_list/history_page.dart';
import 'package:shoping_list/list_page.dart';
import 'package:shoping_list/main.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;

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
          page = const SettingsPage();
        default:
            throw UnimplementedError('No widget for $selectedIndex');
      }

    return LayoutBuilder(
      builder: (context, constraints) {
        Widget title;
        switch(selectedIndex){
              case 0: title = Text("Current", style: style,);
              case 1: title = Text("Favorites", style: style,);
              case 2: title = Text("History", style: style,);
              case 3: title = Text("Settings", style: style,);
              default: title = Text("List", style: style,);
        }
        return Scaffold(
          appBar: AppBar(
            title: title,
            //leading: const Icon(Icons.menu),
            backgroundColor: theme.colorScheme.primary,
            centerTitle: true,
            toolbarHeight: constraints.maxHeight * 0.06,
          ),
          floatingActionButton: selectedIndex != 0 ? null : 
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              verticalDirection: VerticalDirection.up,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const SizedBox(width: 10,),
                FloatingActionButton(   //clear list button
                  onPressed: () {
                    if(appState.settings["confirmCurrentDeletion"]!){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => MyDialog(
                          text: "This will delete the List without saving it.", 
                          onOk: () => appState.clearShoppingList()
                        ),
                      );
                      appState.settings["confirmCurrentDeletion"] = false;
                    }else{
                      appState.clearShoppingList();
                    }
                  },
                  backgroundColor: theme.colorScheme.primary,
                  child: const Icon(Icons.delete),
                ),
                const SizedBox(width: 10,),
                FloatingActionButton(   //save list button
                  onPressed: () => {
                    appState.addCurrentListToHistory(),
                  },
                  backgroundColor: theme.colorScheme.primary,
                  child: const Icon(Icons.save_alt),
                ),
                const SizedBox(width: 10,),
                FloatingActionButton(   //add item button
                  onPressed: () {
                    appState.createList();
                  },
                  backgroundColor: theme.colorScheme.primary,
                  child: const Icon(Icons.add),
                ),
              ],
            )
          ),
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

class MyDialog extends StatelessWidget {
  final TextEditingController textController = TextEditingController();
  final String text;
  final Function onOk;
  
  MyDialog({super.key, required this.text, required this.onOk});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(text),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Perform "OK" button functionality here
            onOk();
            Navigator.of(context).pop();
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
