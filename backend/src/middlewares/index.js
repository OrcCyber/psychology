const { HttpError } = require("../error");
const logger = require("../logger");
const { errorHandler } = require("../utils");
const jwt = require("jsonwebtoken");

const verifyAccessToken = errorHandler(async (req, res, next) => {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];
  if (!token) {
    throw new HttpError(401, "Unauthorized");
  }
  jwt.verify(token, process.env.ACCESS_TOKEN, (err, user) => {
    if (err) {
      throw new HttpError(403, "Forbidden");
    }
    req.user = user;
  });
});

module.exports = { verifyAccessToken };
