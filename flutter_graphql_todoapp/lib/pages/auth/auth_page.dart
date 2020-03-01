import 'package:flutter/material.dart';
import 'package:flutter_graphql_todoapp/models/auth/auth.dart';
import 'package:flutter_graphql_todoapp/models/user/user.dart';
import 'package:flutter_graphql_todoapp/pages/auth/widgets/auth_form.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final List<Tab> _myTabs = <Tab>[
    Tab(text: 'Signup'),
    Tab(text: 'Login'),
  ];

  Authentication _authentication;

  @override
  void initState() {
    super.initState();
    _authentication =
        Authentication(user: Provider.of<User>(context, listen: false));

    _authentication.addListener(_onAuthenticated);
  }

  @override
  void dispose() {
    _authentication.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Notes"),
          bottom: TabBar(
            tabs: _myTabs,
            onTap: (_) {
              _authentication.removeErrors();
            },
          ),
        ),
        body: ChangeNotifierProvider.value(
          value: _authentication,
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              AuthForm(
                isSignup: true,
              ),
              AuthForm(),
            ],
          ),
        ),
      ),
    );
  }

  void _onAuthenticated() {
    if (_authentication.authenticated) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', (Route<dynamic> route) => false);
    }
  }
}
