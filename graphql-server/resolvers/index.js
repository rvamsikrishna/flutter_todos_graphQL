const todoResolvers = require("./todo_resolvers");
const userResolvers = require("./user_resolvers");

module.exports = {
  ...todoResolvers,
  ...userResolvers
};
