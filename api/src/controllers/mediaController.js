const pgClient = require("../config/pgClient");

const index = (req, res) => {
  let searchSystem = "";
  let params = [];

  if (req.query.searchTerm != undefined && req.query.searchTerm != "") {
    searchSystem = "WHERE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(title, 'à', 'a'), 'One Hundred and One', '101'), '''', ''), 'Thirteen', '13'), 'Twelve', '12'), 'Eleven', '11'), 'é', 'e'), 'Four', '4'), 'IV', '4'), 'Eight', '8'), 'VIII', '8'), 'Seven', '7'), 'VII', '7'), 'Six', '6'), 'VI', '6'), 'Five', '5'), 'V', '5'), 'Three', '3'), 'III', '3'), 'Two', '2'), 'II', '2'), 'Nine', '9'), 'IX', '9'), 'One', '1'), 'I', '1'), '.', ''), '&', 'and'), '-', ''), ':', ''), '!', ''), ',', '') ILIKE $3 OR REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(title, 'à', 'a'), 'One Hundred and One', '101'), '''', ''), 'Thirteen', '13'), 'Twelve', '12'), 'Eleven', '11'), 'é', 'e'), 'Four', '4'), 'IV', '4'), 'Eight', '8'), 'VIII', '8'), 'Seven', '7'), 'VII', '7'), 'Six', '6'), 'VI', '6'), 'Five', '5'), 'V', '5'), 'Three', '3'), 'III', '3'), 'Two', '2'), 'II', '2'), 'Nine', '9'), 'IX', '9'), 'One', '1'), 'I', '1'), '.', ''), '&', 'and'), '-', ''), ':', ''), '!', ''), ',', '') ILIKE $4 OR title ILIKE $3 OR title ILIKE $4";
    params = [
      req.query.beginRecord,
      req.query.endRecord,
      `% ${req.query.searchTerm}%`,
      `${req.query.searchTerm}%`
    ];
  }
  else {
    params = [
      req.query.beginRecord,
      req.query.endRecord
    ];
  }
  
  const sql = `
    WITH NumberedRecords AS (
      SELECT ROW_NUMBER() OVER (ORDER BY release_date DESC, title ASC) AS RowNum, id, title, score, release_date, rating, poster, runtime, min_episode_runtime, max_episode_runtime, end_date, seasons, episodes, watched, type, directors, cast_members
      FROM media m
      LEFT JOIN LATERAL (
        SELECT json_agg(json_build_object('ordering', md.ordering, 'media_id', md.media_id, 'director_id', md.director_id, 'name', p.name, 'birth_year', p.birth_year, 'death_year', p.death_year)) AS directors
        FROM media_directors md
        LEFT JOIN people p ON md.director_id = p.id
        WHERE m.id = md.media_id
      ) md ON TRUE
      LEFT JOIN LATERAL (
        SELECT json_agg(json_build_object('ordering', mc.ordering, 'media_id', mc.media_id, 'actor_id', mc.actor_id, 'name', p.name, 'birth_year', p.birth_year, 'death_year', p.death_year)) AS cast_members
        FROM media_cast mc
        LEFT JOIN people p ON mc.actor_id = p.id
        WHERE m.id = mc.media_id
      ) mc ON TRUE
      ${searchSystem}
    )
    SELECT 
      *
    FROM 
      NumberedRecords
    WHERE 
      (RowNum BETWEEN $1 AND $2)`;

  pgClient.query(sql, params)
  .then(results => {
    res.status(200).json(results.rows);
  })
  .catch((error) => {
    res.status(500).json({ error: `Error: ${error}.` });
  });
}

const indexLength = (req, res) => {
  let searchSystem = "";
  let params = [];

  if (req.query.searchTerm != undefined && req.query.searchTerm != "") {
    searchSystem = "WHERE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(title, 'à', 'a'), 'One Hundred and One', '101'), '''', ''), 'Thirteen', '13'), 'Twelve', '12'), 'Eleven', '11'), 'é', 'e'), 'Four', '4'), 'IV', '4'), 'Eight', '8'), 'VIII', '8'), 'Seven', '7'), 'VII', '7'), 'Six', '6'), 'VI', '6'), 'Five', '5'), 'V', '5'), 'Three', '3'), 'III', '3'), 'Two', '2'), 'II', '2'), 'Nine', '9'), 'IX', '9'), 'One', '1'), 'I', '1'), '.', ''), '&', 'and'), '-', ''), ':', ''), '!', ''), ',', '') ILIKE $1 OR REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(title, 'à', 'a'), 'One Hundred and One', '101'), '''', ''), 'Thirteen', '13'), 'Twelve', '12'), 'Eleven', '11'), 'é', 'e'), 'Four', '4'), 'IV', '4'), 'Eight', '8'), 'VIII', '8'), 'Seven', '7'), 'VII', '7'), 'Six', '6'), 'VI', '6'), 'Five', '5'), 'V', '5'), 'Three', '3'), 'III', '3'), 'Two', '2'), 'II', '2'), 'Nine', '9'), 'IX', '9'), 'One', '1'), 'I', '1'), '.', ''), '&', 'and'), '-', ''), ':', ''), '!', ''), ',', '') ILIKE $2 OR title ILIKE $1 OR title ILIKE $2";
    params = [
      `% ${req.query.searchTerm}%`,
      `${req.query.searchTerm}%`
    ];
  }

  const sql = 
    `
      SELECT COUNT(*)
      FROM media m
      LEFT JOIN LATERAL (
        SELECT json_agg(json_build_object('ordering', md.ordering, 'media_id', md.media_id, 'director_id', md.director_id, 'name', p.name, 'birth_year', p.birth_year, 'death_year', p.death_year)) AS directors
        FROM media_directors md
        LEFT JOIN people p ON md.director_id = p.id
        WHERE m.id = md.media_id
      ) md ON TRUE
      LEFT JOIN LATERAL (
        SELECT json_agg(json_build_object('ordering', mc.ordering, 'media_id', mc.media_id, 'actor_id', mc.actor_id, 'name', p.name, 'birth_year', p.birth_year, 'death_year', p.death_year)) AS cast_members
        FROM media_cast mc
        LEFT JOIN people p ON mc.actor_id = p.id
        WHERE m.id = mc.media_id
      ) mc ON TRUE
      ${searchSystem}
    `;

  pgClient.query(sql, params)
  .then(results => {
    res.status(200).json(results.rows);
  })
  .catch((error) => {
    res.status(500).json({ error: `Error: ${error}.` });
  });
}

const show = (req, res) => {
  const sql = `
    SELECT id, title, score, release_date, rating, poster, runtime, min_episode_runtime, max_episode_runtime, end_date, seasons, episodes, watched, type, directors, cast_members
    FROM media m
    LEFT JOIN LATERAL (
      SELECT json_agg(json_build_object('ordering', md.ordering, 'media_id', md.media_id, 'director_id', md.director_id, 'name', p.name, 'birth_year', p.birth_year, 'death_year', p.death_year)) AS directors
      FROM media_directors md
      LEFT JOIN people p ON md.director_id = p.id
      WHERE m.id = md.media_id
    ) md ON TRUE
    LEFT JOIN LATERAL (
      SELECT json_agg(json_build_object('ordering', mc.ordering, 'media_id', mc.media_id, 'actor_id', mc.actor_id, 'name', p.name, 'birth_year', p.birth_year, 'death_year', p.death_year)) AS cast_members
      FROM media_cast mc
      LEFT JOIN people p ON mc.actor_id = p.id
      WHERE m.id = mc.media_id
    ) mc ON TRUE
    WHERE id = $1`;

  pgClient.query(sql, [req.params.id])
    .then(results => {
      if (results.rowCount > 0)
        res.json(results.rows[0]);
      else
        res.status(404).json({ error: `Title not found for id ${req.params.id}.` });
    })
    .catch((error) => {
      res.status(500).json({ error: `Error: ${error}.` });
    });
}

const create = async (req, res) => {
  const media = req.body;

  if (!media.runtime)
    media.runtime = null;

  if (!media.min_episode_runtime)
    media.min_episode_runtime = null;

  if (!media.min_episode_runtime)
    media.max_episode_runtime = null;

  if (!media.end_date)
    media.end_date = null;

  if (!media.seasons)
    media.seasons = null;

  if (!media.episodes)
    media.episodes = null;

  if (!media.watched)
    media.watched = null;

  pgClient.query("SELECT * FROM media")
  .then(result => {
    pgClient.query("INSERT INTO media (id, title, score, release_date, rating, poster, runtime, min_episode_runtime, max_episode_runtime, end_date, seasons, episodes, watched, type) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)", [result.rows.length + 1, media.title, media.score, media.release_date, media.rating, media.poster, media.runtime, media.min_episode_runtime, media.max_episode_runtime, media.end_date, media.seasons, media.episodes, media.watched, media.type])
    .then(results => {
      res.location(`/media/${result.rows.length + 1}`);
      for (let i = 0; i < media.directors.length; i++) 
        pgClient.query("INSERT INTO media_directors (ordering, media_id, director_id) VALUES ($1, $2, $3)", [i + 1, result.rows.length + 1, media.directors[i].id]);
      for (let i = 0; i < media.cast_members.length; i++)
        pgClient.query("INSERT INTO media_cast (ordering, media_id, actor_id) VALUES ($1, $2, $3)", [i + 1, result.rows.length + 1, media.cast_members[i].id]);
      res.status(201).json({ message: "Title created successfully." });
    })
    .catch((error) => {
      res.status(500).json({ error: `Error: ${ error }.` });
    });
  })
}

const update = async (req, res) => {
  const media = req.body;

  if (!media.runtime)
    media.runtime = null;

  if (!media.min_episode_runtime)
    media.min_episode_runtime = null;

  if (!media.min_episode_runtime)
    media.max_episode_runtime = null;

  if (!media.end_date)
    media.end_date = null;

  if (!media.seasons)
    media.seasons = null;

  if (!media.episodes)
    media.episodes = null;

  if (!media.watched)
    media.watched = null;

  pgClient.query("UPDATE media SET title = $1, score = $2, release_date = $3, poster = $4, min_episode_runtime = $5, max_episode_runtime = $6, end_date = $7, seasons = $8, episodes = $9, watched = $10 WHERE id = $11", [media.title, media.score, media.release_date, media.poster, media.min_episode_runtime, media.max_episode_runtime, media.end_date, media.seasons, media.episodes, media.watched, media.id])
  .then(result => {
    pgClient.query("DELETE FROM media_directors WHERE media_id = $1", [media.id])
    .then(r1 => {
      for (let i = 0; i < media.directors.length; i++) {
        pgClient.query("INSERT INTO media_directors (ordering, media_id, director_id) VALUES ($1, $2, $3)", [i + 1, req.params.id, media.directors[i].id])
        .catch((error) => {
          res.status(500).json({ error: `Error: ${ error }` });
        });
      }
      pgClient.query("DELETE FROM media_cast WHERE media_id = $1", [media.id])
      .then(r2 => {
        for (let i = 0; i < media.cast_members.length; i++) {
          pgClient.query("INSERT INTO media_cast (ordering, media_id, actor_id) VALUES ($1, $2, $3)", [i + 1, req.params.id, media.cast_members[i].id])
          .catch((error) => {
            res.status(500).json({ error: `Error: ${ error }` });
          });
        }
        res.status(201).json({ message: "Title updated successfully." });
      })
      .catch((error) => {
        res.status(500).json({ error: `Error: ${ error }` });
      });
    })
    .catch((error) => {
      res.status(500).json({ error: `Error: ${ error }` });
    });
  })
  .catch((error) => {
    res.status(500).json({ error: `Error: ${ error }` });
  });

  pgClient.query("DELETE FROM people WHERE id NOT IN (SELECT actor_id FROM media_cast) AND id NOT IN (SELECT director_id FROM media_directors)")
  .then(r1 => {
    pgClient.query("SELECT * FROM people ORDER BY id ASC")
    .then(r2 => {
      for (let x = 0; x < r2.rows.length; x++) {
        if (x + 1 != r2.rows[x].id) {
          pgClient.query("UPDATE people SET id = $1 WHERE id = $2", [x + 1, r2.rows[x].id])
          .catch((error) => {
            res.status(500).json({ error: `Error: ${ error }` });
          });
        }
      }
    })
    .catch((error) => {
      res.status(500).json({ error: `Error: ${ error }` });
    });
  })
  .catch((error) => {
    res.status(500).json({ error: `Error: ${ error }` });
  });
}

module.exports = { index, indexLength, show, create, update };