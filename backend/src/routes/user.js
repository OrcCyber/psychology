// 3rd-Party
const express = require("express");

// Routers
const router = express.Router();

// Controllers
const controllers = require("../controllers");

// Midlewares
const middlewares = require("../middlewares");

router.get("/search", middlewares.verifyAccessToken, controllers.user.search);

module.exports = router;
