const mongoose = require("mongoose");
const URI = process.env.ATLAS_URI;
const logger = require("../logger");
mongoose.Promise = global.Promise;

const connectMongoDB = async () => {
  try {
    await mongoose.connect(URI, {
      autoIndex: true,
    });
    logger.info("Database connected");
  } catch (error) {
    logger.error(error);
  }
};
module.exports = connectMongoDB;
