// 3rd-Party
const express = require("express");

// Routers
const router = express.Router();

// Controllers
const controllers = require("../controllers");

// Midlewares
const middlewares = require("../middlewares");

router.post("/login", controllers.auth.login);
router.post("/register", controllers.auth.register);
router.get("/verify", controllers.auth.verify);

module.exports = router;
