import 'package:flutter/material.dart';
import 'package:flutter_graphql_todoapp/models/auth/auth.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  final bool isSignup;

  const AuthForm({
    Key key,
    this.isSignup = false,
  }) : super(key: key);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> _input = {
    'email': '',
    'password': '',
    'name': '',
  };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  _authTypeString(),
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(height: 30.0),
                if (widget.isSignup)
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                    onChanged: (String text) {
                      _input['name'] = text;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                SizedBox(height: 15.0),
                Selector<Authentication, String>(
                  selector: (BuildContext context, Authentication auth) =>
                      auth.error,
                  builder: (BuildContext context, String error, Widget child) {
                    return Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            errorText: error != null &&
                                    error.toLowerCase().contains('email')
                                ? error
                                : null,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (String text) {
                            _input['email'] = text;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            errorText: error != null &&
                                    error.toLowerCase().contains('password')
                                ? error
                                : null,
                          ),
                          obscureText: true,
                          onChanged: (String text) {
                            _input['password'] = text;
                          },
                          validator: (value) {
                            if (value.isEmpty || value.length < 8) {
                              return 'Password should have atleast 8 chars.';
                            }
                            return null;
                          },
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 15.0),
                Consumer<Authentication>(
                  builder: (BuildContext context, Authentication auth, _) {
                    return RaisedButton(
                      child: auth.authenticating
                          ? SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(),
                            )
                          : Text(_authTypeString()),
                      onPressed: auth.authenticating
                          ? null
                          : () => _authenticate(auth),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  String _authTypeString() => widget.isSignup ? 'Signup' : 'Login';

  void _authenticate(Authentication auth) {
    if (!_formKey.currentState.validate()) return;

    if (widget.isSignup) {
      auth.signup(
        email: _input['email'],
        password: _input['password'],
        name: _input['name'],
      );
    } else {
      auth.login(
        email: _input['email'],
        password: _input['password'],
      );
    }
  }
}
