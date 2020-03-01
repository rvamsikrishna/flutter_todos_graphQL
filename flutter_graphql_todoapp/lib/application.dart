import 'package:graphql/client.dart';

//A singleton
class Application {
  String _uri;
  static final Application _application = Application._internal();

  factory Application({String uri}) {
    if (_application._uri == null) {
      _application._uri = uri;
    }
    return _application;
  }

  Application._internal();

  GraphQLClient gqlClient;

  void setGraphQLClient({Map<String, String> headers = const {}}) {
    final HttpLink httpLink = HttpLink(uri: _uri, headers: headers);

    gqlClient = GraphQLClient(
      cache: InMemoryCache(),
      link: httpLink,
    );
  }
}
