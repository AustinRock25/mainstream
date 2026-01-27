import "dotenv/config";
import pkg from "pg";
const { Pool } = pkg;

export const pgClient = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.DATABASE_URL?.includes("supabase.com") 
    ? { rejectUnauthorized: false } 
    : false
});

export const query = (text, params) => pgClient.query(text, params);
export const connect = () => pgClient.connect();