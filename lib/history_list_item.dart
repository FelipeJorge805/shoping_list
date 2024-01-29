import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_list/list_item.dart';
import 'package:shoping_list/main.dart';

class HistoryListItem extends StatefulWidget {
  final String name;
  final String date;
  final List<ListItem> list;

  const HistoryListItem({
    Key? key,
    required this.name,
    required this.date,
    required this.list,
  }) : super(key: key);
  
  @override
  HistoryListItemState createState() => HistoryListItemState();

  factory HistoryListItem.fromJson(Map<String, dynamic> json) {
    return HistoryListItem(
      name: json['name'],
      date: json['date'],
      list: List<ListItem>.from(json['list'].map((item) => ListItem.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date,
      'list': list.map((item) => item.toJson()).toList(),
    };
  }
}

class HistoryListItemState extends State<HistoryListItem> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var history = appState.allLists;

    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
      subtitle: Text("${widget.list.where((element) => element.checked).length}/${widget.list.length}"),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 20,
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Colors.transparent,
                labelText: widget.name,
              ),
              onSubmitted: (value) {
                appState.updateListName('${widget.name}|${widget.date}', value);
              },
            ),
          ),
          Text(widget.date),
        ],
      ),
      children: [
        for (var item in widget.list) ListItem(label: item.label, checked: item.checked)
      ],
    );
  }
}