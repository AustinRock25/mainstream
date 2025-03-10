const jwt = require("jsonwebtoken");
const pgClient = require("../config/pgClient");

function authenticate(req, res, next) {
  const token = req.cookies?.jwt || req.headers["x-access-token"];

  if (!token)
    return res.status(401).json({ error: "No token provided." });

  jwt.verify(token, process.env.JWT_SECRET, (error, decoded) => {
    if (error)
      return res.status(401).json({ error: `Bad token. ${error}` });
    else {
      pgClient.query("SELECT id, email, is_admin FROM users WHERE id = $1", [decoded.id])
        .then(results => {
          if (results.rowCount > 0) {
            res.locals.user = results.rows[0];
            next();
          }
          else
            res.status(401).json({ error: "User not found." });
        })
        .catch(error => {
          res.status(401).json({ error: `Unauthorized. ${error}` });
        })
    }
  });
}

function authorizeAdmin(req, res, next) {
  const token = req.cookies?.jwt || req.headers["x-access-token"];

  if (!token)
    return res.status(401).json({ error: "No token provided." });

  jwt.verify(token, process.env.JWT_SECRET, (error, decoded) => {
    if (error)
      return res.status(401).json({ error: `Bad token. ${error}` });
    else {
      pgClient.query("SELECT id, email, is_admin FROM users WHERE id = $1", [decoded.id])
        .then(results => {
          if (!results.rows[0].is_admin) {
            return res.status(403).json({ error: "Unauthorized." });
          }
        })
        .catch(error => {
          res.status(401).json({ error: `Unauthorized. ${error}` });
        })
    }
    
    next();
  });
}

module.exports = { authenticate, authorizeAdmin };