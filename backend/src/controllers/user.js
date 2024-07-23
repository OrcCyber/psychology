const logger = require("../logger");
const models = require("../models");
const mongoose = require("mongoose");
const { ObjectId } = mongoose.Types;
const {
  exception,
  withTransaction,
  identifyRequest,
  isExpiredToken,
} = require("../utils");

const unpackFriends = async (user, field) => {
  let pipiline = [
    { $match: { _id: new ObjectId(user) } },
    {
      $project: {
        friends: 1,
      },
    },
    {
      $lookup: {
        from: "users",
        localField: `${field}.userId`,
        foreignField: "_id",
        pipeline: [
          {
            $project: {
              id: 1,
              email: 1,
              username: 1,
            },
          },
        ],
        as: `${field}`,
      },
    },
    {
      $project: {
        _id: 0,
      },
    },
  ];
  pipiline[1].$project[field] = 1;
  pipiline[3].$project[field] = 1;
  const friends = await models.User.aggregate(pipiline).exec();
  return friends[0][field];
};
const mapStateFriends = async (user, field) => {
  const friends = await unpackFriends(user, field);
  if (field === "friends") {
    friends.forEach((friend) => {
      f = user.friends.find(
        (f) => f.userId._id.toString() === friend._id.toString()
      );
      if (f) {
        friend.status = f.status;
        friend.date = f.date;
      }
    });
  } else if (field === "friendsRequest")
    friends.forEach((friend) => {
      f = user.friendsRequest.find(
        (f) => f.userId._id.toString() === friend._id.toString()
      );
      if (f) {
        friend.status = f.status;
        friend.date = f.date;
      }
    });
  return friends;
};

const search = exception(async (req, res) => {
  const { email } = req.body;
  const user = await models.User.findOne({ email }).exec();
  const pipeline = [
    { $match: { _id: new ObjectId(user) } },
    {
      $project: {
        friends: 1,
        friendsRequest: 1,
      },
    },
    {
      $lookup: {
        from: "users",
        let: {
          user: "$_id",
          friendsList: "$friends.userId",
          requestsList: "$friendsRequest.userId",
        },
        pipeline: [
          {
            $match: {
              $expr: {
                $and: [
                  { $ne: ["$_id", "$$user"] },
                  { $not: { $in: ["$_id", "$$friendsList"] } },
                  { $not: { $in: ["$_id", "$$requestsList"] } },
                ],
              },
            },
          },
          {
            $project: {
              id: 1,
              email: 1,
              username: 1,
            },
          },
        ],
        as: "nonFriends",
      },
    },
    {
      $project: {
        _id: 0,
        nonFriends: 1,
      },
    },
  ];
  const nonFriends = await models.User.aggregate(pipeline).exec();
  const friends = await mapStateFriends(user, "friends");
  const friendsRequest = await mapStateFriends(user, "friendsRequest");
  return res.status(200).send({
    status: "OK",
    data: {
      nonFriends: nonFriends[0].nonFriends,
      friends: friends,
      friendsRequest: friendsRequest,
    },
  });
});
const searchEmail = exception(async (req, res) => {
  const { email, keyword } = req.body;
  const user = await models.User.findOne({ email }).exec();
  const pipeline = [
    { $match: { _id: new ObjectId(user) } },
    {
      $project: {
        friends: 1,
        friendsRequest: 1,
      },
    },
    {
      $lookup: {
        from: "users",
        let: {
          user: "$_id",
          friendsList: "$friends.userId",
          requestsList: "$friendsRequest.userId",
        },
        pipeline: [
          {
            $match: {
              $expr: {
                $and: [
                  { $ne: ["$_id", "$$user"] },
                  { $not: { $in: ["$_id", "$$friendsList"] } },
                  { $not: { $in: ["$_id", "$$requestsList"] } },
                ],
              },
            },
          },
          {
            $project: {
              id: 1,
              email: 1,
              username: 1,
            },
          },
        ],
        as: "nonFriends",
      },
    },
    {
      $project: {
        _id: 0,
        nonFriends: 1,
      },
    },
  ];
  const nonFriends = await models.User.aggregate(pipeline).exec();
  const friends = await mapStateFriends(user, "friends");
  const friendsRequest = await mapStateFriends(user, "friendsRequest");
  return res.status(200).send({
    status: "OK",
    data: {
      nonFriends: nonFriends[0].nonFriends,
      // friends: friends,
      // friendsRequest: friendsRequest,
    },
  });
});

const sendFriendRequest = exception(
  withTransaction(async (req, res, session) => {
    const { email, emailFriend } = req.body;
    const user = await models.User.findOne({ email: email })
      .session(session)
      .exec();
    const friend = await models.User.findOne({ email: emailFriend })
      .session(session)
      .exec();
    if (!user || !friend) {
      return res.status(400).send({
        status: "FAILED",
        data: {
          message: "Error",
        },
      });
    }
    // Check friend or request to friend exist.
    const isFriendExist = user.friends.some(
      (f) => f.userId.toString() === friend._id.toString()
    );
    const isFriendRequestExist = friend.friendsRequest.some(
      (f) => f.userId.toString() === user._id.toString()
    );
    if (isFriendExist || isFriendRequestExist) {
      return res.status(400).send({
        status: "FAILED",
        data: {
          message: "Friend already exist.",
        },
      });
    }
    user.friends.push({ userId: friend, status: "pending", date: Date.now() });
    friend.friendsRequest.push({
      userId: user,
      status: "pending",
      date: Date.now(),
    });
    await user.save({ session: session });
    await friend.save({ session: session });
    return res.status(200).send({
      status: "OK",
      data: {
        message: "Send request successfully.",
        fromUser: user.email,
        toUser: friend.email,
      },
    });
  })
);
const resendRequestFriend = exception(
  withTransaction(async (req, res, session) => {
    const { email, emailFriend } = req.body;
    const user = await models.User.findOne({ email: email })
      .session(session)
      .exec();
    const friend = await models.User.findOne({ email: emailFriend })
      .session(session)
      .exec();
    if (!user | !friend) {
      return res.status(400).send({
        status: "FAILED",
        data: {
          message: "Bad request",
        },
      });
    }
    logger.info(`User: ${user.username.firstName} ${user.username.lastName}`);
    logger.info(
      `Friend: ${friend.username.firstName} ${friend.username.lastName}`
    );
    let f = user.friends.find(
      (f) =>
        f.userId.toString() === friend._id.toString() && f.status === "reject"
    );

    let u = friend.friendsRequest.find(
      (u) => u.userId.toString() === user.id.toString() && u.status === "reject"
    );
    if (!f | !u) {
      return res.status(200).send({
        status: "FAILED",
        data: {
          message: "Bad request",
        },
      });
    }
    f.status = "pending";
    u.status = "pending";
    await user.save({ session });
    await friend.save({ session });
    return res.status(200).send({
      status: "SUCCESS",
      data: {
        message: "Rejected OK",
        user: user,
        friend: friend,
      },
    });
  })
);
const acceptedFriendRequest = exception(
  withTransaction(async (req, res, session) => {
    const { email, emailFriend } = req.body;
    const user = await models.User.findOne({ email: email })
      .session(session)
      .exec();
    const friend = await models.User.findOne({ email: emailFriend })
      .session(session)
      .exec();
    if (!user | !friend) {
      return res.status(400).send({
        status: "FAILED",
        data: {
          message: "Bad request",
        },
      });
    }
    let userSendRequest = user.friendsRequest.find(
      (u) =>
        u.userId.toString() === friend._id.toString() && u.status === "pending"
    );
    let userAcceptRequest = friend.friends.find(
      (u) =>
        u.userId.toString() === user.id.toString() && u.status === "pending"
    );
    if (!userSendRequest | !userAcceptRequest) {
      return res.status(400).send({
        status: "FAILED",
        data: {
          message: "Bad request",
        },
      });
    }
    userSendRequest.status = "accepted";
    userAcceptRequest.status = "accepted";
    await user.save({ session });
    await friend.save({ session });
    return res.status(200).send({
      status: "SUCCESS",
      data: {
        message: "Acepted OK",
        user: user,
        friend: friend,
      },
    });
  })
);
const rejectFriendRequest = exception(
  withTransaction(async (req, res, session) => {
    const { email, emailFriend } = req.body;
    const user = await models.User.findOne({ email: email })
      .session(session)
      .exec();
    const friend = await models.User.findOne({ email: emailFriend })
      .session(session)
      .exec();
    if (!user | !friend) {
      return res.status(400).send({
        status: "FAILED",
        data: {
          message: "Bad request",
        },
      });
    }
    logger.info(`User: ${user.username.firstName} ${user.username.lastName}`);
    logger.info(
      `Friend: ${friend.username.firstName} ${friend.username.lastName}`
    );
    let userSendRequest = user.friendsRequest.find(
      (u) =>
        u.userId.toString() === friend._id.toString() && u.status === "pending"
    );
    let userRejectRequest = friend.friends.find(
      (u) =>
        u.userId.toString() === user.id.toString() && u.status === "pending"
    );
    if (!userSendRequest | !userRejectRequest) {
      return res.status(400).send({
        status: "FAILED",
        data: {
          message: "Bad request",
        },
      });
    }
    userSendRequest.status = "reject";
    userRejectRequest.status = "reject";
    await user.save({ session });
    await friend.save({ session });
    return res.status(200).send({
      status: "SUCCESS",
      data: {
        message: "Rejected OK",
        user: user,
        friend: friend,
      },
    });
  })
);

module.exports = {
  search,
  sendFriendRequest,
  acceptedFriendRequest,
  rejectFriendRequest,
  resendRequestFriend,
  searchEmail,
};
