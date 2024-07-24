const mongoose = require("mongoose");
const options = { timestamps: true };

const MessageSchema = new mongoose.Schema(
  {
    isRead: {
      type: Boolean,
      default: false,
    },
    message: {
      type: String,
      required: true,
    },
    sender: {
      type: mongoose.Types.ObjectId,
      ref: "users",
    },
    receiver: {
      type: mongoose.Types.ObjectId,
      ref: "users",
    },
  },
  options
);

const Message = mongoose.model("messages", MessageSchema);
module.exports = Message;
