const pgClient = require("../config/pgClient");

const validateMedia = async (req, res, next) => {
  const errors = {};
  const media = req.body;

  if ((!media.id || media.id.length === 0) && media.type == "show")
    errors.id = "Required";

  if ((!media.title || media.title.length === 0) && (media.type == "movie" || media.id == "na"))
    errors.title = "Required";

  if ((!media.release_date || media.release_date.length === 0) && media.type == "movie")
    errors.release_date = "Required";

  if ((!media.start_date || media.start_date.length === 0) && media.type == "show")
    errors.start_date = "Required";

  if ((!media.end_date || media.end_date.length === 0) && media.type == "show")
    errors.end_date = "Required";

  if ((new Date(media.start_date) > new Date(media.end_date)) && media.type == "show")
    errors.start_date = "The start date can't come after the end date";

  if ((!media.poster || media.poster.length === 0) && (media.type == "movie" || media.id == "na"))
    errors.poster = "Required";

  if ((!media.runtime || media.runtime.length === 0) && media.type == "movie")
    errors.runtime = "Required";

  if (!media.type || media.type.length === 0)
    errors.type = "Required";

  if (!media.season && media.type == "show")
    errors.season = "Required";

  if (!media.episodes && media.type == "show")
    errors.episodes = "Required";

  if (!media.castAndCrew || media.castAndCrew.length == 0)
    errors.castAndCrew = "At least one is required";
  else {
    for (let x = 0; x < media.castAndCrew.length; x++) {
      if (media.castAndCrew[x].director == false && media.castAndCrew[x].writer == false && media.castAndCrew[x].cast == false)
        errors.castAndCrew = "At least one checkbox must be checked in each row";
    }
  }

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

  if ((!!person.birth_date && !!person.death_date) && (new Date(person.birth_date) > new Date(person.death_date)))
    errors.birth_date = "The birth date can't come after the death date";

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