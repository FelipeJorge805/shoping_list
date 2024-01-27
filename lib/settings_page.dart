import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_list/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    List<bool> isSwitched = context.watch<MyAppState>().settings;

    return GridView.count(
      crossAxisCount: 2, // Number of columns in the grid
      childAspectRatio: 3.5, 
      children: [
        Tooltip(
          message: 'Uses system settings. Override by turning off and using "dark mode".',
          child: SwitchListTile(
            title: const Text('System Theme'),
            value: isSwitched[0],
            shape: Border.all(width: 2, color: Colors.red),
            onChanged: (bool? value) {
              setState(() {
                isSwitched[0] = value!;
              });
            },
          ),
        ),
        Tooltip(
          message: 'Light mode is default. Dark mode if toggled on.',
          child: SwitchListTile(
            title: const Text('Dark Mode'),
            value: isSwitched[1],
            onChanged: (bool? value) {
              setState(() {
                isSwitched[1] = value!;
              });
            },
          ),
        ),
        Tooltip(
          message: 'Switch tooltip',
          child: SwitchListTile(
            title: const Text('Move Checked Items to Bottom'),
            value: isSwitched[2],
            onChanged: (bool? value) {
              setState(() {
                isSwitched[2] = value!;
              });
            },
          ),
        ),
        Tooltip(
          message: 'Confirmation dialog when deleting Lists from History page.',
          child: SwitchListTile(
            title: const Text('Confirm History List Deletion'),
            value: isSwitched[3],
            onChanged: (bool? value) {
              setState(() {
                isSwitched[3] = value!;
              });
            },
          ),
        ),
      ],
    );
  }
}