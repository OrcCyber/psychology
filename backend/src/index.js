// 3rd-Party
const express = require("express");
const cookieParser = require("cookie-parser");
const logger = require("./logger");
const app = express();
const connectToDatabase = require("./database");

// Routes
const routes = require("./routes");
/************************Converter************************/
app.use(express.json());
/************************Authentication************************/
app.use("/api", routes);
async function start() {
  const port = process.env.PORT;
  await connectToDatabase();
  app.listen(port, () => {
    logger.info(`Server listening at port ${port}`);
  });
}

module.exports = start;
