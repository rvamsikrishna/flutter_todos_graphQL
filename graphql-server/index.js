const express = require("express");
const bodyParser = require("body-parser");
const graphQLHttp = require("express-graphql");
const graphQLSchema = require("./schema/index");
const resolvers = require("./resolvers/index");
const authMiddleware = require("./middleware/auth");

require("./startup/logging").init();
require("./startup/db")();

const app = express();

app.use(authMiddleware);
app.use(bodyParser.json());

app.use(
  "/graphql",
  graphQLHttp({
    schema: graphQLSchema,
    rootValue: resolvers,
    graphiql: process.env.NODE_ENV === "development"
  })
);

const port = process.env.PORT || 5000;
app.listen(port, () => {
  console.log(`running on port ${port}`);
});
