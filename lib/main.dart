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
  ListItem? lastCreated;
  Set<ListItem> shoppingList = {};
  List<Set<ListItem>> allLists = [];
  List<ListItem> favoritesList = [];

  void addFavoriteItem(var item){
    favoritesList.add(item);
    notifyListeners();
  }

  void updateName(oldName, newName){
    bool changed = false;
    for (var item in shoppingList) {
      if(item.label == oldName){
        item.label = newName;
        changed = true;
        break;
      }
    }
    if(changed) notifyListeners();
  }

  void addItemToList(){
    shoppingList.add(lastCreated!);
    notifyListeners();
  }

  void addCurrentListToHistory(){
    if(shoppingList.isNotEmpty) allLists.add(Set.from(shoppingList));
    notifyListeners();
  }

  void removeItem(value){
    shoppingList.removeWhere((item) => item.label == value);
    notifyListeners();
  }

  changeCheckState(String label, bool newValue) {
    for (var item in shoppingList) {
      if(item.label == label){
        item.checked = newValue;
        break;
      }
    }
    notifyListeners();
  }

}
