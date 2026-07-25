import "dotenv/config";
import pkg from "pg";
const { Pool } = pkg;

export const pgClient = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false
  }
});

pgClient.on("connect", (client) => {
  client.query("SET timezone = 'America/New_York';");
});

export const query = (text, params) => pgClient.query(text, params);
export const connect = () => pgClient.connect();