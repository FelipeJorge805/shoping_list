import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
    List<bool> isSelected = [false, false];

  @override
  Widget build(BuildContext context) {
    

    return GridView.count(
      crossAxisCount: 2, // Number of columns in the grid
      children: [
        ToggleButtons(
          direction: Axis.vertical,
          constraints: BoxConstraints.expand(width: MediaQuery.of(context).size.width/3, height: MediaQuery.of(context).size.height/10),
          borderRadius: BorderRadius.circular(10.0), 
          borderWidth: 0,
          renderBorder: false,
          isSelected: isSelected,
          onPressed: (index) => {
            //isSelected[index] = !isSelected[index],
            //chanege state
            setState(() {isSelected[index] = !isSelected[index];})
          },
          children: [
            isSelected[0] ? const Icon(Icons.delete) : const Icon(Icons.delete_outline),
            isSelected[1] ? const Icon(Icons.delete) : const Icon(Icons.delete_outline),
            ],
        )
      ],
    );
  }
}