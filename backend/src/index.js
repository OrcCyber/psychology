// 3rd-Party
const express = require("express");
const logger = require("./logger");
const { createServer } = require("node:http");
const app = express();
const connectToDatabase = require("./database");
const cors = require("cors");
const { Server } = require("socket.io");
const server = createServer(app);
const pinoHttp = require("pino-http");

// Routes
const routes = require("./routes");
/************************Converter************************/
app.use(pinoHttp({ logger }));
app.use(cors());
app.use(express.json());
/************************Authentication************************/
app.use("/api", routes);
async function start() {
  const port = process.env.PORT;
  await connectToDatabase();
  const io = new Server(server, {
    cors: {
      origin: "*",
      methods: ["GET", "POST"],
    },
  });
  io.on("connection", (socket) => {
    logger.info(socket.id);
    socket.on("disconnect", () => {
      logger.info(`Disconnect`);
    });
  });
  server.listen(port, () => {
    logger.info(`Sever listen at ${port}`);
  });
}

module.exports = start;
