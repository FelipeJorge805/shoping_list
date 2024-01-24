import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_list/file_storage.dart';

import 'home_page.dart';
import 'list_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FileStorage storage = FileStorage();
  MyAppState appState = MyAppState();

  Future<void> loadFiles() async {
    String favoritesValue = await storage.readFile('favorites.txt');
    if(favoritesValue != "") {
      appState.favoritesList = List.of(favoritesValue.split("\n"));
    }
    String currentValue = await storage.readFile('current.txt');
    if(currentValue != "") {
      appState.shoppingList = Set.of(currentValue.split("\n").map((e) => ListItem(label: e.split("-")[0], checked: e.split("-")[1] == "true")));
    }
    //context.read<MyAppState>().allLists = jsonDecode(value);
    String historyValue = await storage.readFile('history.txt');
    if(historyValue != "") {
      appState.allLists = List.of(historyValue.split("\n").map((e) => Set.from(e.split(",").map((e) => ListItem(label: e.split("-")[0], checked: e.split("-")[1] == "true")))));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => appState,
      child: MaterialApp(
        title: 'List',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow.shade500),
        ),
        home: FutureBuilder(
          future: loadFiles(),
          builder:(context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }else if(snapshot.hasError){
              return const Center(child: Text("Error"));
            }else{
              return const HomePage();
            }
          },
        )
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  Set<ListItem> shoppingList = {};
  List<Set<ListItem>> allLists = [];
  List<ListItem> favoritesList = [];
  ListItem? lastCreated;

  void addFavoriteItem(var item){
    if(!favoritesList.contains(item)) {
      favoritesList.add(item);
      FileStorage().saveDataToFile('favorites.txt', favoritesList.join("\n"));
      notifyListeners();
    }
  }

  void updateName(oldName, newName){
    for (var item in shoppingList) {
      if(item.label == oldName){
        item.label = newName;
        notifyListeners();
        FileStorage().saveDataToFile('current.txt', shoppingList.map((e) => e.toString()).join("\n"));
        break;
      }
    }
  }

  void addItemToList(){
    shoppingList.add(lastCreated!);
    FileStorage().saveDataToFile('current.txt', shoppingList.map((e) => e.toString()).join("\n"));
    notifyListeners();
  }

  void addCurrentListToHistory(){
    if(shoppingList.isNotEmpty) {
      allLists.add(Set.from(shoppingList));
      FileStorage().saveDataToFile('history.txt', allLists.map((e) => e.map((e) => e.toString()).join(",")).join("\n"));
      notifyListeners();
    }
  }

  void removeItem(value){
    shoppingList.removeWhere((item) => item.label == value);
    FileStorage().saveDataToFile('current.txt', shoppingList.map((e) => e.toString()).join("\n"));
    notifyListeners();
  }

  void changeCheckState(String label, bool newValue) {
    for (var item in shoppingList) {
      if(item.label == label){
        item.checked = newValue;
        FileStorage().saveDataToFile('current.txt', shoppingList.map((e) => e.toString()).join("\n"));
        notifyListeners();
        break;
      }
    }
    notifyListeners();
  }

  void toggleFavorites(var item) {
    if(favoritesList.contains(item)){
      favoritesList.remove(item);
    }else {
      favoritesList.add(item);
    }
    FileStorage().saveDataToFile('favorites.txt', favoritesList.join("\n"));
    notifyListeners();
  }
    notifyListeners();
  }
}
