const logger = require("../logger");
const models = require("../models");
const mongoose = require("mongoose");
const { ObjectId } = mongoose.Types;
const { exception, withTransaction } = require("../utils");
const sendMessage = exception(
  withTransaction(async (req, res, session) => {
    const { email, emailFriend, message } = req.body;
    const sender = await models.User.findOne({ email: email })
      .session(session)
      .exec();
    const receiver = await models.User.findOne({ email: emailFriend })
      .session(session)
      .exec();
    if (!sender | !receiver) {
      return res.status(400).send({
        status: "FAILED",
        data: {
          message: "Bad request",
        },
      });
    }
    let conversation = await models.Conversation.findOne({
      participants: { $all: [sender, receiver] },
    });
    if (!conversation) {
      conversation = await models.Conversation.create({
        participants: [sender, receiver],
      });
    }
    const m = new models.Message({
      message: message,
      receiver: receiver,
      sender: sender,
    });
    if (m) {
      conversation.messages.push(m._id);
    }
    await Promise.all([conversation.save({ session }), m.save({ session })]);
    return res.status(201).send({
      messgae: "OK",
      data: m,
    });
  })
);

module.exports = { sendMessage };
