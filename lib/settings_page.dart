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
    var appState = context.watch<MyAppState>();

    return Column(
      children: [
        Tooltip(
          message: 'Uses system settings. Override by turning off and using "dark mode".',
          child: SwitchListTile(
            title: const Text('System Theme'),
            value: appState.settings["system"]!,
            shape: Border.all(width: 2, color: Colors.red),
            onChanged: (bool? value) {
              setState(() {
                appState.changeSettings("system", value!);
              });
            },
          ),
        ),
        Tooltip(
          message: 'Light mode is default. Dark mode if toggled on.',
          child: SwitchListTile(
            title: const Text('Dark Mode'),
            value: appState.settings["dark"]!,
            onChanged: (bool? value) {
              setState(() {
                appState.changeSettings("dark", value!);
              });
            },
          ),
        ),
        Tooltip(
          message: 'Switch tooltip',
          child: SwitchListTile(
            title: const Text('Move Checked Items to Bottom'),
            value: appState.settings["moveChecked"]!,
            onChanged: (bool? value) {
              setState(() {
                appState.changeSettings("moveChecked", value!);
              });
            },
          ),
        ),
        Tooltip(
          message: 'Confirmation dialog when deleting Lists from History page.',
          child: SwitchListTile(
            title: const Text('Confirm History List Deletion'),
            value: appState.settings["confirmHistoryDelete"]!,	
            onChanged: (bool? value) {
              setState(() {
                appState.changeSettings("confirmHistoryDelete", value!);
              });
            },
          ),
        ),
      ],
    );
  }
}