const logger = require("../logger");
const { exception } = require("../utils");
const jwt = require("jsonwebtoken");

const verifyAccessToken = exception(async (req, res, next) => {
  const authHeader = req.headers["authorization"];
  const accessToken = authHeader && authHeader.split(" ")[1];
  if (!accessToken) {
    res.status(400).send({
      status: "FAILED",
      data: {
        status: "Bad request",
        message: "Access token is required",
      },
    });
    logger.error(err);
  }
  jwt.verify(accessToken, process.env.ACCESS_TOKEN_SECRET, (e, r) => {
    if (e) {
      logger.error(e);
      res.status(400).send({
        status: "FAILED",
        data: {
          message: e.message,
        },
      });
    }
    req.body.email = r.email;
  });
  next();
});

module.exports = { verifyAccessToken };
