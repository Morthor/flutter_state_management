import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_state_management/todo_model.dart';
import 'package:flutter/material.dart';

class TodoListModel extends Model {
  List<Todo> _items = List<Todo>.empty(growable: true);

  List<Todo> get items => _items;

  // Operations
  void editTask(Todo item, String description){
    if(description != null && description != ''){
      item.description = description;
      notifyListeners();
    }
  }

  void removeItem(Todo item){
    _items.remove(item);
    notifyListeners();
  }

  void addNewTask(String description){
    if(description != null && description != ''){
      _items.add(Todo(description));
      notifyListeners();
    }
  }

  void changeCompleteness(Todo item){
    item.complete = !item.complete;
    notifyListeners();
  }

  static TodoListModel of(BuildContext context) =>
      ScopedModel.of<TodoListModel>(context);
}
