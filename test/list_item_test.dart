import 'package:flutter_test/flutter_test.dart';
import 'package:shoping_list/list_item.dart';

void main() {
  group('ListItem', () {
    test('fromJson should return a valid ListItem object', () {
      // Arrange
      final json = {
        'label': 'Test Label',
        'checked': true,
      };

      // Act
      final listItem = ListItem.fromJson(json);

      // Assert
      expect(listItem.label, 'Test Label');
      expect(listItem.checked, true);
    });

    test('toJson should return a valid JSON object', () {
      // Arrange
      final listItem = ListItem(
        label: 'Test Label',
        checked: true,
      );

      // Act
      final json = listItem.toJson();

      // Assert
      expect(json['label'], 'Test Label');
      expect(json['checked'], true);
    });
  });
}