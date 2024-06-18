const mongoose = require("mongoose");
const options = { timestamps: true };
const UserSchema = new mongoose.Schema(
  {
    username: {
      type: String,
      trim: true,
      min: 8,
      unique: true,
      required: true,
    },
    password: {
      type: String,
      min: 8,
      required: true,
      lowercase: true,
      trim: true,
    },
    confirmPassword: {
      type: String,
      lowercase: true,
      trim: true,
      min: 8,
    },
    email: {
      type: String,
      unique: true,
      lowercase: true,
      trim: true,
    },
    isActive: {
      type: Boolean,
      default: true,
    },
    role: {
      type: String,
      default: "user",
      enum: ["user", "root", "consultants"],
    },
  },
  options
);

const User = mongoose.model("users", UserSchema);
module.exports = User;
