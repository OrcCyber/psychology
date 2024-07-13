const mongoose = require("mongoose");
const logger = require("../logger");
const { stringify, parse } = require("flatted");

function withTransaction(fn) {
  return async function (req, res, next) {
    const session = await mongoose.startSession();
    session.startTransaction();
    try {
      await fn(req, res, session);
      (await session).commitTransaction();
      logger.info("Transaction completed");
    } catch (e) {
      logger.error("Transaction error");
      logger.error(stringify(e));
      (await session).abortTransaction();
      next(e);
    }
  };
}

function exception(fn) {
  return async function (req, res, next) {
    try {
      let isNextCalled = false;
      const result = await fn(req, res, (params) => {
        isNextCalled = true;
        next(params);
      });
      if (!res.headerSent && !isNextCalled) {
        logger.info(stringify(res.json(result)));
        res.json(result);
      }
    } catch (e) {
      logger.error(stringify(e));
    }
  };
}

function identifyRequest(request) {
  const agent = request.get("User-agent");
  console.log(agent);
  if (isFromBrowser(agent)) return "browser";
  return "app";
}
function isFromBrowser(agent) {
  return /Mozilla|Chrome|Safari|Firefox|Edge/.test(agent);
}

function isExpiredToken(exp) {
  let expTime = new Date(exp * 1000);
  let currentTime = new Date() / 1000;
  if (expTime < currentTime) return true;
  return false;
}

module.exports = {
  withTransaction,
  exception,
  identifyRequest,
  isExpiredToken,
};
