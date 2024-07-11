const logger = require("../logger");
const models = require("../models");
const {
  exception,
  withTransaction,
  identifyRequest,
  isExpiredToken,
} = require("../utils");

const search = exception(async (req, res) => {
  const { email, partner } = req.body;
  const docs = await models.User.find(
    { email: { $regex: partner } },
    { _id: 0, __v: 0, password: 0, createdAt: 0, updatedAt: 0 }
  ).exec();
  return res.status(200).send({
    status: "OK",
    data: {
      user: email,
      partners: docs.sort(),
    },
  });
});

module.exports = {
  search,
};
