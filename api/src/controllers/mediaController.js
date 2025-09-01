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
      SELECT ROW_NUMBER() OVER (ORDER BY COALESCE(m.release_date, s.end_date) DESC, m.title ASC) AS RowNum, m.id, m.title, m.grade, m.release_date, m.rating, m.poster, m.runtime, m.completed, m.type, s.season, s.grade AS grade_tv, s.episodes, s.start_date, s.end_date, directors, directors_tv, cast_members, cast_members_tv, writers, writers_tv, creators
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
    SELECT id, title, grade, release_date, rating, poster, runtime, type, completed, directors, cast_members, writers
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

  const getIdsByRole = (role) => media.castAndCrew
    ?.filter(person => person[role])
    .map(person => person.id) || [];

  const directors = getIdsByRole("director");
  const writers = getIdsByRole("writer");
  const castMembers = getIdsByRole("cast");
  const creators = getIdsByRole("creator");

  try {
    let result;
    if (media.type === "movie")
      result = await createMovie(media, { directors, writers, castMembers });
    else if (media.type === "show") {
      if (media.id === "na")
        result = await createNewShow(media, { directors, writers, castMembers, creators });
      else
        result = await addSeasonToShow(media, { directors, writers, castMembers });
    } 
    else
      return res.status(400).json({ error: "Invalid media type specified." });
    
    res.location(`/media/${result.id}`);
    res.status(201).json({ id: result.id, message: "Title processed successfully." });

  } 
  catch (error) {
    console.error("Error processing media:", error);
    res.status(500).json({ error: "An error occurred while processing the title." });
  }
};

const update = async (req, res) => {
  const media = req.body[0];
  const og = req.body[1];
  
  const getIdsByRole = (role) => media.castAndCrew
    ?.filter(person => person[role])
    .map(person => person.id) || [];

  const directors = getIdsByRole("director");
  const writers = getIdsByRole("writer");
  const castMembers = getIdsByRole("cast");
  const creators = getIdsByRole("creator");

  try {
    if (media.type === "movie")
      await updateMovie(media, og, { directors, writers, castMembers });
    else if (media.type === "show")
      await updateShow(media, og, { directors, writers, castMembers, creators });
    else
      return res.status(400).json({ error: "Invalid media type specified." });
    
    res.status(200).json({ message: "Title updated successfully." });
  } 
  catch (error) {
    console.error("Error updating media:", error);
    res.status(500).json({ error: "An error occurred while updating the title." });
  }
};

async function createMovie(media, { directors, writers, castMembers }) {
  const sql = `
    WITH new_media AS (
      INSERT INTO media (id, title, grade, release_date, rating, poster, runtime, type)
      SELECT COALESCE(MAX(id), 0) + 1, $1, $2, $3, $4, $5, $6, 'movie'
      FROM media
      RETURNING id
    ),
    insert_directors AS (
      INSERT INTO media_directors (ordering, media_id, director_id)
      SELECT row_number() OVER (), (SELECT id FROM new_media), director_id
      FROM unnest($7::int[]) AS director_id
    ),
    insert_cast AS (
      INSERT INTO media_cast (ordering, media_id, actor_id)
      SELECT row_number() OVER (), (SELECT id FROM new_media), actor_id
      FROM unnest($8::int[]) AS actor_id
    ),
    insert_writers AS (
      INSERT INTO media_writers (ordering, media_id, writer_id)
      SELECT row_number() OVER (), (SELECT id FROM new_media), writer_id
      FROM unnest($9::int[]) AS writer_id
    )
    SELECT id FROM new_media;
  `;
  
  const params = [
    media.title, 
    media.grade, 
    media.release_date, 
    media.rating,
    media.poster, 
    media.runtime,
    directors, 
    castMembers, 
    writers
  ];

  const result = await pgClient.query(sql, params);
  return { id: result.rows[0].id };
}

async function createNewShow(media, { directors, writers, castMembers, creators }) {
  const sql = `
    WITH new_media AS (
      INSERT INTO media (id, title, poster, rating, completed, type)
      SELECT COALESCE(MAX(id), 0) + 1, $1, $2, $3, $4, 'show'
      FROM media
      RETURNING id
    ),
    insert_season AS (
      INSERT INTO seasons (season, show_id, grade, episodes, start_date, end_date)
      VALUES (1, (SELECT id FROM new_media), $5, $6, $7, $8)
    ),
    insert_creators AS (
      INSERT INTO media_creators (ordering, show_id, creator_id)
      SELECT row_number() OVER (), (SELECT id FROM new_media), creator_id
      FROM unnest($9::int[]) AS creator_id
    ),
    insert_directors AS (
      INSERT INTO seasons_directors (ordering, show_id, season, director_id)
      SELECT row_number() OVER (), (SELECT id FROM new_media), 1, director_id
      FROM unnest($10::int[]) AS director_id
    ),
    insert_cast AS (
      INSERT INTO seasons_cast (ordering, season, show_id, actor_id)
      SELECT row_number() OVER (), 1, (SELECT id FROM new_media), actor_id
      FROM unnest($11::int[]) AS actor_id
    ),
    insert_writers AS (
      INSERT INTO seasons_writers (ordering, show_id, season, writer_id)
      SELECT row_number() OVER (), (SELECT id FROM new_media), 1, writer_id
      FROM unnest($12::int[]) AS writer_id
    )
    SELECT id FROM new_media;
  `;

  const params = [
    media.title, 
    media.poster, 
    media.rating, 
    media.completed || false,
    media.grade, 
    media.episodes, 
    media.start_date, 
    media.end_date,
    creators, 
    directors, 
    castMembers, 
    writers
  ];

  const result = await pgClient.query(sql, params);
  return { id: result.rows[0].id };
}

async function addSeasonToShow(media, { directors, writers, castMembers }) {
  let sql = ``;

  sql = `UPDATE media SET completed = $1 WHERE id = $2;`;
  await pgClient.query(sql, [media.completed || false, media.id]);

  sql = `
    WITH new_season_info AS (
      SELECT COALESCE(MAX(season), 0) + 1 AS season_num FROM seasons WHERE show_id = $1
    )
    INSERT INTO seasons (season, show_id, grade, episodes, start_date, end_date)
    SELECT season_num, $1, $2, $3, $4, $5 FROM new_season_info;
  `;
  await pgClient.query(sql, [media.id, media.grade, media.episodes, media.start_date, media.end_date]);

  sql = `
    WITH new_season_info AS (
      SELECT COALESCE(MAX(season), 0) AS season_num FROM seasons WHERE show_id = $1
    )
    INSERT INTO seasons_directors (ordering, show_id, season, director_id)
    SELECT row_number() OVER (), $1, (SELECT season_num FROM new_season_info), director_id
    FROM unnest($2::int[]) AS director_id;
  `;
  await pgClient.query(sql, [media.id, directors]);

  sql = `
    WITH new_season_info AS (
      SELECT COALESCE(MAX(season), 0) AS season_num FROM seasons WHERE show_id = $1
    )
    INSERT INTO seasons_cast (ordering, season, show_id, actor_id)
    SELECT row_number() OVER (), (SELECT season_num FROM new_season_info), $1, actor_id
    FROM unnest($2::int[]) AS actor_id;
  `;
  await pgClient.query(sql, [media.id, castMembers]);

  sql = `
    WITH new_season_info AS (
      SELECT COALESCE(MAX(season), 0) AS season_num FROM seasons WHERE show_id = $1
    )
    INSERT INTO seasons_writers (ordering, show_id, season, writer_id)
    SELECT row_number() OVER (), $1, (SELECT season_num FROM new_season_info), writer_id
    FROM unnest($2::int[]) AS writer_id;
  `;
  await pgClient.query(sql, [media.id, writers]);

  return { id: media.id };
}

async function updateMovie(media, og, { directors, writers, castMembers }) {
  let sql = ``;

  if (media.title != og.title) {
    sql = `UPDATE media SET title = $1 WHERE id = $2;`;
    await pgClient.query(sql, [media.title, media.id]);
  }

  if (media.grade != og.grade) {
    sql = `UPDATE media SET grade = $1 WHERE id = $2;`;
    await pgClient.query(sql, [media.grade, media.id]);
  }

  if (media.release_date != new Date(og.release_date).toISOString().split("T")[0]) {
    sql = `UPDATE media SET release_date = $1 WHERE id = $2;`;
    await pgClient.query(sql, [media.release_date, media.id]);
  }

  if (media.poster != og.poster) {
    sql = `UPDATE media SET poster = $1 WHERE id = $2;`;
    await pgClient.query(sql, [media.poster, media.id]);
  }

  if (media.runtime != og.runtime) {
    sql = `UPDATE media SET runtime = $1 WHERE id = $2;`;
    await pgClient.query(sql, [media.runtime, media.id]);
  }

  if (media.rating != og.rating) {
    sql = `UPDATE media SET rating = $1 WHERE id = $2;`;
    await pgClient.query(sql, [media.rating, media.id]);
  }

  if (!og.directors || !directors || !(directors.every(d => og.directors.some(ogd => ogd["director_id"] === d)))) {
    sql = `DELETE FROM media_directors WHERE media_id = $1;`;
    await pgClient.query(sql, [media.id]);
    sql = `
      INSERT INTO media_directors (ordering, media_id, director_id)
      SELECT row_number() OVER (), $1, director_id
      FROM unnest($2::int[]) AS director_id;
    `;
    await pgClient.query(sql, [media.id, directors]);
  }

  if (!og.writers || !writers || !(writers.every(w => og.writers.some(ogw => ogw["writer_id"] === w)))) {
    sql = `DELETE FROM media_writers WHERE media_id = $1;`;
    await pgClient.query(sql, [media.id]);
    sql = `
      INSERT INTO media_writers (ordering, media_id, writer_id)
      SELECT row_number() OVER (), $1, writer_id
      FROM unnest($2::int[]) AS writer_id;
    `;
    await pgClient.query(sql, [media.id, writers]);
  }

  if (!og.cast_members || !castMembers || !(castMembers.every(cm => og.cast_members.some(ogcm => ogcm["actor_id"] === cm)))) {
    sql = `DELETE FROM media_cast WHERE media_id = $1;`;
    await pgClient.query(sql, [media.id]);
    sql = `
      INSERT INTO media_cast (ordering, media_id, actor_id)
      SELECT row_number() OVER (), $1, actor_id
      FROM unnest($2::int[]) AS actor_id;
    `;
    await pgClient.query(sql, [media.id, castMembers]);
  }
}

async function updateShow(media, og, { directors, writers, castMembers, creators }) {
  let sql = ``;

  if (media.title != og.title) {
    sql = `UPDATE media SET title = $1 WHERE id = $2;`;
    await pgClient.query(sql, [media.title, media.id]);
  }

  if (media.poster != og.poster) {
    sql = `UPDATE media SET poster = $1 WHERE id = $2;`;
    await pgClient.query(sql, [media.poster, media.id]);
  }

  if (media.completed != og.completed) {
    sql = `UPDATE media SET completed = $1 WHERE id = $2;`;
    await pgClient.query(sql, [media.completed || false, media.id]);
  }

  if (media.rating != og.rating) {
    sql = `UPDATE media SET rating = $1 WHERE id = $2;`;
    await pgClient.query(sql, [media.rating, media.id]);
  }

  if (media.start_date != new Date(og.start_date).toISOString().split("T")[0]) {
    sql = `UPDATE seasons SET start_date = $1 WHERE show_id = $2 AND season = $3;`;
    await pgClient.query(sql, [media.start_date, media.id, media.season]);
  }

  if (media.end_date != new Date(og.end_date).toISOString().split("T")[0]) {
    sql = `UPDATE seasons SET end_date = $1 WHERE show_id = $2 AND season = $3;`;
    await pgClient.query(sql, [media.end_date, media.id, media.season]);
  }

  if (media.grade != og.grade) {
    sql = `UPDATE seasons SET grade = $1 WHERE show_id = $2 AND season = $3;`;
    await pgClient.query(sql, [media.grade, media.id, media.season]);
  }

  if (media.episodes != og.episodes) {
    sql = `UPDATE seasons SET episode = $1 WHERE show_id = $2 AND season = $3;`;
    await pgClient.query(sql, [media.episodes, media.id, media.season]);
  }
  
  if (!og.creators || !creators || !(creators.every(c => og.creators.some(ogc => ogc["creator_id"] === c)))) {
    sql = `DELETE FROM media_creators WHERE show_id = $1;`;
    await pgClient.query(sql, [media.id]);

    sql = `
      INSERT INTO media_creators (ordering, show_id, creator_id)
      SELECT row_number() OVER (), $1, creator_id
      FROM unnest($2::int[]) AS creator_id;
    `;
    await pgClient.query(sql, [media.id, creators]);
  }

  if (!og.directors_tv || !directors || !(directors.every(d => og.directors_tv.some(ogd => ogd["director_id"] === d)))) {
    sql = `DELETE FROM seasons_directors WHERE show_id = $1 AND season = $2;`;
    await pgClient.query(sql, [media.id, media.season]);
    
    sql = `
      INSERT INTO seasons_directors (ordering, season, show_id, director_id)
      SELECT row_number() OVER (), $1, $2, director_id
      FROM unnest($3::int[]) AS director_id;
    `;
    await pgClient.query(sql, [media.season, media.id, directors]);
  }

  if (!og.writers_tv || !writers || !(writers.every(w => og.writers_tv.some(ogw => ogw["writer_id"] === w)))) {
    sql = `DELETE FROM seasons_writers WHERE show_id = $1 AND season = $2;`;
    await pgClient.query(sql, [media.id, media.season]);

    sql = `
      INSERT INTO seasons_writers (ordering, season, show_id, writer_id)
      SELECT row_number() OVER (), $1, $2, writer_id
      FROM unnest($3::int[]) AS writer_id;
    `;
    await pgClient.query(sql, [media.season, media.id, writers]);
  }

  if (!og.cast_members_tv || !castMembers || !(castMembers.every(cm => og.cast_members_tv.some(ogcm => ogcm["actor_id"] === cm)))) {
    sql = `DELETE FROM seasons_cast WHERE show_id = $1 AND season = $2;`;
    await pgClient.query(sql, [media.id, media.season]);

    sql = `
      INSERT INTO seasons_cast (ordering, season, show_id, actor_id)
      SELECT row_number() OVER (), $1, $2, actor_id
      FROM unnest($3::int[]) AS actor_id;
    `;
    await pgClient.query(sql, [media.season, media.id, castMembers]);
  }
}

module.exports = { index, indexLength, indexShows, seasonCount, show, create, update };