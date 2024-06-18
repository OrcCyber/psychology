const User = require("../models/user");
const connectMongoDB = require("../config/connection");
const jwt = require("jsonwebtoken");
const dotenv = require("dotenv");
const { json } = require("express");

dotenv.config();
// Connection database
connectMongoDB();
async function signup(req, res, next) {
  try {
    res.status(201).send("Signup");
  } catch (error) {
    res.status(500).send(error);
  }
  next();
}

async function login(req, res, next) {
  try {
    const { username, password } = req.body;

    // Checked infor user login
    if (1 === 1) {
      const token = generateJWT(
        { username, password },
        process.env.JWT_SECRET_KEY,
        30
      );
      console.log(token);

      const refreshToken = jwt.generateJWT(
        { username, password },
        process.env.JWT_SECRET_KEY,
        120
      );
      console.log(refreshToken);
      const response = {
        status: "success",
        token: token,
        refreshToken: refreshToken,
      };
      return res.status(201).json(response).redirect(301, "/");
    }
    return res.status(403).json({
      status: "success",
      message: "Login failure!!",
    });
  } catch (error) {
    return res.status(500).send(JSON.stringify(error));
  } finally {
    next();
  }
}

function generateJWT(payload, serect, expired) {
  return jwt.sign(payload, serect, {
    algorithm: "HS256",
    expiresIn: expired,
  });
}

module.exports = {
  signup,
  login,
};
