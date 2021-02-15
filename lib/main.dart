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
            onTap: changeCompleteness,
            onLongPress: goToEditItemView,
            onDismissed: removeItem,
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
      addNewTask(value);
    });
  }

  void goToEditItemView(Todo item){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return ItemView(item: item);
        }
    )).then((value) {
      editTask(item, value);
    });
  }

  // Operations

  void editTask(Todo item, String description){
    if(description != null && description != ''){
      setState(() {
        item.description = description;
      });
    }
  }

  void removeItem(Todo item){
    setState(() {
      items.remove(item);
    });
  }

  void addNewTask(String description){
    if(description != null && description != ''){
      setState(() {
        items.add(Todo(description));
      });
    }
  }

  void changeCompleteness(Todo item){
    setState(() {
      item.complete = !item.complete;
    });
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