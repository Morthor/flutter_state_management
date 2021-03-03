import 'package:flutter/material.dart';
import 'package:flutter_state_management/item_view.dart';
import 'package:flutter_state_management/todo_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_state_management/main.dart';

void main() {
  testWidgets('App runs and shows home view', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Todo App'), findsOneWidget);
  });

  group('Home Widget', () {
    testWidgets('Home view has an empty list', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      expect(find.text('No items'), findsOneWidget);
    });

    testWidgets('Item View when creating a new item',
        (WidgetTester tester) async {
      final itemView = new ItemView();

      await tester.pumpWidget(MaterialAppTester(itemView));

      expect(find.text('New todo'), findsOneWidget);
      expect(itemView.item, null);
      expect(find.byType(RaisedButton), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });
  });

  group('ItemView Widget', () {
    testWidgets('Item View when editing an existing item',
        (WidgetTester tester) async {
      String description = 'New item';

      Todo item = Todo(description);
      final itemView = new ItemView(item: item);

      await tester.pumpWidget(MaterialAppTester(itemView));

      expect(find.text('Edit todo'), findsOneWidget);
      expect(itemView.item != null, true);

      expect(find.byType(RaisedButton), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text(description), findsOneWidget);
    });
  });
}

class MaterialAppTester extends StatelessWidget {
  final Widget testWidget;

  MaterialAppTester(this.testWidget);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MaterialAppTester',
      home: this.testWidget,
    );
  }
}
