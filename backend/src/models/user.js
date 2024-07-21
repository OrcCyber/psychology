const mongoose = require("mongoose");
const bcrypt = require("bcrypt");
const logger = require("../logger");
const options = { timestamps: true };
const UserSchema = new mongoose.Schema(
  {
    username: {
      lastName: {
        type: String,
        trim: true,
        required: true,
      },
      firstName: {
        type: String,
        trim: true,
        required: true,
      },
    },
    password: {
      type: String,
      min: 8,
      required: true,
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
    isVerify: {
      type: Boolean,
      default: false,
    },
    role: {
      type: String,
      default: "user",
      enum: ["user", "consultants", "root"],
    },
    friends: [
      {
        userId: {
          type: mongoose.Types.ObjectId,
          ref: "users",
          unique: true,
        },
        status: {
          type: String,
          enum: ["reject", "accepted", "pending"],
        },
        date: { type: Date },
      },
    ],
    friendsRequest: [
      {
        userId: {
          type: mongoose.Types.ObjectId,
          ref: "users",
          unique: true,
        },
        status: {
          type: String,
          enum: ["reject", "accepted", "pending"],
        },
        date: { type: Date },
      },
    ],
  },
  options
);
/**
 * @description: middleware hash password if it changed.
 */
UserSchema.pre("save", async function (next) {
  const user = this;
  if (!user.isModified("password")) return next();
  const hash = await bcrypt.hash(user.password, 10);
  console.log(`mật khẩu trước khi lưu vào cơ sở dữ liệu ==> ${user.password}`);
  console.log(`mật khẩu sau khi băm bằng bcrypt ==> ${hash}`);
  user.password = hash;
  next();
});

/**
 * @description: middleware message when dupplicate field
 */
UserSchema.post("save", function (error, doc, next) {
  if (error.name === "MongoServerError" && error.code === 11000) {
    next(
      new Error(`There was dupplicate key error ${error.errorResponse.errmsg}`)
    );
  } else {
    next();
  }
});

// UserSchema.methods.isExist("check");
const User = mongoose.model("users", UserSchema);
module.exports = User;
