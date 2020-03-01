const { buildSchema } = require("graphql");

module.exports = buildSchema(`
type User{
  _id: ID!
  name: String
  email: String!
  password: String
  token: String
}

input UserCredentialsInput{
  email: String!
  password: String!
}

input UserRegistrationInput{
  email: String!
  password: String!
  name: String!
}

type Todo{
  _id: ID!
  title: String
  body: String!
  completed: Boolean!
  createdOn: String!
  creator: User
}

input TodoInput{
  title: String
  body: String!
  completed: Boolean
  userId: String!
}

input updateTodoInput{
  title: String
  body: String
  completed: Boolean
}

type RootQuery {
  todos(creatorId: String!): [Todo!]!
}

type RootMutation {
  signup(input: UserRegistrationInput): User
  login(input: UserCredentialsInput): User
  createTodo(todo: TodoInput): Todo
  updateTodo(id: String!, updatedTodo: updateTodoInput): Todo
  deleteTodo(id: String!): String
}

schema {
  query: RootQuery
  mutation: RootMutation
}
`);
