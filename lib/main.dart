import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_state_management/item_list_provider.dart';
import 'package:flutter_state_management/item_view.dart';
import 'package:flutter_state_management/todo_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => StateProvider(),
    child: MyApp(),
  ));
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
      body: Consumer<StateProvider>(
        builder: (context, stateProvider, child) {
          return stateProvider.items.isNotEmpty
              ? ListView.builder(
                itemCount: stateProvider.items.length,
                itemBuilder: (context, index) {
                  return TodoItem(
                    item: stateProvider.items[index],
                    onTap: stateProvider.chanceCompleteness,
                    onLongPress: goToEditItemView,
                    onDismissed: stateProvider.removeItem,
                  );
                },
              )
              : Center(child: Text('No items'),);
        }
      ),
    );
  }

  // Navigation

  void goToNewItemView(){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return ItemView();
      }
    ));
  }

  void goToEditItemView(Todo item){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return ItemView(item: item);
      }
    ));
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