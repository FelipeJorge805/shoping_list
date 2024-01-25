import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shoping_list/list_item.dart';

class FileStorage{
  Future<String> get _localPath async {
    // Find the local directory for application.
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> getLocalFile(String filename) async {
    // Get the local path using the _localPath method.
    final path = await _localPath;
    return File('$path/$filename').create();
  }

  /*Future<File> saveDataToFile(String fileName, var data) async {
    // Write the variable as a string to the file.
    final file = await getLocalFile(fileName);
    return file.writeAsString('$data');
  }*/

  Future<String> readFile(String fileName) async {
    try {
      // Get the local file using the provided file name.
      final file = await getLocalFile(fileName);
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return an error message.
      return "Error";
    }
  }

  Future saveFavoritesList(List<String> favoritesList) async {
    final file = await getLocalFile('favorites.txt');
    file.writeAsString(favoritesList.join("\n"));
  }

  Future saveCurrentList(Set<ListItem> shoppingList) async {
    final file = await getLocalFile('current.txt');
    file.writeAsString(shoppingList.map((e) => e.toString()).join("\n"));
  }

  Future saveHistoryList(List<Set<ListItem>> allLists) async {
    final file = await getLocalFile('history.txt');
    file.writeAsString(allLists.map((e) => e.map((e) => e.toString()).join(",")).join("\n"));
  }
}