import express, { json } from "express";
import cors from "cors";
import cookies from "cookie-parser";

const app = express();
const URL = `https://mainstream-api.onrender.com/healthcheck`;

setInterval(() => {
  fetch(URL)
    .then(() => 
      console.log('Keep-alive ping successful')
    )
    .catch((err) => 
      console.error('Keep-alive failed', err)
  );
}, 840000);

app.set("trust proxy", 1);

app.use(cors({
  origin: process.env.FRONTEND_URL,
  credentials: true
}));

app.use(json());
app.use(cookies());

import authRoutes from "./routes/authRoutes.js";
app.use("/auth", authRoutes);

import mediaRoutes from "./routes/mediaRoutes.js";
app.use("/media", mediaRoutes);

import peopleRoutes from "./routes/peopleRoutes.js";
app.use("/people", peopleRoutes);

app.use(express.json({ limit: '1gb' }));
app.use(express.urlencoded({ limit: '1gb', extended: true }));

app.use((err, req, res, next) => {
if (err.status === 413) {
return res.status(413).json({ message: 'Payload too large' });
}
next(err);
});

const port = process.env.PORT || 10000;
app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});