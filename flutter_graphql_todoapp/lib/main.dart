import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_graphql_todoapp/application.dart';
import 'package:flutter_graphql_todoapp/models/user/user.dart';
import 'package:flutter_graphql_todoapp/pages/auth/auth_page.dart';
import 'package:flutter_graphql_todoapp/pages/home/home_page.dart';
import 'package:provider/provider.dart';

String get host {
  if (Platform.isAndroid) {
    return '10.0.2.2';
  } else {
    return 'localhost';
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp() {
    final uri = 'https://graphql-flutter-todo.herokuapp.com/graphql';
    Application(uri: uri).setGraphQLClient();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => User(),
      child: MaterialApp(
        routes: {
          '/': (BuildContext context) => AuthPage(),
          '/home': (BuildContext context) => HomePage(),
        },
      ),
    );
  }
}
