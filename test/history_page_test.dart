import 'package:flutter_test/flutter_test.dart';
import 'package:shoping_list/list_item.dart';
import 'package:shoping_list/history_list_item.dart';

void main() {
  group('HistoryListItem', () {
    test('fromJson should return a valid HistoryListItem object', () {
      // Arrange
      final json = {
        'name': 'Test Name',
        'date': '2022-01-01',
        'list': [
          {'label': 'Item 1', 'checked': true},
          {'label': 'Item 2', 'checked': false},
        ],
      };

      // Act
      final historyListItem = HistoryListItem.fromJson(json);

      // Assert
      expect(historyListItem.name, 'Test Name');
      expect(historyListItem.date, '2022-01-01');
      expect(historyListItem.list.length, 2);
      expect(historyListItem.list[0].label, 'Item 1');
      expect(historyListItem.list[0].checked, true);
      expect(historyListItem.list[1].label, 'Item 2');
      expect(historyListItem.list[1].checked, false);
    });

    test('toJson should return a valid JSON object', () {
      // Arrange
      final historyListItem = HistoryListItem(
        name: 'Test Name',
        date: '2022-01-01',
        list: [
          ListItem(label: 'Item 1', checked: true),
          ListItem(label: 'Item 2', checked: false),
        ],
      );

      // Act
      final json = historyListItem.toJson();

      // Assert
      expect(json['name'], 'Test Name');
      expect(json['date'], '2022-01-01');
      expect(json['list'].length, 2);
      expect(json['list'][0]['label'], 'Item 1');
      expect(json['list'][0]['checked'], true);
      expect(json['list'][1]['label'], 'Item 2');
      expect(json['list'][1]['checked'], false);
    });
  });
}