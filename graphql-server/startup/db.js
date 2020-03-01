const mongoose = require("mongoose");
const { logger } = require("./logging");
const config = require("config");

module.exports = function() {
  const dbName = config.get("db.name");
  const dbUsername = config.get("db.username");
  const dbPassword = config.get("db.password");
  mongoose.connect(
    `mongodb+srv://${dbUsername}:${dbPassword}@graphql-9czgg.mongodb.net/${dbName}?retryWrites=true&w=majority`,
    { useNewUrlParser: true, useUnifiedTopology: true }
  );

  const db = mongoose.connection;
  db.on("error", () => {
    logger.error("database connection error");
  });
  db.once("open", () => {
    // we're connected!
    logger.info(`Successfully connected to database.`);
  });
};
