import 'package:flutter/material.dart';
import 'package:flutter_state_management/todo_model.dart';

class StateProvider with ChangeNotifier{
  List<Todo> items = List<Todo>.empty(growable: true);

  // Operations
  void editTask(Todo item, String description){
    if(description != null && description != ''){
      item.description = description;
      notifyListeners();
    }
  }

  void removeItem(Todo item){
    items.remove(item);
    notifyListeners();
  }

  void addNewTask(String description){
    if(description != null && description != ''){
      items.add(Todo(description));
      notifyListeners();
    }
  }

  void chanceCompleteness(Todo item){
    item.complete = !item.complete;
    notifyListeners();
  }
}