import 'package:flutter/material.dart';
import 'package:flutter_graphql_todoapp/models/user/user.dart';
import 'package:provider/provider.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({
    Key key,
  }) : super(key: key);

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Add todo',
                border: OutlineInputBorder(),
                hasFloatingPlaceholder: false,
              ),
              maxLines: 1,
            ),
          ),
          SizedBox(width: 20.0),
          FlatButton(
            color: Colors.blueAccent,
            textColor: Colors.white,
            padding: EdgeInsets.all(18.0),
            onPressed: () {
              if (_textEditingController.text.isEmpty) {
                return;
              }
              final User user = Provider.of<User>(context, listen: false);
              user.addTodo(_textEditingController.text);
              _textEditingController.clear();
              //close the keyboard
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
