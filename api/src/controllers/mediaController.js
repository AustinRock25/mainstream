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
      SELECT ROW_NUMBER() OVER (ORDER BY COALESCE(m.release_date, s.start_date) DESC, m.title ASC) AS RowNum, m.id, m.title, m.score, m.release_date, m.rating, m.poster, m.runtime, m.completed, m.type, s.season, s.score AS score_tv, s.episodes, s.start_date, s.end_date, directors, directors_tv, cast_members, cast_members_tv, writers, writers_tv, creators
      FROM media m
      LEFT JOIN seasons s ON m.id = s.show_id
      LEFT JOIN LATERAL (
        SELECT json_agg(json_build_object('ordering', md.ordering, 'media_id', md.media_id, 'director_id', md.director_id, 'name', p.name, 'birth_date', p.birth_date, 'death_date', p.death_date)) AS directors
        FROM media_directors md
        LEFT JOIN people p ON md.director_id = p.id
        WHERE m.id = md.media_id
      ) md ON TRUE
      LEFT JOIN LATERAL (
        SELECT json_agg(json_build_object('ordering', sd.ordering, 'show_id', sd.show_id, 'director_id', sd.director_id, 'name', p.name, 'birth_date', p.birth_date, 'death_date', p.death_date)) AS directors_tv
        FROM seasons_directors sd
        LEFT JOIN people p ON sd.director_id = p.id
        WHERE m.id = sd.show_id AND s.season = sd.season
      ) sd ON TRUE
      LEFT JOIN LATERAL (
        SELECT json_agg(json_build_object('ordering', mc.ordering, 'media_id', mc.media_id, 'actor_id', mc.actor_id, 'name', p.name, 'birth_date', p.birth_date, 'death_date', p.death_date)) AS cast_members
        FROM media_cast mc
        LEFT JOIN people p ON mc.actor_id = p.id
        WHERE m.id = mc.media_id
      ) mc ON TRUE
      LEFT JOIN LATERAL (
        SELECT json_agg(json_build_object('ordering', sc.ordering, 'show_id', sc.show_id, 'actor_id', sc.actor_id, 'name', p.name, 'birth_date', p.birth_date, 'death_date', p.death_date)) AS cast_members_tv
        FROM seasons_cast sc
        LEFT JOIN people p ON sc.actor_id = p.id
        WHERE m.id = sc.show_id AND s.season = sc.season
      ) sc ON TRUE
      LEFT JOIN LATERAL (
        SELECT json_agg(json_build_object('ordering', mw.ordering, 'media_id', mw.media_id, 'writer_id', mw.writer_id, 'name', p.name, 'birth_date', p.birth_date, 'death_date', p.death_date)) AS writers
        FROM media_writers mw
        LEFT JOIN people p ON mw.writer_id = p.id
        WHERE m.id = mw.media_id
      ) mw ON TRUE
      LEFT JOIN LATERAL (
        SELECT json_agg(json_build_object('ordering', sw.ordering, 'show_id', sw.show_id, 'writer_id', sw.writer_id, 'name', p.name, 'birth_date', p.birth_date, 'death_date', p.death_date)) AS writers_tv
        FROM seasons_writers sw
        LEFT JOIN people p ON sw.writer_id = p.id
        WHERE m.id = sw.show_id AND s.season = sw.season
      ) sw ON TRUE
      LEFT JOIN LATERAL (
        SELECT json_agg(json_build_object('ordering', c.ordering, 'show_id', c.show_id, 'creator_id', c.creator_id, 'name', p.name, 'birth_date', p.birth_date, 'death_date', p.death_date)) AS creators
        FROM media_creators c
        LEFT JOIN people p ON c.creator_id = p.id
        WHERE m.id = c.show_id
      ) c ON TRUE
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
      LEFT JOIN seasons s ON m.id = s.show_id
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

const indexShows = (req, res) => {
  const sql = 
    `
      SELECT id, title, s.start_date
      FROM media m
      LEFT JOIN seasons s ON m.id = s.show_id
      WHERE type = 'show' AND completed = false AND s.season = 1
      ORDER BY s.start_date DESC
    `;

  pgClient.query(sql)
  .then(results => {
    res.status(200).json(results.rows);
  })
  .catch((error) => {
    res.status(500).json({ error: `Error: ${error}.` });
  });
}

const seasonCount = (req, res) => {
  const sql = 
    `
      SELECT COUNT(*)
      FROM seasons s
      LEFT JOIN media m ON m.id = s.show_id
	    WHERE m.id = $1
    `;

  pgClient.query(sql, [req.query.id])
  .then(results => {
    res.status(200).json(results.rows);
  })
  .catch((error) => {
    res.status(500).json({ error: `Error: ${error}.` });
  });
}

const show = (req, res) => {
  const sql = `
    SELECT id, title, score, release_date, rating, poster, runtime, type, completed, directors, cast_members, writers
    FROM media m
    LEFT JOIN LATERAL (
      SELECT json_agg(json_build_object('ordering', md.ordering, 'media_id', md.media_id, 'director_id', md.director_id, 'name', p.name, 'birth_date', p.birth_date, 'death_date', p.death_date)) AS directors
      FROM media_directors md
      LEFT JOIN people p ON md.director_id = p.id
      WHERE m.id = md.media_id
    ) md ON TRUE
    LEFT JOIN LATERAL (
      SELECT json_agg(json_build_object('ordering', mc.ordering, 'media_id', mc.media_id, 'actor_id', mc.actor_id, 'name', p.name, 'birth_date', p.birth_date, 'death_date', p.death_date)) AS cast_members
      FROM media_cast mc
      LEFT JOIN people p ON mc.actor_id = p.id
      WHERE m.id = mc.media_id
    ) mc ON TRUE
    LEFT JOIN LATERAL (
      SELECT json_agg(json_build_object('ordering', mw.ordering, 'media_id', mw.media_id, 'writer_id', mw.writer_id, 'name', p.name, 'birth_date', p.birth_date, 'death_date', p.death_date)) AS writers
      FROM media_writers mw
      LEFT JOIN people p ON mw.writer_id = p.id
      WHERE m.id = mw.media_id
    ) mw ON TRUE
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
  let directors = [];
  let writers = [];
  let castMembers = [];
  let creators = [];
  let d = 0;
  let w = 0;
  let c = 0;
  let cr = 0;

  for (let x = 0; x < media.castAndCrew.length; x++) {
    if (media.castAndCrew[x].director == true) {
      directors[d] = media.castAndCrew[x].id;
      d++;
    }
    
    if (media.castAndCrew[x].writer == true) {
      writers[w] = media.castAndCrew[x].id;
      w++;
    }

    if (media.castAndCrew[x].cast == true) {
      castMembers[c] = media.castAndCrew[x].id;
      c++;
    }

    if (media.castAndCrew[x].creator == true) {
      creators[d] = media.castAndCrew[x].id;
      cr++;
    }
  }

  if (!media.completed && media.type == "show")
    media.completed = false;

  pgClient.query("SELECT * FROM media")
  .then(result => {
    if (media.type == "movie") {
      pgClient.query("INSERT INTO media (id, title, score, release_date, rating, poster, runtime, type) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)", [result.rows.length + 1, media.title, media.score, media.release_date, media.rating, media.poster, media.runtime, media.type])
      .then(results => {
        res.location(`/media/${result.rows.length + 1}`);
        for (let i = 0; i < directors.length; i++) 
          pgClient.query("INSERT INTO media_directors (ordering, media_id, director_id) VALUES ($1, $2, $3)", [i + 1, result.rows.length + 1, directors[i]]);
        for (let i = 0; i < castMembers.length; i++)
          pgClient.query("INSERT INTO media_cast (ordering, media_id, actor_id) VALUES ($1, $2, $3)", [i + 1, result.rows.length + 1, castMembers[i]]);
        for (let i = 0; i < writers.length; i++)
          pgClient.query("INSERT INTO media_writers (ordering, media_id, writer_id) VALUES ($1, $2, $3)", [i + 1, result.rows.length + 1, writers[i]]);
        res.status(201).json({ message: "Title created successfully." });
      })
    }
    else {
      if (media.id == "na") {
        pgClient.query("INSERT INTO media (id, title, poster, rating, completed, type) VALUES ($1, $2, $3, $4, $5, $6)", [result.rows.length + 1, media.title, media.poster, media.rating, media.completed, media.type])
        .then(results => {
          res.location(`/media/${result.rows.length + 1}`);
          pgClient.query("INSERT INTO seasons (season, show_id, score, episodes, start_date, end_date) VALUES (1, $1, $2, $3, $4, $5)", [result.rows.length + 1, media.score, media.episodes, media.start_date, media.end_date]);
          for (let i = 0; i < directors.length; i++) 
            pgClient.query("INSERT INTO seasons_directors (ordering, show_id, season, director_id) VALUES ($1, $2, 1, $3)", [i + 1, result.rows.length + 1, directors[i]]);
          for (let i = 0; i < castMembers.length; i++)
            pgClient.query("INSERT INTO seasons_cast (ordering, season, show_id, actor_id) VALUES ($1, 1, $2, $3)", [i + 1, result.rows.length + 1, castMembers[i]]);
          for (let i = 0; i < writers.length; i++) 
            pgClient.query("INSERT INTO seasons_writers (ordering, show_id, season, writer_id) VALUES ($1, $2, 1, $3)", [i + 1, result.rows.length + 1, writers[i]]);
          for (let i = 0; i < creators.length; i++)
            pgClient.query("INSERT INTO media_creators (ordering, show_id, creator_id) VALUES ($1, $2, $3)", [i + 1, result.rows.length + 1, creators[i]]);
          res.status(201).json({ message: "Title created successfully." });
        })
      }
      else {
        pgClient.query("UPDATE media SET completed = $1 WHERE id = $2", [media.completed, media.id]);
        pgClient.query("SELECT * FROM seasons WHERE show_id = $1", [media.id])
        .then(result => {
          pgClient.query("INSERT INTO seasons (season, show_id, score, episodes, start_date, end_date) VALUES ($1, $2, $3, $4, $5, $6)", [result.rows.length + 1, media.id, media.score, media.episodes, media.start_date, media.end_date]);
          for (let i = 0; i < directors.length; i++) 
            pgClient.query("INSERT INTO seasons_directors (ordering, show_id, season, director_id) VALUES ($1, $2, $3, $4)", [i + 1, media.id, result.rows.length + 1, directors[i]]);
          for (let i = 0; i < castMembers.length; i++)
            pgClient.query("INSERT INTO seasons_cast (ordering, season, show_id, actor_id) VALUES ($1, $2, $3, $4)", [i + 1, result.rows.length + 1, media.id, castMembers[i]]);
          for (let i = 0; i < directors.length; i++) 
            pgClient.query("INSERT INTO seasons_writers (ordering, show_id, season, writer_id) VALUES ($1, $2, $3, $4)", [i + 1, media.id, result.rows.length + 1, writers[i]]);
          res.status(201).json({ message: "Title created successfully." });
        })
      }
    }
  })
  .catch((error) => {
    res.status(500).json({ error: `Error: ${ error }.` });
  });
}

const update = async (req, res) => {
  const media = req.body;
  let directors = [];
  let writers = [];
  let castMembers = [];
  let creators = [];
  let d = 0;
  let w = 0;
  let c = 0;
  let cr = 0;

  for (let x = 0; x < media.castAndCrew.length; x++) {
    if (media.castAndCrew[x].director == true) {
      directors[d] = media.castAndCrew[x].id;
      d++;
    }
    
    if (media.castAndCrew[x].writer == true) {
      writers[w] = media.castAndCrew[x].id;
      w++;
    }

    if (media.castAndCrew[x].cast == true) {
      castMembers[c] = media.castAndCrew[x].id;
      c++;
    }

    if (media.castAndCrew[x].creator == true) {
      creators[cr] = media.castAndCrew[x].id;
      cr++;
    }
  }

  if (!media.completed && media.type == "show")
    media.completed = false;

  let sql = "";

  if (media.type == "movie") {
    pgClient.query("UPDATE media SET title = $1, score = $2, release_date = $3, poster = $4, runtime = $5 WHERE id = $6", [media.title, media.score, media.release_date, media.poster, media.runtime, media.id])
    .then(result => {
      pgClient.query("DELETE FROM media_directors WHERE media_id = $1", [media.id])
      .then(r1 => {
        for (let i = 0; i < directors.length; i++) {
          sql += `INSERT INTO media_directors (ordering, media_id, director_id) VALUES (${i + 1}, ${req.params.id}, ${directors[i]}); `;
        }
        pgClient.query("DELETE FROM media_cast WHERE media_id = $1", [media.id])
        .then(r2 => {
          for (let i = 0; i < castMembers.length; i++) {
            sql += `INSERT INTO media_cast (ordering, media_id, actor_id) VALUES (${i + 1}, ${req.params.id}, ${castMembers[i]}); `;
          }
          pgClient.query("DELETE FROM media_writers WHERE media_id = $1", [media.id])
          .then(r3 => {
            for (let i = 0; i < writers.length; i++) {
              sql += `INSERT INTO media_writers (ordering, media_id, writer_id) VALUES (${i + 1}, ${req.params.id}, ${writers[i]}); `;
            }
            pgClient.query(sql)
            .then(r4 => {
              clearUnused();
              res.status(201).json({ message: "Title updated successfully." });
            })
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
    })
    .catch((error) => {
      res.status(500).json({ error: `Error: ${ error }` });
    });
  }
  else {
    pgClient.query("UPDATE media SET title = $1, poster = $2, completed = $3 WHERE id = $4", [media.title, media.poster, media.completed, media.id])
    .then(result => {
      pgClient.query("UPDATE seasons SET start_date = $1, end_date = $2, score = $3, episodes = $4 WHERE show_id = $5 AND season = $6", [media.start_date, media.end_date, media.score, media.episodes, media.id, media.season])
      .then(r1 => {
        pgClient.query("DELETE FROM seasons_cast WHERE show_id = $1 AND season = $2", [media.id, media.season])
        .then(r2 => {
          for (let i = 0; i < castMembers.length; i++) {
            sql += `INSERT INTO seasons_cast (ordering, season, show_id, actor_id) VALUES (${i + 1}, ${media.season}, ${req.params.id}, ${castMembers[i]}); `;
          }
          pgClient.query("DELETE FROM media_creators WHERE show_id = $1", [media.id])
          .then(r3 => {
            for (let i = 0; i < creators.length; i++) {
              sql += `INSERT INTO media_creators (ordering, show_id, creator_id) VALUES (${i + 1}, ${req.params.id}, ${creators[i]}); `;
            }
            pgClient.query("DELETE FROM seasons_directors WHERE show_id = $1 AND season = $2", [media.id, media.season])
            .then(r4 => {
              for (let i = 0; i < directors.length; i++) {
                sql += `INSERT INTO seasons_directors (ordering, show_id, season, director_id) VALUES (${i + 1}, ${req.params.id}, ${media.season}, ${directors[i]}); `;
              }
              pgClient.query("DELETE FROM seasons_writers WHERE show_id = $1 AND season = $2", [media.id, media.season])
              .then(r5 => {
                for (let i = 0; i < writers.length; i++) {
                  sql += `INSERT INTO seasons_writers (ordering, show_id, season, writer_id) VALUES (${i + 1}, ${req.params.id}, ${media.season}, ${writers[i]}); `;
                }
                pgClient.query(sql)
                .then(r6 => {
                  clearUnused();
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
    })
    .catch((error) => {
      res.status(500).json({ error: `Error: ${ error }` });
    });
  }
}

function clearUnused() {
  pgClient.query("DELETE FROM people WHERE id NOT IN (SELECT actor_id FROM media_cast) AND id NOT IN (SELECT director_id FROM media_directors) AND id NOT IN (SELECT writer_id FROM media_writers) AND id NOT IN (SELECT actor_id FROM seasons_cast) AND id NOT IN (SELECT creator_id FROM media_creators) AND id NOT IN (SELECT director_id FROM seasons_directors) AND id NOT IN (SELECT writer_id FROM seasons_writers)")
  .then(r1 => {
    if (r1.rowCount > 0) {
      pgClient.query("SELECT * FROM people ORDER BY id ASC")
      .then(r2 => {
        let sql = "";
        for (let x = 0; x < r2.rowCount; x++) {
          if ((x + 1) != r2.rows[x].id)
            sql += `UPDATE people SET id = ${x + 1} WHERE id = ${r2.rows[x].id}; `;
        }
        pgClient.query(sql);
      })
    }
  })
}

module.exports = { index, indexLength, indexShows, seasonCount, show, create, update };