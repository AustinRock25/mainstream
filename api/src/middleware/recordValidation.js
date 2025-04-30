const pgClient = require("../config/pgClient");

const validateMedia = async (req, res, next) => {
  const errors = {};
  const media = req.body;

  if (!media.title || media.title.length === 0)
    errors.title = "Required";

  if (!media.release_date || media.release_date.length === 0)
    errors.release_date = "Required";

  if (!media.poster || media.poster.length === 0)
    errors.poster = "Required";

  if ((!media.runtime || media.runtime.length === 0) && media.type == "movie")
    errors.runtime = "Required";

  if (!media.type || media.type.length === 0)
    errors.type = "Required";

  if (media.directors.length == 0 && media.type == "movie")
    errors.directors = "At least one is required";
  
  if (media.cast_members.length == 0)
    errors.cast_members = "At least one is required";

  if (!media.min_episode_runtime && media.type == "show")
    errors.min_episode_runtime = "Required";

  if (!media.max_episode_runtime && media.type == "show")
    errors.max_episode_runtime = "Required";

  if (!media.seasons && media.type == "show")
    errors.seasons = "Required";

  if (!media.episodes && media.type == "show")
    errors.episodes = "Required";

  if ((!media.watched || media.watched == 0) && media.type == "show")
    errors.watched = "Required";

  const recordExists = (await pgClient.query("SELECT id FROM media WHERE type = $1 AND title = $2 AND EXTRACT(YEAR FROM release_date) = $3", [media.type, media.title, new Date(media.release_date).getFullYear()])).rowCount > 0;
  if (recordExists)
    errors.title = "Already taken";

  if (Object.keys(errors).length > 0)
    res.status(422).json({ errors });
  else
    next();
}

const validatePerson = async (req, res, next) => {
  const errors = {};
  const person = req.body;

  if (!person.name || person.name.length === 0)
    errors.name = "Required";

  const recordExists = (await pgClient.query("SELECT id FROM people WHERE name = $1 AND EXTRACT(YEAR FROM birth_date) = $2", [person.name, new Date(person.birth_date).getFullYear()])).rowCount > 0;
  if (recordExists)
    errors.name = "Already taken";

  if (Object.keys(errors).length > 0)
    res.status(422).json({ errors });
  else
    next();
}

const validateUser = async (req, res, next) => {
  const errors = {};
  const user = req.body;

  if (!user.email || user.email.length === 0)
    errors.email = "Required";

  if (user.email && user.email.length > 100)
    errors.email = "Must be less than 100 characters";

  if (!user.password || user.password.length === 0)
    errors.password = "Required";

  if (user.password && user.password.length > 100)
    errors.password = "Must be less than 100 characters";

  const recordExists = (await pgClient.query("SELECT id FROM users WHERE email = $1", [user.email])).rowCount > 0;
  if (recordExists)
    errors.email = "Already taken.";

  if (Object.keys(errors).length > 0)
    res.status(422).json({ errors });
  else
    next();
}

module.exports = { validateMedia, validatePerson, validateUser };