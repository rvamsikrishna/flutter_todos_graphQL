import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_graphql_todoapp/models/user/user.dart';
import 'package:flutter_graphql_todoapp/pages/home/widgets/add_todo.dart';
import 'package:flutter_graphql_todoapp/pages/home/widgets/todo_list.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<User>(context, listen: false).fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Notes"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              final User user = Provider.of<User>(context, listen: false);
              user.clear();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            TodoList(),
            Align(
              alignment: Alignment.bottomCenter,
              child: AddTodo(),
            ),
          ],
        ),
      ),
    );
  }
}
