import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_list/main.dart';

class FavoritesPage extends StatelessWidget{
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();
    var list = appState.favoritesList;

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
