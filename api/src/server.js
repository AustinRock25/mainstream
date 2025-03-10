require("dotenv").config();

const express = require("express");

const app = express();
app.use(express.json());

const cookies = require("cookie-parser");
app.use(cookies());

const authRoutes = require("./routes/authRoutes");
app.use("/auth", authRoutes);

const mediaRoutes = require("./routes/mediaRoutes");
app.use("/media", mediaRoutes);

const peopleRoutes = require("./routes/peopleRoutes");
app.use("/people", peopleRoutes);

const listener = app.listen(process.env.PORT, process.env.HOST, () => {
  console.log(`Server listening at ${listener.address().address}:${listener.address().port}`);
});