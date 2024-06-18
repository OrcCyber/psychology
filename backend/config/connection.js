const mongoose = require("mongoose");
const dotenv = require("dotenv");
dotenv.config();
const URI = process.env.ATLAS_URI;
const connectMongoDB = async () => {
  try {
    await mongoose.connect(URI, {
      autoIndex: true,
    });
  } catch (error) {
    console.error(error);
  }
};
module.exports = connectMongoDB;
