import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'List',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow.shade500),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  ListItem? lastCreated;
  Set<ListItem> shoppingList = {};
  List<Set<ListItem>> allLists = [];

  void addItemToList(){
    shoppingList.add(lastCreated!);
    notifyListeners();
  }

  void addCurrentListToHistory(){
    if(shoppingList.isNotEmpty) allLists.add(shoppingList);
    notifyListeners();
  }

  void removeItem(value){
    shoppingList.removeWhere((item) => item.label == value);
    notifyListeners();
  }
}

class ListItem extends StatefulWidget{
  final String label;

  const ListItem({Key? key, required this.label}) : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool? _value = false;

  @override
  Widget build(BuildContext context) {
    
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      value: _value, 
      onChanged: (newValue) => setState(() => _value = newValue),
      title: TextField(controller: TextEditingController()..text = widget.label, onChanged: (text) => {},)
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
              onPressed: () => showDialog<void>(
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
              ),
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.add),
            ) : null,
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail( //swap for NavBar
                  //extended: constraints.maxWidth >= 600,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.format_list_numbered),
                      label: Text('Lists'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite_border),
                      label: Text('Favorites'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.history),
                      label: Text('History'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      label: Text('Settings'),
                    ),
                  ],
                  //trailing: IconButton(icon: const Icon(Icons.settings), onPressed: (){}, ),
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
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

class HistoryPage extends StatelessWidget{
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    var history = context.watch<MyAppState>().allLists;

    if (history.isEmpty) {
      return const Center(
        child: Text('No history yet.'),
      );
    }

    return Column(
      children: [
        for(var list in history)
          ListTile(
            title: Text("List ${history.indexOf(list) + 1}"),
            subtitle: ListView(
              children: [
                for (var item in list)
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(item.label),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class FavoritesPage extends StatelessWidget{
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();
    var list = appState.shoppingList;

    if (list.isEmpty) {
      return const Center(
        child: Text('No favorite items yet.'),
      );
    }

    //var title = TextField(controller: TextEditingController()..text = "Favorite items");

    return ListTile(
      //onTap: () => TextField(onSubmitted: (value) => {},),
      title: const Text("Favorite items"),
      subtitle: ListView(
        children: [
          for (var item in list)
            ListTile(
              leading: const Icon(Icons.favorite),
              title: Text(item.label),
            ),
          ],
      )
    );
  }
}

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
          onDismissed: (direction) => {appState.shoppingList.clear(),},
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
              onDismissed:(direction) => {appState.removeItem(item.label),},
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
              movementDuration: const Duration(milliseconds: 100),
              resizeDuration: const Duration(milliseconds: 150),
              child: ListItem(label: item.label)
              )
        ],
      ),
    );
  }
}
