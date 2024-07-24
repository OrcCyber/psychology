// 3rd-Party
const express = require("express");

// Routers
const router = express.Router();

// Controllers
const controllers = require("../controllers");

// Midlewares
const middlewares = require("../middlewares");

router.post(
  "/send",
  middlewares.verifyAccessToken,
  controllers.message.sendMessage
);
module.exports = router;
