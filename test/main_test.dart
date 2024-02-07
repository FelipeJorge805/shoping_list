import 'package:flutter_test/flutter_test.dart';
import 'package:shoping_list/list_item.dart';
import 'package:shoping_list/main.dart';

void main() {
  group('reorderOnCheck', () {
    test('should move item to bottom when newValue is true', () {
      // Arrange
      final myAppState = MyAppState();
      final item = ListItem(
        label: 'Test Label',
        checked: false,
        origin: 'current',
      );
      final shoppingList = [
        ListItem(
          label: 'Item 1',
          checked: false,
          origin: 'current',
        ),
        item,
        ListItem(
          label: 'Item 2',
          checked: false,
          origin: 'current',
        ),
        ListItem(
          label: 'Item 3',
          checked: false,
          origin: 'current',
        ),
      ];
      final expectedList = [
        ListItem(
          label: 'Item 1',
          checked: false,
          origin: 'current',
        ),
        ListItem(
          label: 'Item 2',
          checked: false,
          origin: 'current',
        ),
        ListItem(
          label: 'Item 3',
          checked: false,
          origin: 'current',
        ),
        ListItem(
          label: 'Test Label',
          checked: true,
          origin: 'current',
        ),
      ];

      // Act
      myAppState.reorderOnCheck(shoppingList, item, true,0);

      // Assert
      expect(shoppingList.map((e) => e.toJson()).toList(), expectedList.map((e) => e.toJson()).toList());
    });

    test('should move item to top when newValue is false', () {
      // Arrange
      final myAppState = MyAppState();
      final item = ListItem(
        label: 'Test Label',
        checked: true,
        origin: 'current',
      );
      final shoppingList = [
        ListItem(
          label: 'Item 1',
          checked: false,
          origin: 'current',
        ),
        ListItem(
          label: 'Item 2',
          checked: false,
          origin: 'current',
        ),
        ListItem(
          label: 'Item 3',
          checked: false,
          origin: 'current',
        ),
        item
      ];
      final expectedList = [
        ListItem(
          label: 'Item 1',
          checked: false,
          origin: 'current',
        ),
        ListItem(
          label: 'Item 2',
          checked: false,
          origin: 'current',
        ),
        ListItem(
          label: 'Item 3',
          checked: false,
          origin: 'current',
        ),
        ListItem(
          label: 'Test Label',
          checked: false,
          origin: 'current',
        ),
      ];

      // Act
      myAppState.reorderOnCheck(shoppingList, item, false,1);

      // Assert
      expect(shoppingList.map((e) => e.toJson()).toList(), expectedList.map((e) => e.toJson()).toList());
    });
  });
}