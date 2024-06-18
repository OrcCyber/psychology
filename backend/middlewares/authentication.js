const jwt = require("jsonwebtoken");

function cookieAuthentication(req, res, next) {
  try {
    const token = req.cookies.token;
    console.log(token);s
    const user = jwt.verify(token, process.env.JWT_SECRET_KEY);
    req.user = user;
    next();
  } catch (error) {
    res.clearCookie("token");
    res.status(403).send("Token is expried");
  }
}

module.exports = { cookieAuthentication };
