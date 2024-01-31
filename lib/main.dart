import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_list/file_storage.dart';
import 'package:shoping_list/history_list_item.dart';

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
      appState.shoppingList = List.of(currentValue.split("\n").map((e) => ListItem(label: e.split("-")[0], checked: e.split("-")[1] == "true", origin: e.split("-")[2])));
    }
    //context.read<MyAppState>().allLists = jsonDecode(value);
    List<HistoryListItem> historyValue = await storage.readHistory();
    if(historyValue.isNotEmpty) {
      appState.history = historyValue;
      appState.listCounter = appState.history.length+1;
      appState.calculateCommonItems();
    }
    List<String> names = await storage.readNames();
    if (names.isNotEmpty) {
      appState.listNames = names;
      appState.currentlistName = appState.listNames.removeLast();
    }
    List<bool> settings = await storage.readSettings();
    if(settings.isNotEmpty) {
      appState.settings = settings;
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
  List<HistoryListItem> history = [];
  List<String> favoritesList = [];
  Map<String,int> commonItems = {};
  int listCounter = 1;
  int checkedCounter = 0;
  String currentlistName = "|";
  List<String> listNames = [];
  List<bool> settings = [false, false, false, false];

  void changeSettings(int index, bool value) {
    settings[index] = value;
    FileStorage().saveSettings(settings);
    notifyListeners();
  }

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

  void addFavoriteItem(String name){
    if(name != "" && !favoritesList.contains(name)) {
      favoritesList.add(name);
      FileStorage().saveFavoritesList(favoritesList);
    }
    notifyListeners();  //needed to update the Dismissible widget even if data hasn't changed
  }

  void updateName(item, newName){
    item.label = newName;
    notifyListeners();
    if(item.origin=="current") FileStorage().saveCurrentList(shoppingList);
    if(item.origin=="history") FileStorage().saveHistoryList(history);
  }

  void addItemToList(ListItem lastCreated){
    shoppingList.insert(shoppingList.length-checkedCounter,lastCreated);
    setCurrentListName("List-$listCounter|${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
    FileStorage().saveCurrentList(shoppingList);
    notifyListeners();
  }

  void addCurrentListToHistory(){
    if(shoppingList.isNotEmpty) {
      history.add(HistoryListItem(name: currentlistName.split("|")[0], date: currentlistName.split("|")[1], list: List.from(shoppingList)));
      calculateCommonItems();
      listCounter++;
      addListName(currentlistName);
      FileStorage().saveHistoryList(history);
      notifyListeners();
    }
  }

  void calculateCommonItems() {
    commonItems.clear();
    if(history.isNotEmpty) {
      for (var historyItem in history) {
        for (var item in historyItem.list) {
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

  void changeCheckState(ListItem item, bool newValue) {
    item.checked = newValue;
    if(item.origin=="current" && settings[2]) reorderOnCheck(item, newValue);
    newValue ? checkedCounter++ : checkedCounter--; //after a potential reorderOnCheck call
    if(item.origin=="current")FileStorage().saveCurrentList(shoppingList);
    notifyListeners();
  }

  void reorderOnCheck(ListItem item, bool newValue) {
    int length = shoppingList.length;
    if(length == 1) return; //if only one item, don't reorder
    if(newValue) {  //move to bottom
      shoppingList.remove(item);
      shoppingList.insert(length-1-checkedCounter,item);
    }else { //move to top
      shoppingList.remove(item);
      shoppingList.insert(length-checkedCounter, item);
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
      shoppingList.add(ListItem(label: item, checked: false, origin: "current"));
    }
    selectedItems.clear();
    setCurrentListName("List-$listCounter|${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
    FileStorage().saveCurrentList(shoppingList);
    notifyListeners();
  }

  void clearShoppingList() {
    shoppingList.clear();
    checkedCounter = 0;
    FileStorage().saveCurrentList(shoppingList);
    notifyListeners();
  }

  void removeListFromHistory() { //currently removing the list at index from allLists via shallow copy from history_page's variable handle
    listCounter--;
    FileStorage().saveHistoryList(history);
    notifyListeners();
  }

  void addAllToCurrent(List<ListItem> list, {required bool overwrite}) {
    if(overwrite) {
      clearShoppingList();
    }
    shoppingList.addAll(list.map((item) => ListItem(label: item.label, checked: false, origin: "current")));
    setCurrentListName("List-$listCounter|${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
    FileStorage().saveCurrentList(shoppingList);
    notifyListeners();
  }
}
