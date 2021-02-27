import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_state_management/item_view.dart';
import 'package:flutter_state_management/todo_model.dart';

void main() {
  runApp(MyApp());
}

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
      body: items.isNotEmpty ? ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index){
          return TodoItem(
            item: items[index],
            onTap: updateTodoCompleteness,
            onLongPress: goToEditItemView,
            onDismissed: removeTodo,
          );
        },
      ) : Center(child: Text('No items'),),
    );
  }

  // Navigation

  void goToNewItemView(){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return ItemView();
        }
    )).then((value) {
      addNewTodo(value);
    });
  }

  void goToEditItemView(Todo item){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return ItemView(item: item);
        }
    )).then((value) {
      updateTodoDescription(item, value);
    });
  }

  // Actions

  void updateTodoDescription(Todo item, String description){
    setState(() {
      updateItemDescription(item, description);
    });
  }

  void removeTodo(Todo item){
    setState(() {
      removeItem(item);
    });
  }

  void addNewTodo(String description){
    if(description != null && description != ''){
      setState(() {
        addNewItem(description);
      });
    }
  }

  void updateTodoCompleteness(Todo item){
    setState(() {
      updateItemCompleteness(item);
    });
  }

  // Operations

  void updateItemDescription(Todo item, String description){
    if(description != null && description != ''){
      item.description = description;
    }
  }

  void removeItem(Todo item){
    items.remove(item);
  }

  void addNewItem(String description){
    if(description != null && description != ''){
      items.add(Todo(description));
    }
  }

  void updateItemCompleteness(Todo item){
    item.complete = !item.complete;
  }
}

class TodoItem extends StatelessWidget {
  final Todo item;
  final Function(Todo) onTap;
  final Function(Todo) onLongPress;
  final Function(Todo) onDismissed;

  TodoItem({
    @required this.item,
    @required this.onTap,
    @required this.onDismissed,
    @required this.onLongPress
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.hashCode.toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: EdgeInsets.only(left: 12),
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white,),
        alignment: Alignment.centerLeft,
      ),
      onDismissed: (direction) => onDismissed(item),
      child: ListTile(
        title: Text(item.description,
          style: TextStyle(decoration: item.complete
              ? TextDecoration.lineThrough
              : null),
        ),
        trailing: Icon(item.complete
            ? Icons.check_box
            : Icons.check_box_outline_blank
        ),
        onTap: () => onTap(item),
        onLongPress: () => onLongPress(item),
      ),
    );
  }
}