import 'package:flutter/cupertino.dart';
import 'package:flutter_graphql_todoapp/application.dart';
import 'package:flutter_graphql_todoapp/models/user/user.dart';
import 'package:flutter_graphql_todoapp/models/user_details/user_details.dart';
import 'package:graphql/client.dart';

import '../../graphQL/mutations/signup/signup.ast.g.dart' as signupMutation;
import '../../graphQL/mutations/login/login.ast.g.dart' as loginMutation;

class Authentication extends ChangeNotifier {
  final User _user;
  bool authenticated = false;
  bool authenticating = false;
  String error;

  Authentication({@required User user}) : _user = user;

  void signup({String email, String password, String name = ''}) {
    error = null;
    authenticating = true;
    notifyListeners();
    final MutationOptions options = MutationOptions(
      documentNode: signupMutation.document,
      variables: <String, dynamic>{
        'email': email,
        'password': password,
        'name': name,
      },
      onError: (OperationException exception) {
        if (exception != null) {
          authenticating = false;
          error = exception.graphqlErrors[0].message;
          notifyListeners();
        }
      },
      onCompleted: (_) {
        print('completed');
      },
    );
    _authenticate(options, 'signup');
  }

  void login({String email, String password}) {
    error = null;
    authenticating = true;
    notifyListeners();
    final MutationOptions options = MutationOptions(
      documentNode: loginMutation.document,
      variables: <String, dynamic>{
        'email': email,
        'password': password,
      },
      onError: (OperationException exception) {
        if (exception != null) {
          authenticating = false;
          error = exception.graphqlErrors[0].message;
          notifyListeners();
        }
      },
      onCompleted: (_) {
        print('completed');
      },
    );

    _authenticate(options, 'login');
  }

  void removeErrors() {
    error = null;
    notifyListeners();
  }

  Future<void> _authenticate(MutationOptions options, String authType) async {
    final QueryResult res = await Application().gqlClient.mutate(options);
    if (!res.hasException) {
      final UserDetails details = UserDetails.fromJson(res.data[authType]);
      Application().setGraphQLClient(headers: {
        'x-auth-token': details.token,
      });

      _user.setUserDetails(details);
      authenticated = true;
      authenticating = false;
      notifyListeners();
    }
  }
}
