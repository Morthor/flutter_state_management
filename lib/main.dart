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
        onPressed: navigateToNewItemView,
      ),
      body: items.isNotEmpty ? ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index){
          return Dismissible(
            key: Key(items[index].hashCode.toString()),
            direction: DismissDirection.startToEnd,
            background: Container(
              padding: EdgeInsets.only(left: 12),
              color: Colors.red,
              child: Icon(Icons.delete, color: Colors.white,),
              alignment: Alignment.centerLeft,
            ),
            onDismissed: (direction) => removeItem(items[index]),
            child: ListTile(
              title: Text(items[index].description),
              trailing: Icon(items[index].complete
                  ? Icons.check_box
                  : Icons.check_box_outline_blank
              ),
              onTap: () => chanceCompleteness(items[index]),
              onLongPress: () => navigateToEditItemView(items[index]),
            ),
          );
        },
      ) : Center(child: Text('No items'),),
    );
  }

  // Navigation

  void navigateToNewItemView(){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return ItemView();
        }
    )).then((value) {
      addNewTask(value);
    });
  }

  void navigateToEditItemView(Todo item){
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

  void chanceCompleteness(Todo item){
    setState(() {
      item.complete = !item.complete;
    });
  }
}