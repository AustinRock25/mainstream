const pgClient = require("../config/pgClient");

const validateMedia = async (req, res, next) => {
  const errors = {};
  const media = req.body;

  if (!media.title || media.title.length === 0)
    errors.title = "is required";

  if (!media.release_date || media.release_date.length === 0)
    errors.release_date = "is required";

  if (!media.poster || media.poster.length === 0)
    errors.poster = "is required";

  if ((!media.runtime || media.runtime.length === 0) && media.type == "movie")
    errors.runtime = "is required";

  if (!media.type || media.type.length === 0)
    errors.type = "is required";

  if (media.directors.length == 0 && media.type == "movie")
    errors.directors = "at least one is required";
  
  if (media.cast_members.length == 0)
    errors.cast_members = "at least one is required";

  if (Object.keys(errors).length > 0)
    res.status(422).json({ errors });
  else
    next();
}

const validatePerson = async (req, res, next) => {
  const errors = {};
  const person = req.body;

  if (!person.name || person.name.length === 0)
    errors.name = "is required";

  if (Object.keys(errors).length > 0)
    res.status(422).json({ errors });
  else
    next();
}

const validateUser = async (req, res, next) => {
  const errors = {};
  const user = req.body;

  if (!user.email || user.email.length === 0)
    errors.email = "is required.";

  if (user.email && user.email.length > 100)
    errors.email = "must be less than 100 characters.";

  if (!user.password || user.password.length === 0)
    errors.password = "is required.";

  if (user.password && user.password.length > 100)
    errors.password = "must be less than 100 characters.";

  const recordExists = (await pgClient.query("SELECT id FROM users WHERE email = $1", [user.email])).rowCount > 0;
  if (recordExists)
    errors.email = "already taken.";

  if (Object.keys(errors).length > 0)
    res.status(422).json({ errors });
  else
    next();
}

module.exports = { validateMedia, validatePerson, validateUser };