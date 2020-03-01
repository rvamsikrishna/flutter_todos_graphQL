const jwt = require("jsonwebtoken");
const config = require("config");

module.exports = (req, res, next) => {
  const token = req.get("x-auth-token");
  let decodedToken;
  try {
    decodedToken = jwt.verify(token, config.get("jwtTokenSecretKey"));
  } catch (err) {
    req.isAuth = false;
    return next();
  }
  if (!decodedToken) {
    req.isAuth = false;
    return next();
  }
  req.isAuth = true;
  next();
};
