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
      appState.shoppingList = List.of(currentValue.split("\n").map((e) => ListItem(label: e.split("-")[0], checked: e.split("-")[1] == "true")));
    }
    //context.read<MyAppState>().allLists = jsonDecode(value);
    String historyValue = await storage.readFile('history.txt');
    if(historyValue != "") {
      appState.allLists = List.of(historyValue.split("\n").map((e) => List.from(e.split(",").map((e) => ListItem(label: e.split("-")[0], checked: e.split("-")[1] == "true")))));
      appState.listCounter = appState.allLists.length+1;
      appState.calculateCommonItems();
    }
    List<String> names = await storage.readNames();
    if (names.isNotEmpty) {
      appState.listNames = names;
      appState.currentlistName = appState.listNames.removeLast();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    bool system = appState.settings[0];
    bool dark = appState.settings[1];

    return ChangeNotifierProvider(
      create: (context) => appState,
      child: MaterialApp(
        title: 'List',
        themeMode: system ? ThemeMode.system : (dark ? ThemeMode.dark : ThemeMode.light),
        theme: ThemeData(
          //brightness: Brightness.light,
          useMaterial3: false,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: false,
          colorScheme: ColorScheme.dark(primary: Colors.grey, brightness: Brightness.dark)//.fromSeed(seedColor: Colors.black, brightness: Brightness.dark),
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
  List<ListItem> shoppingList = [];
  List<List<ListItem>> allLists = [];
  List<String> favoritesList = [];
  Map<String,int> commonItems = {};
  int listCounter = 1;
  String currentlistName = "|";
  List<String> listNames = [];
  List<bool> settings = [false, false, false];

  void addListName(String name){
    listNames.add(name);
    appendCurrentAndSave();
    notifyListeners();
  }

  void removeListName(String name){
    listNames.remove(name);
    appendCurrentAndSave();
    notifyListeners();
  }

  void updateListName(String oldName, String newName){
    int index = listNames.indexOf(oldName);
    if (index != -1) {
      listNames.removeAt(index);
      listNames.insert(index, newName);
      appendCurrentAndSave();
      notifyListeners();
    }
  }

  void setCurrentListName(String name){
    currentlistName = name;
    appendCurrentAndSave();
    notifyListeners();
  }

  void appendCurrentAndSave() {
    List<String> updatedListNames = [...listNames, currentlistName];
    FileStorage().saveNames(updatedListNames);
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

  void addItemToList(ListItem lastCreated){
    shoppingList.add(lastCreated);
    setCurrentListName("List-$listCounter|${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
    FileStorage().saveCurrentList(shoppingList);
    notifyListeners();
  }

  void addCurrentListToHistory(){
    if(shoppingList.isNotEmpty) {
      allLists.add(List.from(shoppingList));
      calculateCommonItems();
      listCounter++;
      addListName(currentlistName);
      FileStorage().saveHistoryList(allLists);
      notifyListeners();
    }
  }

  void calculateCommonItems() {
    commonItems.clear();
    if(allLists.isNotEmpty) {
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
        reorderOnCheck(item, newValue);
        FileStorage().saveCurrentList(shoppingList);
        notifyListeners();
        break;
      }
    }
  }

  void reorderOnCheck(ListItem item, bool newValue) {
    if(newValue) {
      shoppingList.remove(item);
      shoppingList.add(item);
    }else {
      shoppingList.remove(item);
      shoppingList.insert(0, item);
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
    setCurrentListName("List-$listCounter|${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
    FileStorage().saveCurrentList(shoppingList);
    notifyListeners();
  }

  void clearShoppingList() {
    shoppingList.clear();
    FileStorage().saveCurrentList(shoppingList);
    notifyListeners();
  }

  void removeListFromHistory() { //currently removing the list at index from allLists via shallow copy from history_page's variable handle
    listCounter--;
    FileStorage().saveHistoryList(allLists);
    notifyListeners();
  }

  void addAllToCurrent(List<ListItem> list, {required bool overwrite}) {
    if(overwrite) {
      shoppingList.clear();
    }
    shoppingList.addAll(list.map((item) => ListItem(label: item.label, checked: false)));
    setCurrentListName("List-$listCounter|${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
    FileStorage().saveCurrentList(shoppingList);
    notifyListeners();
  }
}
