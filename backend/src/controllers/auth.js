const jwt = require("jsonwebtoken");
const logger = require("../logger");
const models = require("../models");
const nodemailer = require("nodemailer");
const { errorHandler, withTransaction, identifyRequest } = require("../utils");
const bcrypt = require("bcrypt");

var transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASSWORD,
  },
});

const resendEmail = errorHandler(async (req, res, next) => {
  const { email } = req.body;
  if (!email) {
    return res.status(400).send({
      status: "OK",
      data: {
        message: "Field email is required.",
      },
    });
  }
  const token = generateJWT(
    { email },
    process.env.VERIFY_EMAIL_TOKEN,
    process.env.VERIFY_EMAIL_EXPIRES
  );
  const url = `http://${hostname}:${process.env.PORT}/api/auth/verify?token=${token}`;
  let mailOptions = {
    to: email,
    subject: "Email Verification",
    html: `<a href="${url}">Verify</a>`,
  };
  await transporter.sendMail(mailOptions);
  return res.status(201).send({
    status: "SUCCESS",
  });
});

/**
 * @description: Register account for user and verify email
 * @param {*} req: request
 * @param {*} res: response
 * @param {*} next: next func
 * @returns: new user or rollback
 */
const register = errorHandler(
  withTransaction(async (req, res, session) => {
    const { email, password, username } = req.body;
    const hostname = req.hostname;
    const userExist = await models.User.findOne({ email: email });
    if (userExist) {
      if (userExist.isVerify) {
        return res.status(409).send({ message: "User already exist." });
      } else {
        return res
          .status(408)
          .send({ message: "User already exist, but email not verify." });
      }
    }
    const user = models.User({
      username: username,
      email: email,
      password: password,
      isVerify: false,
    });
    const token = generateJWT(
      { email },
      process.env.VERIFY_EMAIL_TOKEN,
      process.env.VERIFY_EMAIL_EXPIRES
    );
    const url = `http://${hostname}:${process.env.PORT}/api/auth/verify?token=${token}`;
    let mailOptions = {
      to: email,
      subject: "Email Verification",
      html: `<a href="${url}">Verify</a>`,
    };
    await transporter.sendMail(mailOptions);
    await user.save({ session });
    return res.status(200).send({
      status: "OK",
      data: {
        message: "Register success, please verify email",
      },
    });
  })
);
const signin = errorHandler(async (req, res, next) => {
  const { email, password } = req.body;
  const user = await models.User.findOne({ email: email });
  if (!user)
    return res.status(404).send({
      status: "OK",
      data: {
        mesage: "User not found",
      },
    });
  if (!user.isVerify)
    return res.status(400).send({
      status: "OK",
      data: {
        mesage: "User not verrify email",
      },
    });
  const hash = await bcrypt.hash(password, 10);
  const match = await bcrypt.compare(password, user.password);
  console.log(`mật khẩu băm được lấy từ người dùng ${hash}`);
  console.log(`mật khẩu băm được lấy từ CSDL ${hash}`);
  console.log(match);
  return res.status(200).send({
    status: "SUCCESS",
    data: {
      message: "Login accepted",
      accessToken: 123,
      refreshToken: 123,
    },
  });
});

const verify = errorHandler(
  withTransaction(async (req, res, session) => {
    const token = req.query.token;
    const decoded = jwt.verify(token, process.env.VERIFY_EMAIL_TOKEN);
    const email = decoded.email;
    const user = await models.User.findOne({
      email: email,
    });
    if (!user) {
      return res.status(200).send({ message: "An error" });
    }
    const accessToken = generateJWT(
      { email },
      process.env.ACCESS_TOKEN_SECRET,
      process.env.ACCESS_TOKEN_EXPIRES
    );
    const refreshToken = generateJWT(
      { email },
      process.env.REFRESH_TOKEN_SECRET,
      process.env.REFRESH_TOKEN_EXPIRES
    );
    if (user.isVerify) {
      return res.status(200).send({
        status: "SUCCESS",
        data: {
          message: "Email has been verify",
          accessToken: accessToken,
          refreshToken: refreshToken,
        },
      });
    }
    user.isVerify = true;
    await user.save({ session });
    return res.status(200).send({
      status: "SUCCESS",
      data: {
        message: "Email is verify",
        accessToken: accessToken,
        refreshToken: refreshToken,
      },
    });
  })
);

function generateJWT(payload, serect, expired) {
  return jwt.sign(payload, serect, {
    algorithm: "HS256",
    expiresIn: expired,
  });
}

module.exports = {
  register,
  signin,
  verify,
  resendEmail,
};
