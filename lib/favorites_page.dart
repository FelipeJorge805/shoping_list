import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_list/main.dart';

class FavoritesPage extends StatelessWidget{
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();
    List<String> list = appState.favoritesList;

    if (list.isEmpty) {
      return const Center(
        child: Text('No favorite items yet.'),
      );
    }

    //var title = TextField(controller: TextEditingController()..text = "Favorite items");

    return ReorderableListView(
      proxyDecorator: (child, index, animation) {
        return Material(
          color: Theme.of(context).primaryColor.withOpacity(0.6),
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: child
        );
      },
      padding: const EdgeInsets.all(8),
      header: const Text("Favorite items", style: TextStyle(fontSize: 18)),
      children: list.map((item) {
        return ListTile(
          key: Key(item),
          title: Text(item),
          leading: IconButton(
            icon: appState.favoritesList.contains(item)
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border),
            onPressed: () {
              appState.toggleFavorites(item);
            },
          ),
        );
      }).toList(),
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        appState.reorderFavorites(oldIndex, newIndex);
      },
    );
  }
}
