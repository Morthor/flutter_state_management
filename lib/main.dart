import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_state_management/item_view.dart';
import 'package:flutter_state_management/todo_model.dart';


void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    )
  );
}

class TodoList extends ChangeNotifier {
  List<Todo> _items = List<Todo>.empty(growable: true);
  List<Todo> get items => _items;

  // Actions

  void updateTodoDescription(Todo item, String description) {
    updateItemDescription(item, description);
    notifyListeners();
  }

  void removeTodo(Todo item) {
    removeItem(item);
    notifyListeners();
  }

  void addNewTodo(String description) {
    if (description != null && description != '') {
      addNewItem(description);
      notifyListeners();
    }
  }

  void updateTodoCompleteness(Todo item) {
    updateItemCompleteness(item);
    notifyListeners();
  }

  // Operations

  void updateItemDescription(Todo item, String description) {
    if (description != null && description != '') {
      item.description = description;
    }
  }

  void removeItem(Todo item) {
    items.remove(item);
  }

  void addNewItem(String description) {
    if (description != null && description != '') {
      items.add(Todo(description));
    }
  }

  void updateItemCompleteness(Todo item) {
    item.complete = !item.complete;
  }
}

final todoListProvider = ChangeNotifierProvider((ref) => TodoList());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Todo> items = List<Todo>.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: goToNewItemView,
      ),
      body: Consumer(builder: (context, watch, _){
        final items = watch(todoListProvider).items;
        return ItemListView(
          items: items,
          goToEditItemView: goToEditItemView,
        );
      },),
    );
  }

  // Navigation

  void goToNewItemView() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ItemView();
    })).then((value) {
      context.read(todoListProvider).addNewTodo(value);
    });
  }

  void goToEditItemView(Todo item) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ItemView(item: item);
    })).then((value) {
      context.read(todoListProvider).updateTodoDescription(item, value);
    });
  }
}

class ItemListView extends StatelessWidget {
  final List<Todo> items;
  final Function(Todo) goToEditItemView;

  const ItemListView({Key key,
    this.items,
    this.goToEditItemView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(items.isNotEmpty) {
      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return TodoItem(
            item: items[index],
            onTap: context
                .read(todoListProvider)
                .updateTodoCompleteness,
            onLongPress: goToEditItemView,
            onDismissed: context
                .read(todoListProvider)
                .removeTodo,
          );
        },
      );
    } else{
      return Center(
        child: Text('No items'),
      );
    }
  }
}


class TodoItem extends StatelessWidget {
  final Todo item;
  final Function(Todo) onTap;
  final Function(Todo) onLongPress;
  final Function(Todo) onDismissed;

  TodoItem(
      {@required this.item,
      @required this.onTap,
      @required this.onDismissed,
      @required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.hashCode.toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: EdgeInsets.only(left: 12),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        alignment: Alignment.centerLeft,
      ),
      onDismissed: (direction) => onDismissed(item),
      child: ListTile(
        title: Text(
          item.description,
          style: TextStyle(
              decoration: item.complete ? TextDecoration.lineThrough : null),
        ),
        trailing: Icon(
            item.complete ? Icons.check_box : Icons.check_box_outline_blank),
        onTap: () => onTap(item),
        onLongPress: () => onLongPress(item),
      ),
    );
  }
}
