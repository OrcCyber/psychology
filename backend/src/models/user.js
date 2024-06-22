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
      lowercase: true,
      trim: true,
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
  },
  options
);
/**
 * @description: middleware hash password if it changed.
 */
UserSchema.pre("save", function (next) {
  const user = this;
  if (!user.isModified("password")) return next();
  bcrypt.genSalt(10, (err, salt) => {
    if (err) return next(err);
    bcrypt.hash(user.password, salt, (err, hash) => {
      if (err) {
        logger.error(err);
        return next(err);
      }
      user.password = hash;
      next();
    });
  });
});

/**
 * @description: Custom dupplicate key schema
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
