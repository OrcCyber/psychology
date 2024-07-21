const pino = require("pino");
const logger = pino({
  timestamp: pino.stdTimeFunctions.isoTime,
  level: process.env.LOG_LEVEL || "info",
  transport: {
    targets: [
      {
        target: "pino-pretty",
        options: {
          destination: `${__dirname}/app.log`,
          colorize: false,
          translateTime: "yyyy-mm-dd HH:MM:ss",
          ignore: "pid,hostname",
        },
      },
    ],
  },
});

module.exports = logger;
