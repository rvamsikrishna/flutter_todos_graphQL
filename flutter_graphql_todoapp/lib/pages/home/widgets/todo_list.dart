import 'package:flutter/material.dart';
import 'package:flutter_graphql_todoapp/models/todo/todo.dart';
import 'package:flutter_graphql_todoapp/models/user/user.dart';
import 'package:flutter_graphql_todoapp/pages/home/widgets/todo_list_tile.dart';
import 'package:provider/provider.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (BuildContext context, User user, Widget child) {
        if (user.fetchingTodos) {
          return Center(child: CircularProgressIndicator());
        }
        if (!user.fetchingTodos && user.todos.isEmpty) {
          return Center(child: Text('No todos added yet!'));
        }
        return ListView.builder(
          itemCount: user.todos.length,
          itemBuilder: (BuildContext context, int index) {
            final Todo todo = user.todos[index];
            return TodoListTile(todo: todo);
          },
        );
      },
    );
  }
}
