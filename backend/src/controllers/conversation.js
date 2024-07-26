const models = require("../models");
const { exception, withTransaction } = require("../utils");

const getConversations = exception(async (req, res) => {
  const { email } = req.body;
  const user = await models.User.findOne({ email: email });
  if (!user) {
    return res.status(400).send({
      status: "FAILED",
      data: {
        message: "Bad request",
      },
    });
  }
  let conversations = await models.Conversation.find({
    participants: { $in: [user] },
  })
    .populate({ path: "participants", select: "id email username" })
    .populate({
      path: "messages",
      select: "id createdAt message sender receiver isRead",
    })
    .sort();
  if (!conversations) {
    return res.status(200).send({
      status: "OK",
      data: [],
    });
  }
  conversations = conversations.map((conversation) => {
    conversation.messages.sort((a, b) => b.createdAt - a.createdAt);
    return conversation;
  });
  return res.status(200).send({
    status: "OK",
    data: conversations,
  });
});

const getMessagesFromConversation = exception(async (req, res) => {
  const { conversationId } = req.body;
  const conversation = await models.Conversation.findById(
    conversationId
  ).populate({
    path: "messages",
    select: "id createdAt message sender receiver isRead",
    populate: [
      {
        path: "sender",
        select: "id email username",
      },
      {
        path: "receiver",
        select: "id email username",
      },
    ],
  });

  if (!conversation) {
    return res.status(400).send({
      status: "FAILED",
      data: {
        message: "Bad request",
      },
    });
  }
  return res.status(200).send({
    status: "OK",
    data: conversation,
  });
});
module.exports = {
  getConversations,
  getMessagesFromConversation,
};
