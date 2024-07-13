const pino = require("pino");
const logger = pino(
  {
    timestamp: pino.stdTimeFunctions.isoTime,
    level: process.env.LOG_LEVEL || "info",
    transport: {
      targets: [
        {
          target: "pino-pretty",
          options: {
            colorize: true,
            translateTime: "yyyy-mm-dd HH:MM:ss",
            ignore: "pid,hostname",
          },
        },
      ],
    },
  },
  pino.destination(`${__dirname}/app.log`)
);

module.exports = logger;
