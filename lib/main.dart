import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_list/file_storage.dart';

import 'home_page.dart';
import 'list_item.dart';

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
        home: HomePage(storage: FileStorage()),
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
    bool changed = false;
    for (var item in shoppingList) {
      if(item.label == oldName){
        item.label = newName;
        notifyListeners();
        FileStorage().saveDataToFile('current.txt', shoppingList.map((e) => e.toString()).join("\n"));
        break;
      }
    }
    if(changed) notifyListeners();
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
