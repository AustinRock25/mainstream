import jwt from "jsonwebtoken";
const { verify } = jwt;
import { query } from "../config/pgClient.js";

export const authenticate = (req, res, next) => {
  const token = req.cookies?.jwt || req.headers["x-access-token"];

  if (!token)
    return res.status(401).json({ error: "No token provided." });

  verify(token, process.env.JWT_SECRET, (error, decoded) => {
    if (error)
      return res.status(401).json({ error: `Bad token. ${error}` });
    else {
      query("SELECT id, email, is_admin, rating_scale FROM users WHERE id = $1", [decoded.id])
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

export const authorizeAdmin = (req, res, next) => {
  const token = req.cookies?.jwt || req.headers["x-access-token"];

  if (!token) 
    return res.status(401).json({ error: "No token provided." });

  verify(token, process.env.JWT_SECRET, (error, decoded) => {
    if (error) 
      return res.status(401).json({ error: `Bad token. ${error}` });
    
    query("SELECT id, email, is_admin FROM users WHERE id = $1", [decoded.id])
      .then(results => {
        if (results.rowCount === 0 || !results.rows[0].is_admin)
          return res.status(403).json({ error: "Unauthorized." });

        res.locals.user = results.rows[0];
        next();
      })
      .catch(error => res.status(401).json({ error: `Unauthorized. ${error}` }));
  });
}