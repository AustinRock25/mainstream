import "dotenv/config";
import pkg from "pg";
const { Pool } = pkg;

export const pgClient = new Pool({
  user: process.env.DB_USER,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
  host: process.env.DB_HOST,
});

export const query = (text, params) => pgClient.query(text, params);
export const connect = () => pgClient.connect();