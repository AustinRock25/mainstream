import { query } from "../config/pgClient.js";

export const index = (req, res) => {
  const { 
    searchTerm,
    beginRecord,
    endRecord,
    sortBy,
    sortOrder = "ASC",
    minBirthDate,
    maxBirthDate,
    noBirthDate,
    minDeathDate,
    maxDeathDate,
    noDeathDate,
  } = req.query;

  let params = [beginRecord, endRecord];
  let filterClauses = [];
  let paramIndex = 3;

  if (searchTerm || minBirthDate || maxBirthDate || noBirthDate || minDeathDate || maxDeathDate || noDeathDate) {
    if (searchTerm) {
      const searchSystem = `(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(name, '[ŽŹŻ]+', 'Z'), '[žźż]+', 'z'), '[ŸŶÝ]+', 'Y'), '[ÿŷý]+', 'y'), 'Ŵ', 'W'), 'ŵ', 'w'), '[ŪÚÙÜÛŲŮŰŨǓ]+', 'U'), '[ūúùüûųůűũǔ]+', 'u'), '[ȚŤÞ]+', 'T'), '[țťþ]+', 't'), '[ŚŠẞŞȘ]+', 'S'), '[ßśšşș]+', 's'), 'Ř', 'R'), 'ř', 'r'), '[ÕŌØŒÓÒÖÔŐǑ]+', 'O'), '[õōøœóòöôőǒ]+', 'o'), '[ŃÑŇŅ]+', 'N'), '[ńñňņ]+', 'n'), '[ŁĽĻ]+', 'L'), '[łľļ]+', 'l'), 'Ķ', 'K'), 'ķ', 'k'), '[ÌĮĪÍÏÎİĨǏ]+', 'I'), '[ìįīíïîıĩǐ]+', 'i'), 'Ħ', 'H'), 'ħ', 'h'), '[ĞĠ]+', 'G'), '[ğġ]+', 'g'), '[ÈÉÊËĒĖĘĚẼ]+', 'E'), '[èéêëēėęěẽ]+', 'e'), '[ĎÐ]+', 'D'), '[ďð]+', 'd'), '[ÇĆČĊ]+', 'C'), '[çćčċ]+', 'c'), '[ÀÁÂÄÆÃÅĀǍĂĄ]+', 'A'), '[àáâäæãåāǎăą]+', 'a') ILIKE $${paramIndex++} OR regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(name, '[ŽŹŻ]+', 'Z'), '[žźż]+', 'z'), '[ŸŶÝ]+', 'Y'), '[ÿŷý]+', 'y'), 'Ŵ', 'W'), 'ŵ', 'w'), '[ŪÚÙÜÛŲŮŰŨǓ]+', 'U'), '[ūúùüûųůűũǔ]+', 'u'), '[ȚŤÞ]+', 'T'), '[țťþ]+', 't'), '[ŚŠẞŞȘ]+', 'S'), '[ßśšşș]+', 's'), 'Ř', 'R'), 'ř', 'r'), '[ÕŌØŒÓÒÖÔŐǑ]+', 'O'), '[õōøœóòöôőǒ]+', 'o'), '[ŃÑŇŅ]+', 'N'), '[ńñňņ]+', 'n'), '[ŁĽĻ]+', 'L'), '[łľļ]+', 'l'), 'Ķ', 'K'), 'ķ', 'k'), '[ÌĮĪÍÏÎİĨǏ]+', 'I'), '[ìįīíïîıĩǐ]+', 'i'), 'Ħ', 'H'), 'ħ', 'h'), '[ĞĠ]+', 'G'), '[ğġ]+', 'g'), '[ÈÉÊËĒĖĘĚẼ]+', 'E'), '[èéêëēėęěẽ]+', 'e'), '[ĎÐ]+', 'D'), '[ďð]+', 'd'), '[ÇĆČĊ]+', 'C'), '[çćčċ]+', 'c'), '[ÀÁÂÄÆÃÅĀǍĂĄ]+', 'A'), '[àáâäæãåāǎăą]+', 'a') ILIKE $${paramIndex++} OR name ILIKE $${paramIndex-2} OR name ILIKE $${paramIndex-1})`;
      filterClauses.push(searchSystem);
      params.push(`% ${searchTerm}%`, `${searchTerm}%`);
    }

    const hasMinBirth = minBirthDate && minBirthDate !== "";
    const hasMaxBirth = maxBirthDate && maxBirthDate !== "";

    if (noBirthDate === "true")
      filterClauses.push(`birth_date IS NULL`);
    else {
      if (hasMinBirth) {
        filterClauses.push(`birth_date >= $${paramIndex++}`);
        params.push(minBirthDate);
      }

      if (hasMaxBirth) {
        filterClauses.push(`birth_date <= $${paramIndex++}`);
        params.push(maxBirthDate);
      }
    }

    const hasMinDeath = minDeathDate && minDeathDate !== "";
    const hasMaxDeath = maxDeathDate && maxDeathDate !== "";

    if (noDeathDate === 'true')
      filterClauses.push(`death_date IS NULL`);
    else {
      if (hasMinDeath) {
        filterClauses.push(`death_date >= $${paramIndex++}`);
        params.push(minDeathDate);
      }

      if (hasMaxDeath) {
        filterClauses.push(`death_date <= $${paramIndex++}`);
        params.push(maxDeathDate);
      }
    }
  }
  else
    filterClauses.push(`EXTRACT(MONTH FROM birth_date) = EXTRACT(MONTH FROM CURRENT_DATE) AND EXTRACT(DAY FROM birth_date) = EXTRACT(DAY FROM CURRENT_DATE)`);

  const whereClause = filterClauses.length > 0 ? `WHERE ${filterClauses.join(" AND ")}` : "";
  let orderByClause = "";
  const sanitizedSortOrder = ['ASC', 'DESC'].includes(sortOrder.toUpperCase()) ? sortOrder.toUpperCase() : "ASC";

  switch (sortBy) {
    case "name":
      orderByClause = `ORDER BY name ${sanitizedSortOrder}`;
      break;
    case "death_date":
      orderByClause = `ORDER BY death_date ${sanitizedSortOrder} NULLS LAST`;
      break;
    case "birth_date":
    default:
      orderByClause = `ORDER BY birth_date ${sanitizedSortOrder} NULLS LAST`;
      break;
  }

  const sql = 
    `
      WITH NumberedRecords AS (
        SELECT ROW_NUMBER() OVER (${orderByClause}) AS RowNum, p.id, p.name, p.birth_date, p.death_date, c.credits
        FROM people p
        LEFT JOIN LATERAL (
          SELECT json_agg(json_build_object('media_id', m.id, 'title', m.title, 'release_date', CASE WHEN m.type = 'movie' THEN m.release_date ELSE NULL END, 'start_date', CASE WHEN m.type = 'show' THEN (SELECT MIN(se.release_date) FROM seasons_episodes se WHERE se.show_id = m.id AND EXISTS (SELECT 1 FROM seasons_directors sd WHERE sd.director_id = p.id AND sd.show_id = se.show_id AND sd.season = se.season AND sd.episode = se.episode UNION ALL SELECT 1 FROM seasons_writers sw WHERE sw.writer_id = p.id AND sw.show_id = se.show_id AND sw.season = se.season AND sw.episode = se.episode UNION ALL SELECT 1 FROM seasons_cast sc WHERE sc.actor_id = p.id AND sc.show_id = se.show_id AND sc.season = se.season)) ELSE NULL END, 'end_date', CASE WHEN m.type = 'show' THEN (SELECT MAX(se.release_date) FROM seasons_episodes se WHERE se.show_id = m.id AND EXISTS (SELECT 1 FROM seasons_directors sd WHERE sd.director_id = p.id AND sd.show_id = se.show_id AND sd.season = se.season AND sd.episode = se.episode UNION ALL SELECT 1 FROM seasons_writers sw WHERE sw.writer_id = p.id AND sw.show_id = se.show_id AND sw.season = se.season AND sw.episode = se.episode UNION ALL SELECT 1 FROM seasons_cast sc WHERE sc.actor_id = p.id AND sc.show_id = se.show_id AND sc.season = se.season)) ELSE NULL END)) AS credits
          FROM media m
          WHERE EXISTS (SELECT 1 FROM media_directors md WHERE md.director_id = p.id AND md.media_id = m.id) OR EXISTS (SELECT 1 FROM media_writers mw WHERE mw.writer_id = p.id AND mw.media_id = m.id) OR EXISTS (SELECT 1 FROM media_cast mc WHERE mc.actor_id = p.id AND mc.media_id = m.id) OR EXISTS (SELECT 1 FROM seasons_cast sc WHERE sc.actor_id = p.id AND sc.show_id = m.id) OR EXISTS (SELECT 1 FROM seasons_directors sd WHERE sd.director_id = p.id AND sd.show_id = m.id) OR EXISTS (SELECT 1 FROM seasons_writers sw WHERE sw.writer_id = p.id AND sw.show_id = m.id)
        ) c ON TRUE
        ${whereClause}
      )
      SELECT * FROM NumberedRecords
      WHERE RowNum BETWEEN $1 AND $2;
    `;

  query(sql, params)
  .then(results => {
    res.status(200).json(results.rows);
  })
  .catch((error) => {
    res.status(500).json({ error: `Error: ${error}.` });
  });
}

export const indexLength = (req, res) => {
  const { 
    searchTerm,
    minBirthDate,
    maxBirthDate,
    noBirthDate,
    minDeathDate,
    maxDeathDate,
    noDeathDate,
  } = req.query;
  
  let params = [];
  let filterClauses = [];
  let paramIndex = 1;

  if (searchTerm || minBirthDate || maxBirthDate || noBirthDate || minDeathDate || maxDeathDate || noDeathDate) {
    if (searchTerm) {
      const searchSystem = `(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(name, '[ŽŹŻ]+', 'Z'), '[žźż]+', 'z'), '[ŸŶÝ]+', 'Y'), '[ÿŷý]+', 'y'), 'Ŵ', 'W'), 'ŵ', 'w'), '[ŪÚÙÜÛŲŮŰŨǓ]+', 'U'), '[ūúùüûųůűũǔ]+', 'u'), '[ȚŤÞ]+', 'T'), '[țťþ]+', 't'), '[ŚŠẞŞȘ]+', 'S'), '[ßśšşș]+', 's'), 'Ř', 'R'), 'ř', 'r'), '[ÕŌØŒÓÒÖÔŐǑ]+', 'O'), '[õōøœóòöôőǒ]+', 'o'), '[ŃÑŇŅ]+', 'N'), '[ńñňņ]+', 'n'), '[ŁĽĻ]+', 'L'), '[łľļ]+', 'l'), 'Ķ', 'K'), 'ķ', 'k'), '[ÌĮĪÍÏÎİĨǏ]+', 'I'), '[ìįīíïîıĩǐ]+', 'i'), 'Ħ', 'H'), 'ħ', 'h'), '[ĞĠ]+', 'G'), '[ğġ]+', 'g'), '[ÈÉÊËĒĖĘĚẼ]+', 'E'), '[èéêëēėęěẽ]+', 'e'), '[ĎÐ]+', 'D'), '[ďð]+', 'd'), '[ÇĆČĊ]+', 'C'), '[çćčċ]+', 'c'), '[ÀÁÂÄÆÃÅĀǍĂĄ]+', 'A'), '[àáâäæãåāǎăą]+', 'a') ILIKE $${paramIndex++} OR regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(name, '[ŽŹŻ]+', 'Z'), '[žźż]+', 'z'), '[ŸŶÝ]+', 'Y'), '[ÿŷý]+', 'y'), 'Ŵ', 'W'), 'ŵ', 'w'), '[ŪÚÙÜÛŲŮŰŨǓ]+', 'U'), '[ūúùüûųůűũǔ]+', 'u'), '[ȚŤÞ]+', 'T'), '[țťþ]+', 't'), '[ŚŠẞŞȘ]+', 'S'), '[ßśšşș]+', 's'), 'Ř', 'R'), 'ř', 'r'), '[ÕŌØŒÓÒÖÔŐǑ]+', 'O'), '[õōøœóòöôőǒ]+', 'o'), '[ŃÑŇŅ]+', 'N'), '[ńñňņ]+', 'n'), '[ŁĽĻ]+', 'L'), '[łľļ]+', 'l'), 'Ķ', 'K'), 'ķ', 'k'), '[ÌĮĪÍÏÎİĨǏ]+', 'I'), '[ìįīíïîıĩǐ]+', 'i'), 'Ħ', 'H'), 'ħ', 'h'), '[ĞĠ]+', 'G'), '[ğġ]+', 'g'), '[ÈÉÊËĒĖĘĚẼ]+', 'E'), '[èéêëēėęěẽ]+', 'e'), '[ĎÐ]+', 'D'), '[ďð]+', 'd'), '[ÇĆČĊ]+', 'C'), '[çćčċ]+', 'c'), '[ÀÁÂÄÆÃÅĀǍĂĄ]+', 'A'), '[àáâäæãåāǎăą]+', 'a') ILIKE $${paramIndex++} OR name ILIKE $${paramIndex-2} OR name ILIKE $${paramIndex-1})`;
      filterClauses.push(searchSystem);
      params.push(`% ${searchTerm}%`, `${searchTerm}%`);
    }

    const hasMinBirth = minBirthDate && minBirthDate !== "";
    const hasMaxBirth = maxBirthDate && maxBirthDate !== "";

    if (noBirthDate === "true")
      filterClauses.push(`birth_date IS NULL`);
    else {
      if (hasMinBirth) {
        filterClauses.push(`birth_date >= $${paramIndex++}`);
        params.push(minBirthDate);
      }

      if (hasMaxBirth) {
        filterClauses.push(`birth_date <= $${paramIndex++}`);
        params.push(maxBirthDate);
      }
    }

    const hasMinDeath = minDeathDate && minDeathDate !== "";
    const hasMaxDeath = maxDeathDate && maxDeathDate !== "";

    if (noDeathDate === 'true')
      filterClauses.push(`death_date IS NULL`);
    else {
      if (hasMinDeath) {
        filterClauses.push(`death_date >= $${paramIndex++}`);
        params.push(minDeathDate);
      }

      if (hasMaxDeath) {
        filterClauses.push(`death_date <= $${paramIndex++}`);
        params.push(maxDeathDate);
      }
    }
  }
  else
    filterClauses.push(`EXTRACT(MONTH FROM birth_date) = EXTRACT(MONTH FROM CURRENT_DATE) AND EXTRACT(DAY FROM birth_date) = EXTRACT(DAY FROM CURRENT_DATE)`);

  const whereClause = filterClauses.length > 0 ? `WHERE ${filterClauses.join(" AND ")}` : "";

  const sql = 
    `
      SELECT COUNT(*) 
      FROM people
      ${whereClause};
    `;

  query(sql, params)
  .then(results => {
    res.status(200).json(results.rows);
  })
  .catch((error) => {
    res.status(500).json({ error: `Error: ${error}.` });
  });
}

export const indexSelect = (req, res) => {
  let searchSystem = "";
  let params = [];

  if (req.query.st != undefined && req.query.st != "") {
    searchSystem = 
      `
        With Records AS (
          SELECT p.id, p.name, p.birth_date, p.death_date
          FROM people p
		      LEFT JOIN LATERAL (
            WITH person_dates AS (
              SELECT MIN(se.release_date) AS min_date
              FROM seasons_episodes se
              WHERE EXISTS (
                SELECT 1 FROM seasons_directors sd WHERE sd.director_id = p.id AND sd.show_id = se.show_id AND sd.season = se.season AND sd.episode = se.episode UNION ALL SELECT 1 FROM seasons_writers sw WHERE sw.writer_id = p.id AND sw.show_id = se.show_id AND sw.season = se.season AND sw.episode = se.episode UNION ALL SELECT 1 FROM seasons_cast sc WHERE sc.actor_id = p.id AND sc.show_id = se.show_id AND sc.season = se.season
              )
            )
            SELECT min_date AS mdtv, MIN(release_date) AS mdm
            FROM media m
            CROSS JOIN person_dates pd
            WHERE EXISTS (SELECT 1 FROM media_directors md WHERE md.director_id = p.id AND md.media_id = m.id) OR EXISTS (SELECT 1 FROM media_writers mw WHERE mw.writer_id = p.id AND mw.media_id = m.id) OR EXISTS (SELECT 1 FROM media_cast mc WHERE mc.actor_id = p.id AND mc.media_id = m.id) OR EXISTS (SELECT 1 FROM seasons_cast sc WHERE sc.actor_id = p.id AND sc.show_id = m.id) OR EXISTS (SELECT 1 FROM seasons_directors sd WHERE sd.director_id = p.id AND sd.show_id = m.id) OR EXISTS (SELECT 1 FROM seasons_writers sw WHERE sw.writer_id = p.id AND sw.show_id = m.id)
          	GROUP BY pd.min_date
		      ) c ON TRUE
		      WHERE (regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(name, '[ŽŹŻ]+', 'Z'), '[žźż]+', 'z'), '[ŸŶÝ]+', 'Y'), '[ÿŷý]+', 'y'), 'Ŵ', 'W'), 'ŵ', 'w'), '[ŪÚÙÜÛŲŮŰŨǓ]+', 'U'), '[ūúùüûųůűũǔ]+', 'u'), '[ȚŤÞ]+', 'T'), '[țťþ]+', 't'), '[ŚŠẞŞȘ]+', 'S'), '[ßśšşș]+', 's'), 'Ř', 'R'), 'ř', 'r'), '[ÕŌØŒÓÒÖÔŐǑ]+', 'O'), '[õōøœóòöôőǒ]+', 'o'), '[ŃÑŇŅ]+', 'N'), '[ńñňņ]+', 'n'), '[ŁĽĻ]+', 'L'), '[łľļ]+', 'l'), 'Ķ', 'K'), 'ķ', 'k'), '[ÌĮĪÍÏÎİĨǏ]+', 'I'), '[ìįīíïîıĩǐ]+', 'i'), 'Ħ', 'H'), 'ħ', 'h'), '[ĞĠ]+', 'G'), '[ğġ]+', 'g'), '[ÈÉÊËĒĖĘĚẼ]+', 'E'), '[èéêëēėęěẽ]+', 'e'), '[ĎÐ]+', 'D'), '[ďð]+', 'd'), '[ÇĆČĊ]+', 'C'), '[çćčċ]+', 'c'), '[ÀÁÂÄÆÃÅĀǍĂĄ]+', 'A'), '[àáâäæãåāǎăą]+', 'a') ILIKE $1 OR regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(name, '[ŽŹŻ]+', 'Z'), '[žźż]+', 'z'), '[ŸŶÝ]+', 'Y'), '[ÿŷý]+', 'y'), 'Ŵ', 'W'), 'ŵ', 'w'), '[ŪÚÙÜÛŲŮŰŨǓ]+', 'U'), '[ūúùüûųůűũǔ]+', 'u'), '[ȚŤÞ]+', 'T'), '[țťþ]+', 't'), '[ŚŠẞŞȘ]+', 'S'), '[ßśšşș]+', 's'), 'Ř', 'R'), 'ř', 'r'), '[ÕŌØŒÓÒÖÔŐǑ]+', 'O'), '[õōøœóòöôőǒ]+', 'o'), '[ŃÑŇŅ]+', 'N'), '[ńñňņ]+', 'n'), '[ŁĽĻ]+', 'L'), '[łľļ]+', 'l'), 'Ķ', 'K'), 'ķ', 'k'), '[ÌĮĪÍÏÎİĨǏ]+', 'I'), '[ìįīíïîıĩǐ]+', 'i'), 'Ħ', 'H'), 'ħ', 'h'), '[ĞĠ]+', 'G'), '[ğġ]+', 'g'), '[ÈÉÊËĒĖĘĚẼ]+', 'E'), '[èéêëēėęěẽ]+', 'e'), '[ĎÐ]+', 'D'), '[ďð]+', 'd'), '[ÇĆČĊ]+', 'C'), '[çćčċ]+', 'c'), '[ÀÁÂÄÆÃÅĀǍĂĄ]+', 'A'), '[àáâäæãåāǎăą]+', 'a') ILIKE $2 OR name ILIKE $1 OR name ILIKE $2) AND ((($3 >= (birth_date + (LEAST(mdm, mdtv) - birth_date) / 2)) OR (birth_date IS NULL AND ($3 >= (LEAST(mdm, mdtv) - INTERVAL '3 YEARS')))) AND (death_date IS NULL OR ($3 <= death_date + INTERVAL '3 YEARS'))) 
          ORDER BY birth_date ASC, name ASC
		    )
        SELECT * FROM Records;
      `;

    params = [
      `${req.query.st}%`,
      `% ${req.query.st}%`,
      req.query.date
    ];
  }

  const sql = `${searchSystem}`;

  query(sql, params)
  .then(results => {
    res.status(200).json(results.rows);
  })
  .catch((error) => {
    res.status(500).json({ error: `Error: ${error}.` });
  });
}

export const create = async (req, res) => {
  const person = req.body;

  if (!person.birth_date)
    person.birth_date = null;

  if (!person.death_date)
    person.death_date = null;

  const sql = 
    `
      WITH new_id_cte AS (
        SELECT COUNT(*) + 1 AS id FROM people
      )
      INSERT INTO people (id, name, birth_date, death_date)
      SELECT id, $1, $2, $3
      FROM new_id_cte
      RETURNING id;
    `;

  const params = [
    person.name,
    person.birth_date, 
    person.death_date
  ];

  query(sql, params)
  .then(result => {
    res.location(`/people/${result.rows[0].id}`);
    res.status(201).json({ message: "Person created successfully." });
  })
  .catch((error) => {
    res.status(500).json({ error: `Error: ${ error }.` });
  });
}

export const update = async (req, res) => {
  const person = req.body;

  if (!person.birth_date)
    person.birth_date = null;

  if (!person.death_date)
    person.death_date = null;

  query("UPDATE people SET name = $1, birth_date = $2, death_date = $3 WHERE id = $4", [person.name, person.birth_date, person.death_date, person.id])
  .then(results => {
    res.status(201).json({ message: "Person successfully updated." });
  })
  .catch((error) => {
    res.status(500).json({ error: `Error: ${ error }` });
  })
}