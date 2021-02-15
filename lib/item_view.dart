import 'package:flutter/material.dart';
import 'package:flutter_state_management/item_list_provider.dart';
import 'package:flutter_state_management/todo_model.dart';
import 'package:provider/provider.dart';

class ItemView extends StatefulWidget {
  final Todo item;

  ItemView({ this.item });

  @override
  _ItemViewState createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    if(widget.item != null)
      _textEditingController.text = widget.item.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('New task'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _textEditingController,
                onFieldSubmitted: (value) => submit(),
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
              ),
              SizedBox(height: 10),
              RaisedButton(
                child: Text('Submit'),
                onPressed: submit,
              )
            ],
          ),
        )
    );
  }

  void submit(){
    String description = _textEditingController.text;
    if(description != null && description.isNotEmpty){
      if(widget.item != null){
        context.read<StateProvider>().editTask(widget.item, description);
      } else {
        context.read<StateProvider>().addNewTask(description);
      }
      Navigator.pop(context, _textEditingController.text);
    }
  }
}