const jwt = require("jsonwebtoken");
const logger = require("../logger");
const models = require("../models");
const nodemailer = require("nodemailer");
const { errorHandler, withTransaction, identifyRequest } = require("../utils");

var transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASSWORD,
  },
});

function sendingEmail(email) {
  // --------------------------------------
  const token = generateJWT(
    { email },
    process.env.VERIFY_EMAIL_TOKEN,
    process.env.VERIFY_EMAIL_EXPIRES
  );
  const url = `http://127.0.0.1:${process.env.PORT}/api/auth/verify?token=${token}`;
  let mailOptions = {
    to: email,
    subject: "Email Verification",
    html: `<a href="${url}">Verify</a>`,
  };
  const res = { statusCode: 200 };
  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      logger.error(error);
      res.statusCode = 400;
    } else {
      logger.error(info);
    }
  });
  return res;
}

/**
 * @description: Register account for user and verify email
 * @param {*} req: request
 * @param {*} res: response
 * @param {*} next: next func
 * @returns: new user or rollback
 */
const register = errorHandler(
  withTransaction(async (req, res, session) => {
    try {
      const { email, password, username } = req.body;
      const hostname = req.hostname;
      const userExist = await models.User.findOne({ email: email });
      console.log(userExist);
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
      return res.status(200).send({ status: "SUCCESS" });
    } catch (e) {
      logger.error(e);
      return res.status(400).send({ status: "FAILED" });
    }
  })
);

async function login(req, res, next) {
  try {
    const { username, password } = req.body;
    if (1 === 1) {
      const accessToken = await generateJWT(
        { username, password },
        process.env.ACCESS_TOKEN_SECRET,
        process.env.ACCESS_TOKEN_EXPIRES
      );
      const refreshToken = await generateJWT(
        { username, password },
        process.env.REFRESH_TOKEN_SECRET,
        process.env.REFRESH_TOKEN_EXPIRES
      );
      return res
        .cookie("accessToken", accessToken, { httpOnly: true })
        .cookie("refreshToken", refreshToken, {
          httpOnly: true,
        })
        .status(201)
        .send({
          message: "Success",
          token: token,
          refreshToken: refreshToken,
        });
    }
    return res.status(403).send({
      message: "Forbiden",
    });
  } catch (error) {
    logger.error(error);
    res.status(500).send(JSON.stringify(error));
  } finally {
    next();
  }
} 
const verify = errorHandler(
  withTransaction(async (req, res, session) => {
    try {
      const token = req.query.token;
      console.log();
      const decoded = jwt.verify(token, process.env.VERIFY_EMAIL_TOKEN);
      console.log(decoded);
      const user = await models.User.findOne({
        email: decoded.email,
      });
      console.log(user);
      if (!user) {
        return res.status(200).send({ message: "An error" });
      }
      user.isVerify = true;
      const email = decoded.email;
      await user.save({ session });
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
      return res.status(200).send({
        status: "SUCCESS",
        data: {
          accessToken: accessToken,
          refreshToken: refreshToken,
        },
      });
    } catch (error) {
      return res.status(200).send({
        status: "FAILED",
      });
    }
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
  login,
  verify,
};
