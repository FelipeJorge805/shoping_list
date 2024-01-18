import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_list/list_item.dart';
import 'package:shoping_list/main.dart';

class FavoritesPage extends StatelessWidget{
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();
    List<ListItem> list = appState.favoritesList;

    if (list.isEmpty) {
      return const Center(
        child: Text('No favorite items yet.'),
      );
    }

    //var title = TextField(controller: TextEditingController()..text = "Favorite items");

    return ListTile(
      //onTap: () => TextField(onSubmitted: (value) => {},),
      title: const Text("Favorite items"),
      subtitle: AnimatedList(
        initialItemCount: list.length,
        itemBuilder: (context, index, animation) {
          print("index: $index");
          ListItem item = list[index];
          return SizeTransition(
            sizeFactor: animation,
            child: TextButton.icon(
              onPressed: () {
                appState.toggleFavorites(item);
              },
              icon: appState.favoritesList.contains(item)
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
              label: Text(item.label),
            ),
          );
        },
      ),
    );
  }
}
