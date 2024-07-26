const { disconnect } = require("mongoose");
const models = require("../src/models");
const onlines = new Map();
function start(io) {
  io.on("connection", async (socket) => {
    const id = socket.handshake.query.id;
    onlines.set(id, socket.id);
    socket.on("send", async (data) => {
      let dataJson = JSON.parse(data);
      const { senderId, recieverId, message } = { ...dataJson };
      console.log(senderId);
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
