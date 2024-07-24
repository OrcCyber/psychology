const mongoose = require("mongoose");
const options = { timestamps: true };

const ConversationSchema = new mongoose.Schema(
  {
    participants: [
      {
        type: mongoose.Types.ObjectId,
        ref: "users",
      },
    ],
    messages: [
      {
        type: mongoose.Types.ObjectId,
        ref: "messages",
        default: [],
      },
    ],
  },
  options
);

const Conversation = mongoose.model("conversations", ConversationSchema);
module.exports = Conversation;
