const pino = require("pino");
const logger = pino({
  timestamp: pino.stdTimeFunctions.isoTime,
  level: process.env.LOG_LEVEL || "infor",
  transport: {
    targets: [
      {
        target: "pino-pretty",
        options: {
          colorize: true,
          destination: `${__dirname}/app.log`,
          translateTime: "yyyy-mm-dd HH:MM:ss",
          ignore: "pid,hostname",
        },
      },
    ],
  },
});

module.exports = logger;
