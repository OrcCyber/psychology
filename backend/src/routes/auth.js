// 3rd-Party
const express = require("express");

// Routers
const router = express.Router();

// Controllers
const controllers = require("../controllers");

// Midlewares
const middlewares = require("../middlewares");

router.post("/login", controllers.auth.signin);
router.post("/register", controllers.auth.register);
router.post("/resend", controllers.auth.resendEmail);
router.post(
  "/change-password",
  middlewares.verifyAccessToken,
  controllers.auth.changePassword
);
router.get("/re-new-accessToken", controllers.auth.reNewAccessToken);
router.get("/verify", controllers.auth.verify);

module.exports = router;
