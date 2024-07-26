const express = require("express");
const router = express.Router();
const auth = require("./auth");
const user = require("./user");
const conversation = require("./conversation");

router.use("/auth", auth);
router.use("/user", user);
router.use("/conversation", conversation);

module.exports = router;
