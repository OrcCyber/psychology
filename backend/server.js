// 3rd-Party
const dotenv = require("dotenv");
const express = require("express");
const morgan = require("morgan");
const cookieParser = require("cookie-parser");
const fs = require("fs");
const path = require("path");
const { info } = require("console");
const app = express();

// Routes
const { AuthRouter } = require("./routes/authentication");

// .env
dotenv.config({ path: "./config.env" });
const port = process.env.PORT || 3000;

/************************Converter************************/
app.use(express.json());
app.use(cookieParser());

/************************Morgan************************/
//["combined", "common", "dev", "short", "tiny"] or format same below;
morgan.token("date", (req, res) => {
  const date = new Date();
  const options = {
    timeZone: "Asia/Bangkok",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    second: "2-digit",
    hour12: false,
  };
  return new Intl.DateTimeFormat("en-GB", options).format(date);
});
const accessLogStream = fs.createWriteStream(
  path.join(__dirname, "access.log"),
  {
    flags: "a+",
  }
);
app.use(
  morgan(":date[iso] :method :url :status :response-time ms :http-version", {
    stream: accessLogStream,
  })
);
/************************Authentication************************/
app.use("/api/auth", AuthRouter);
/***************************User*******************************/
app.use("/", (req, res, next) => {
  return res.status(200).send("Home page");
});
app.listen(port, () => {
  info("Server running!!!!!!!!");
  info(`Server listening at port ${port}`);
});
