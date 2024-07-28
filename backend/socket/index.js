const { disconnect } = require("mongoose");
const models = require("../src/models");
const logger = require("../src/logger");
const onlines = new Map();
function start(io) {
  io.on("connection", async (socket) => {
    const id = socket.handshake.query.id;
    onlines.set(id, socket.id);
    logger.info("User ID", id);
    logger.info("Socket ID", socket.id);
    logger.info("Map User Conneted", onlines);
    socket.on("send", async (data) => {
      if (typeof data === "string") {
        data = JSON.parse(data);
      }
      const senderId = data.senderId;
      const recieverId = data.recieverId;
      const message = data.message;
      const sender = await models.User.findById(senderId).select(
        "id email username"
      );
      const receiver = await models.User.findById(recieverId).select(
        "id email username"
      );
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
      await Promise.all([conversation.save(), m.save()]);
      const socketTargetId = onlines.get(recieverId);
      if (socketTargetId) {
        logger.info("Push socket target", socketTargetId);
        io.to(socketTargetId).emit("recieve", m);
      }
      // Handler push notification
    });
    socket.on("disconnect", () => {
      onlines.delete(id);
    });
  });
}

module.exports = start;
