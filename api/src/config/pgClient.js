import "dotenv/config";
import pkg from "pg";
const { Pool } = pkg;

export const pgClient = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false
  }
});

export const query = (text, params) => pgClient.query(text, params);
export const connect = () => pgClient.connect();