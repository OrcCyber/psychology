const mongoose = require("mongoose");
const logger = require("../logger");

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
      logger.error(e);
      (await session).abortTransaction();
      next(e);
    }
  };
}

function errorHandler(fn) {
  return async function (req, res, next) {
    try {
      let isNextCalled = false;
      const result = await fn(req, res, (params) => {
        isNextCalled = true;
        next(params);
      });
      if (!res.headerSent && !isNextCalled) {
        logger.info(res.json(result));
        res.json(result);
      }
    } catch (e) {
      logger.error(e);
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

module.exports = {
  withTransaction,
  errorHandler,
  identifyRequest,
};
