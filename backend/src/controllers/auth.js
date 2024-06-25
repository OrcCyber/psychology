const jwt = require("jsonwebtoken");
const logger = require("../logger");
const models = require("../models");
const nodemailer = require("nodemailer");
const {
  errorHandler,
  withTransaction,
  identifyRequest,
  isExpiredToken,
} = require("../utils");
const bcrypt = require("bcrypt");

// Mailer
const transporter = nodemailer.createTransport({
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
      status: "ERROR",
      data: {
        message: "Email is required.",
      },
    });
  }
  const token = generateJWT(
    { email },
    process.env.VERIFY_EMAIL_TOKEN,
    process.env.VERIFY_EMAIL_EXPIRES
  );
  const url = `http://${req.hostname}:${process.env.PORT}/api/auth/verify?token=${token}`;
  let mailOptions = {
    to: email,
    subject: "Email Verification",
    html: `<a href="${url}">Verify</a>`,
  };
  const emailResend = await transporter.sendMail(mailOptions);
  logger.info(emailResend);
  return res.status(201).send({
    status: "SUCCESS",
    data: {
      message: "Resend verify to email successfully",
      info: emailResend,
    },
  });
});

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
    return res.status(201).send({
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
      status: "FAILED",
      data: {
        mesage: "User not found",
      },
    });
  if (!user.isVerify)
    return res.status(406).send({
      status: "FAILED",
      data: {
        mesage: "User not verrify email",
      },
    });
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
  const match = await bcrypt.compare(password, user.password);
  if (!match) {
    return res.status(403).send({
      status: "FAILED",
      data: {
        message: "Password incorrect",
      },
    });
  }
  return res.status(202).send({
    status: "OK",
    data: {
      message: "Login accepted",
      accessToken: accessToken,
      refreshToken: refreshToken,
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
      return res.status(404).send({
        status: "FAILED",
        data: {
          message: "User not found",
        },
      });
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
      await user.save({ session });
      return res.status(304).send({
        status: "OK",
        data: {
          message: "Authenticated user",
          accessToken: accessToken,
          refreshToken: refreshToken,
        },
      });
    }
    user.isVerify = true;
    await user.save({ session });
    return res.status(202).send({
      status: "OK",
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

const changePassword = errorHandler(
  withTransaction(async (req, res, session) => {
    const { currentPassword, newPassword, email } = req.body;
    console.log(req.body);
    if (!currentPassword || !newPassword || !email) {
      return res.status(400).send({
        status: "FAILED",
        data: {
          error: "Bad request",
          message:
            "Fields are required: [currentPassword, newPassword, accessToken]",
        },
      });
    }
    const user = await models.User.findOne({ email: email });
    if (!user) {
      return res.status(404).send({
        status: "FAILED",
        data: {
          error: "Bad request",
          message: "User not found",
        },
      });
    } else {
      const match = await bcrypt.compare(currentPassword, user.password);
      if (!match) {
        return res.status(403).send({
          status: "FAILED",
          data: {
            error: "Forbidden",
            message: "Password incorrect",
          },
        });
      } else {
        user.password = newPassword;
        await user.save({ session });
        return res.status(200).send({
          status: "OK",
          data: {
            message: "Password changed",
          },
        });
      }
    }
  })
);

module.exports = {
  register,
  signin,
  verify,
  resendEmail,
  changePassword,
};
