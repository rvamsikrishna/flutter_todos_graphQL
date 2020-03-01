import 'package:flutter/cupertino.dart';
import 'package:flutter_graphql_todoapp/models/todo/todo.dart';
import 'package:flutter_graphql_todoapp/models/user_details/user_details.dart';
import 'package:graphql/client.dart';

import '../../application.dart';
import '../../graphQL/mutations/add_todo/add_todo.ast.g.dart'
    as addTodoMutation;
import '../../graphQL/queries/fetch_todos/fetch_todos.ast.g.dart'
    as fetchTodosQuery;
import '../../graphQL/mutations/delete_todo/delete_todo.ast.g.dart'
    as deleteTodoMutation;
import '../../graphQL/mutations/update_todo/update_todo.ast.g.dart'
    as updateTodoMutation;

class User extends ChangeNotifier {
  UserDetails details;
  List<Todo> todos = [];
  bool fetchingTodos = true;
  String todoFetcherror;

  void setUserDetails(UserDetails details) {
    this.details = details;
    notifyListeners();
  }

  Future<void> fetchTodos() async {
    if (todoFetcherror != null) {
      todoFetcherror = null;
      notifyListeners();
    }

    final QueryOptions options = QueryOptions(
      documentNode: fetchTodosQuery.document,
      variables: <String, dynamic>{
        'creatorId': details.id,
      },
    );

    final QueryResult res = await Application().gqlClient.query(options);
    if (res.hasException) {
      todoFetcherror = res.exception.graphqlErrors[0].message;
      notifyListeners();
    } else {
      for (var todoJson in res.data['todos']) {
        todos.insert(0, Todo.fromJson(todoJson));
      }
      fetchingTodos = false;
      notifyListeners();
    }
  }

  void addTodo(String todo) {
    final Todo newTodo = Todo(body: todo, createdOn: DateTime.now());

    final MutationOptions options = MutationOptions(
      documentNode: addTodoMutation.document,
      variables: <String, dynamic>{
        'text': todo,
        'userId': details.id,
      },
      onError: (OperationException exception) {
        //show error
        print(exception);
      },
      onCompleted: (data) {
        final int newTodoIndex = todos.indexOf(newTodo);
        final Todo todo = Todo.fromJson(data['createTodo']);
        todos.replaceRange(newTodoIndex, newTodoIndex + 1, [todo]);
      },
    );

    todos.insert(0, newTodo);
    notifyListeners();
    Application().gqlClient.mutate(options);
  }

  void updateTodo({Todo previousTodo, Todo updatedTodo}) {
    print(updatedTodo.completed);
    int todoIndex;
    todoIndex = todos.indexOf(previousTodo);
    todos.replaceRange(todoIndex, todoIndex + 1, [updatedTodo]);
    notifyListeners();

    final MutationOptions options = MutationOptions(
      documentNode: updateTodoMutation.document,
      variables: <String, dynamic>{
        'todoId': updatedTodo.id,
        'completed': updatedTodo.completed,
        'body': updatedTodo.body,
      },
      onError: (exception) {
        print(exception);
        //add the previous todo back on error
        todos.replaceRange(todoIndex, todoIndex + 1, [previousTodo]);
        notifyListeners();
      },
    );

    Application().gqlClient.mutate(options);
  }

  void deleteTodo(String todoId) {
    int todoIndex;
    final Todo todoToBeRemoved = todos.firstWhere((todo) => todo.id == todoId);
    todoIndex = todos.indexOf(todoToBeRemoved);
    todos.remove(todoToBeRemoved);
    notifyListeners();

    final MutationOptions options = MutationOptions(
      documentNode: deleteTodoMutation.document,
      variables: <String, dynamic>{
        'todoId': todoId,
      },
      onError: (exception) {
        print(exception);
        //add the todo back
        todos.insert(todoIndex, todoToBeRemoved);
        notifyListeners();
      },
    );

    Application().gqlClient.mutate(options);
  }

  void clear() {
    todos.clear();
    fetchingTodos = true;
    todoFetcherror = null;
    details = null;
  }
}
