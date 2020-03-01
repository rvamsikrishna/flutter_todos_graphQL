import 'package:flutter/material.dart';
import 'package:flutter_graphql_todoapp/models/todo/todo.dart';
import 'package:flutter_graphql_todoapp/models/user/user.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class TodoListTile extends StatelessWidget {
  const TodoListTile({
    Key key,
    @required this.todo,
  }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      child: ListTile(
        selected: todo.completed ? true : false,
        title: Text(
          todo.body,
          style: TextStyle(
            fontSize: 24.0,
            decoration: todo.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('created ${timeago.format(todo.createdOn)}'),
      ),
      confirmDismiss: (DismissDirection direction) async {
        _onConfirmDismissed(context: context, direction: direction, todo: todo);
        return false;
      },
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.greenAccent,
              Colors.redAccent,
            ],
          ),
        ),
        child: Theme(
          data: ThemeData(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(todo.completed ? Icons.refresh : Icons.done),
              Icon(Icons.delete),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onConfirmDismissed(
      {BuildContext context, DismissDirection direction, Todo todo}) async {
    final User user = Provider.of<User>(context, listen: false);

    if (direction == DismissDirection.startToEnd) {
      user.updateTodo(
        previousTodo: todo,
        updatedTodo: todo.copyWith(completed: !todo.completed),
      );
      return false;
    }
    if (direction == DismissDirection.endToStart) {
      user.deleteTodo(todo.id);
    }
    return true;
  }
}
