// 3rd-Party
const express = require("express");

// Routers
const AuthRouter = express.Router();

// Controllers
const { signup, login } = require("../controllers/authentication");

// Midlewares
const { cookieAuthentication } = require("../middlewares/authentication");

AuthRouter.route("/login").post(login);

AuthRouter.route("/signup").post(signup);

AuthRouter.route("/").post((req, res) => {
  return res.json({ message: "Welcome" });
});
module.exports = { AuthRouter };
