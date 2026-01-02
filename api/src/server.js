import express, { json } from "express";

const app = express();
app.use(json());

import cookies from "cookie-parser";
app.use(cookies());

import authRoutes from "./routes/authRoutes.js";
app.use("/auth", authRoutes);

import mediaRoutes from "./routes/mediaRoutes.js";
app.use("/media", mediaRoutes);

import peopleRoutes from "./routes/peopleRoutes.js";
app.use("/people", peopleRoutes);

const listener = app.listen(process.env.PORT, process.env.HOST, () => {
  console.log(`Server listening at ${listener.address().address}:${listener.address().port}`);
});