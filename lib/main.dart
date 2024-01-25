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
      appState.counter = appState.allLists.length;
    }
    List<String> names = await storage.readNames();
    if (names.isNotEmpty) {
      appState.listNames = names;
      appState.currentlistName = appState.listNames.removeLast();
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
  List<String> selectedItems = [];
  Set<ListItem> shoppingList = {};
  List<Set<ListItem>> allLists = [];
  List<String> favoritesList = [];
  Map<String,int> commonItems = {};
  int counter = 1;
  String currentlistName = "";
  List<String> listNames = [];
  ListItem? lastCreated;

  void addListName(String name){
    listNames.add(name);
    appendCurrentAndSave();
    notifyListeners();
  }


  void addFavoriteItem(var item){
    if(!favoritesList.contains(item)) {
      favoritesList.add(item);
      FileStorage().saveFavoritesList(favoritesList);
    }
    notifyListeners();  //needed to update the Dismissible widget even if data hasn't changed
  }

  void updateName(oldName, newName){
    for (var item in shoppingList) {
      if(item.label == oldName){
        item.label = newName;
        notifyListeners();
        FileStorage().saveCurrentList(shoppingList);
        break;
      }
    }
  }

  void addItemToList(){
    shoppingList.add(lastCreated!);
    FileStorage().saveCurrentList(shoppingList);
    notifyListeners();
  }

  void addCurrentListToHistory(){
    if(shoppingList.isNotEmpty) {
      allLists.add(Set.from(shoppingList));
      calculateCommonItems();
      counter++;
      FileStorage().saveHistoryList(allLists);
      notifyListeners();
    }
  }

  void calculateCommonItems() {
    commonItems.clear();
    if(allLists.length > 1) {
      for (var list in allLists) {
        for (var item in list) {
          commonItems.update(item.label.toLowerCase(), (value) => value + 1, ifAbsent: () => 1);
        }
      }
      commonItems = Map.fromEntries(commonItems.entries.toList()..sort((a, b) => b.value.compareTo(a.value)));
    }
  }

  void removeItem(value){
    shoppingList.removeWhere((item) => item.label == value);
    FileStorage().saveCurrentList(shoppingList);
    notifyListeners();
  }

  void changeCheckState(String label, bool newValue) {
    for (var item in shoppingList) {
      if(item.label == label){
        item.checked = newValue;
        FileStorage().saveCurrentList(shoppingList);
        notifyListeners();
        break;
      }
    }
  }

  void toggleFavorites(var item) {
    if(favoritesList.contains(item)){
      favoritesList.remove(item);
    }else {
      favoritesList.add(item);
    }
    FileStorage().saveFavoritesList(favoritesList);
    notifyListeners();
  }

  void reorderFavorites(int oldIndex, int newIndex) {
    final item = favoritesList.removeAt(oldIndex);
    favoritesList.insert(newIndex, item);
    FileStorage().saveFavoritesList(favoritesList);
    notifyListeners();
  }

  void addSelectedItem(String favoritesList) {
    selectedItems.add(favoritesList);
    notifyListeners();
  }

  void removeSelectedItem(String name) {
    selectedItems.remove(name);
    notifyListeners();
  }

  void addAllSelected() {
    for (var item in selectedItems) {
      shoppingList.add(ListItem(label: item, checked: false));
    }
    selectedItems.clear();
    FileStorage().saveCurrentList(shoppingList);
    notifyListeners();
  }

  void clearShoppingList() {
    shoppingList.clear();
    FileStorage().saveCurrentList(shoppingList);
    notifyListeners();
  }

  void removeList() { //currently removing the list at index from allLists via shallow copy from history_page's variable handle
    counter--;
    FileStorage().saveHistoryList(allLists);
    notifyListeners();
  }

  void addAllToCurrent(Set<ListItem> list, {required bool overwrite}) {
    if(overwrite) {
      shoppingList.clear();
    }
    shoppingList.addAll(list.map((item) => ListItem(label: item.label, checked: false)));
    FileStorage().saveCurrentList(shoppingList);
    notifyListeners();
  }
}
