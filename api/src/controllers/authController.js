import bcrypt from "bcryptjs";
const { hashSync, compareSync } = bcrypt;
import jwt from "jsonwebtoken";
const { sign } = jwt;
import { query } from "../config/pgClient.js";
import { spawn, execSync } from "node:child_process";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const backupDatabase = () => {
  const rootPath = path.resolve(__dirname, "../../../"); 
  const backupPath = path.join(rootPath, "database.sql");
  const pgDumpPath = path.join(rootPath, "sql_binaries/bin/pg_dump.exe");

  if (!fs.existsSync(pgDumpPath)) {
    console.error(`Binary not found at: ${pgDumpPath}`);
    return;
  }

  const fileStream = fs.createWriteStream(backupPath);

  const child = spawn(pgDumpPath, ["-U", "postgres", "--no-owner", "--no-privileges", "--clean", "--if-exists","mainstream"], {
    shell: true,
    env: { ...process.env, PGPASSWORD: process.env.DB_PASSWORD }
  });

  child.stdout.pipe(fileStream);

  child.stderr.on("data", (data) => {
    console.error(`PG_DUMP ERROR: ${data.toString()}`);
  });

  try {
    console.log("--- Starting Git Backup ---");
    execSync("git add --all");
    console.log(`Update at ${new Date().toLocaleString()}`);
    execSync(`git commit -m "Update at ${new Date().toLocaleString()}"`);
    execSync("git push origin main");
    console.log("--- Git Backup Successful ---");
  } 
  catch (error) {
      console.log("Git Backup Note: No changes detected or push failed.");
  }

  child.on("close", (code) => {
    if (code === 0) 
      console.log("SUCCESS: Database synced to root.");
    else 
      console.error(`PROCESS EXITED with code: ${code}`);
  });
};

export const register = (req, res) => {
  const { email, password, rating_scale } = req.body;
  const hash = hashSync(password, 12);

  query("INSERT INTO users (email, password, rating_scale) VALUES ($1, $2, $3)", [email, hash, rating_scale])
    .then(results => {
      query("SELECT id, email FROM users WHERE email = $1", [email])
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

          backupDatabase();
        })
        .catch(error => {
          res.status(500).json({ error: `${error}` });
        });
    })
    .catch(error => {
      res.status(500).json({ error: `${error}` });
    });
}

export const login = (req, res) => {
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

  query("SELECT id, email, password, is_admin, rating_scale FROM users WHERE email = $1", [email])
    .then(results => {
      if (results.rowCount > 0) {
        if (compareSync(password, results.rows[0].password)) {
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
      console.error(error);
    });
}

export const logout = (req, res) => {
  res.clearCookie("jwt");
  res.json({ message: "Successfully logged out." });
}

export const verifyToken = (req, res) => {
  if (res.locals.user !== undefined)
    res.json(res.locals.user);
  else
    res.status(401).json({ error: "No one is logged in." });
}

function generateToken(attributes) {
  return sign(attributes, process.env.JWT_SECRET, { expiresIn: "2 days" });
}

export const changeScale = (req, res) =>{
  const user = req.body;

  query("UPDATE users SET rating_scale = $1 WHERE id = $2", [user.rating_scale, req.params.id])
  .then(results => {
    backupDatabase();
    res.status(201).json({ id: req.params.id, message: "Rating scale changed successfully." });
  })
  .catch(error => {
    res.status(500).json({ error: `${error}` });
  });
}