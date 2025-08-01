const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const pgClient = require("../config/pgClient");

function register(req, res) {
  const { email, password, rating_scale } = req.body;
  const hash = bcrypt.hashSync(password, 12);

  pgClient.query("INSERT INTO users (email, password, rating_scale) VALUES ($1, $2, $3)", [email, hash, rating_scale])
    .then(results => {
      pgClient.query("SELECT id, email FROM users WHERE email = $1", [email])
        .then(results => {
          const token = generateToken({ id: results.rows[0].id });
          const payload = {
            id: results.rows[0].id,
            email: results.rows[0].email,
            token: token
          };

          res.cookie("jwt", token, {
            maxAge: 86400000,
            httpOnly: true
          });

          res.json(payload);
        })
        .catch(error => {
          res.status(500).json({ error: `${error}` });
        });
    })
    .catch(error => {
      res.status(500).json({ error: `${error}` });
    });
}

function login(req, res) {
  const { email, password } = req.body;
  const errors = {};

  if (!email || email.length === 0)
    errors.email = "is required.";

  if (!password || password.length === 0)
    errors.password = "is required.";

  if (Object.keys(errors).length > 0) {
    res.status(422).json({ errors });
    return;
  }

  pgClient.query("SELECT id, email, password, is_admin, rating_scale FROM users WHERE email = $1", [email])
    .then(results => {
      if (results.rowCount > 0) {
        if (bcrypt.compareSync(password, results.rows[0].password)) {
          const token = generateToken({ id: results.rows[0].id });
          const payload = {
            id: results.rows[0].id,
            email: results.rows[0].email,
            is_admin: results.rows[0].is_admin,
            token: token,
            rating_scale: results.rows[0].rating_scale
          };

          res.cookie("jwt", token, {
            maxAge: 86400000,
            httpOnly: true
          });

          res.json(payload);
        }
        else
          res.status(401).json({});
      }
      else
        res.status(404).json({ error: "User not found." });
    })
    .catch(error => {
      res.status(500).json({ error: `${error}` });
    });
}

function logout(req, res) {
  res.clearCookie("jwt");
  res.json({ message: "Successfully logged out." });
}

function verifyToken(req, res) {
  if (res.locals.user !== undefined)
    res.json(res.locals.user);
  else
    res.status(401).json({ error: "No one is logged in." });
}

function generateToken(attributes) {
  return jwt.sign(attributes, process.env.JWT_SECRET, { expiresIn: "2 days" });
}

function changeScale(req, res) {
  const user = req.body;

  pgClient.query("UPDATE users SET rating_scale = $1 WHERE id = $2", [user.rating_scale, req.params.id])
  .then(results => {
    res.status(201).json({ id: req.params.id, message: "Rating scale changed successfully." });
  })
  .catch(error => {
    res.status(500).json({ error: `${error}` });
  });
}

const authController = { changeScale, login, logout, register, verifyToken }

module.exports = authController;