require("express-async-errors");
const winston = require("winston");

const logger = winston.createLogger({
  level: "info",
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: "error.log", level: "error" }),
    new winston.transports.File({ filename: "combined.log" })
  ]
});
//
// If we're not in production then log to the `console` with the format:
// `${info.level}: ${info.message} JSON.stringify({ ...rest }) `
//
if (process.env.NODE_ENV !== "production") {
  logger.add(
    new winston.transports.Console({
      format: winston.format.simple()
    })
  );
}

const init = function() {
  process.on("uncaughtException", err => {
    console.log("Something went wrong. UNCAUGHT EXCEPTION!");
    logger.error(err.message, err);
    process.exit(1);
  });

  process.on("unhandledRejection", err => {
    console.log("Something went wrong. UNHANDLED REJECTION!");
    logger.error(err.message, err);
    process.exit(1);
  });
};

module.exports.logger = logger;
module.exports.init = init;
