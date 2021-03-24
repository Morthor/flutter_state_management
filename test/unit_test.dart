import 'package:flutter_state_management/todo_model.dart';
import 'package:test/test.dart';
import 'package:flutter_state_management/main.dart';

void main() {
  group('Item operations', () {
    test('Add new item to list', () {
      var home = TodoList();
      expect(home.items.length == 0, true);
      home.addNewItem('New item');
      expect(home.items.length == 1, true);
    });

    test('Remove item from list', () {
      var home = TodoList();
      expect(home.items.length == 0, true);
      Todo item = Todo('New item');
      home.items.add(item);
      expect(home.items.length == 1, true);
      home.removeItem(item);
      expect(home.items.length == 0, true);
    });

    test('Update Item Description', () {
      var home = TodoList();
      String ogDescription = 'New item';
      String updatedDescription = 'Edited description';

      Todo item = Todo(ogDescription);
      expect(item.description == ogDescription, true);
      home.updateItemDescription(item, updatedDescription);
      expect(item.description == updatedDescription, true);
    });

    test('Update Item Completeness', () {
      var home = TodoList();

      Todo item = Todo('New item');
      expect(item.complete, false);
      home.updateItemCompleteness(item);
      expect(item.complete, true);
    });
  });
}
