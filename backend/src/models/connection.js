const mongoose = require("mongoose");
const bcrypt = require("bcrypt");
const logger = require("../logger");
const options = { timestamps: true };

const ConnectionSchema = new mongoose.Schema({});
