// 3rd-Party
const express = require("express");

// Routers
const router = express.Router();

// Controllers
const controllers = require("../controllers");

// Midlewares
const middlewares = require("../middlewares");

router
  .get("/search", middlewares.verifyAccessToken, controllers.user.search)
  .get(
    "/search-email",
    middlewares.verifyAccessToken,
    controllers.user.searchEmail
  )
  .post(
    "/request-friend",
    middlewares.verifyAccessToken,
    controllers.user.sendFriendRequest
  )
  .post(
    "/accepted-friend",
    middlewares.verifyAccessToken,
    controllers.user.acceptedFriendRequest
  )
  .post(
    "/reject-friend",
    middlewares.verifyAccessToken,
    controllers.user.rejectFriendRequest
  )
  .post(
    "/resend-request-friend",
    middlewares.verifyAccessToken,
    controllers.user.resendRequestFriend
  );

module.exports = router;
