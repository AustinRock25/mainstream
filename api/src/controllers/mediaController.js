import { query, connect } from "../config/pgClient.js";

export const index = (req, res) => { 
  const { 
    searchTerm,
    beginRecord,
    endRecord,
    sortBy,
    sortOrder = "ASC",
    filterType,
    minRuntime,
    maxRuntime,
    minEpisodes,
    maxEpisodes,
    ratings,
    grade,
    startDate,
    endDate
  } = req.query;

  let params = [beginRecord, endRecord];
  let filterClauses = [];
  let paramIndex = 3;

  if (searchTerm || (filterType && filterType !== "all") || minRuntime || maxRuntime || minEpisodes || maxEpisodes || ratings || grade || startDate || endDate) {
    if (searchTerm) {
      const searchSystem = `(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(title, 'à', 'a'), 'One Hundred and One', '101'), '''', ''), 'Thirteen', '13'), 'Twelve', '12'), 'Eleven', '11'), 'é', 'e'), 'Four', '4'), 'IV', '4'), 'Eight', '8'), 'VIII', '8'), 'Seven', '7'), 'VII', '7'), 'Six', '6'), 'VI', '6'), 'Five', '5'), 'V', '5'), 'Three', '3'), 'III', '3'), 'Two', '2'), 'II', '2'), 'Nine', '9'), 'IX', '9'), 'One', '1'), 'I', '1'), '.', ''), '&', 'and'), '-', ''), ':', ''), '!', ''), ',', '') ILIKE $${paramIndex++} OR REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(title, 'à', 'a'), 'One Hundred and One', '101'), '''', ''), 'Thirteen', '13'), 'Twelve', '12'), 'Eleven', '11'), 'é', 'e'), 'Four', '4'), 'IV', '4'), 'Eight', '8'), 'VIII', '8'), 'Seven', '7'), 'VII', '7'), 'Six', '6'), 'VI', '6'), 'Five', '5'), 'V', '5'), 'Three', '3'), 'III', '3'), 'Two', '2'), 'II', '2'), 'Nine', '9'), 'IX', '9'), 'One', '1'), 'I', '1'), '.', ''), '&', 'and'), '-', ''), ':', ''), '!', ''), ',', '') ILIKE $${paramIndex++} OR title ILIKE $${paramIndex-2} OR title ILIKE $${paramIndex-1})`;
      filterClauses.push(searchSystem);
      params.push(`% ${searchTerm}%`, `${searchTerm}%`);
    }

    if (filterType && filterType !== "all") {
      filterClauses.push(`type = $${paramIndex++}`);
      params.push(filterType);
    }

    if (minRuntime) {
      filterClauses.push(`runtime >= $${paramIndex++}`);
      params.push(minRuntime);
    }

    if (maxRuntime) {
      filterClauses.push(`runtime <= $${paramIndex++}`);
      params.push(maxRuntime);
    }

    if (minEpisodes) {
      filterClauses.push(`episode_count >= $${paramIndex++}`);
      params.push(minEpisodes);
    }

    if (maxEpisodes) {
      filterClauses.push(`episode_count <= $${paramIndex++}`);
      params.push(maxEpisodes);
    }

    if (ratings) {
      filterClauses.push(`rating = ANY($${paramIndex++})`);
      params.push(ratings.split(","));
    }

    if (startDate) {
      filterClauses.push(`COALESCE(release_date, start_date) >= $${paramIndex++}`);
      params.push(startDate);
    }

    if (endDate) {
      filterClauses.push(`COALESCE(release_date, start_date) <= $${paramIndex++}`);
      params.push(endDate);
    }

    if (grade) {
      if (grade == "0/4")
        filterClauses.push("(COALESCE(grade, grade_tv) < (6.25))");
      else if (grade == "0.5/4")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (6.25) AND COALESCE(grade, grade_tv) < (18.75))");
      else if (grade == "1/4")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (18.75) AND COALESCE(grade, grade_tv) < (31.25))");
      else if (grade == "1.5/4")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (31.25) AND COALESCE(grade, grade_tv) < (43.75))");
      else if (grade == "2/4")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (43.75) AND COALESCE(grade, grade_tv) < (56.25))");
      else if (grade == "2.5/4")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (56.25) AND COALESCE(grade, grade_tv) < (68.75))");
      else if (grade == "3/4")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (68.75) AND COALESCE(grade, grade_tv) < (81.25))");
      else if (grade == "3.5/4")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (81.25) AND COALESCE(grade, grade_tv) < (93.75))");
      else if (grade == "4/4")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (93.75))");
      else if (grade == "0/5")
        filterClauses.push("(COALESCE(grade, grade_tv) < (5))");
      else if (grade == "0.5/5")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (5) AND COALESCE(grade, grade_tv) < (15))");
      else if (grade == "1/5")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (15) AND COALESCE(grade, grade_tv) < (25))");
      else if (grade == "1.5/5")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (25) AND COALESCE(grade, grade_tv) < (35))");
      else if (grade == "2/5")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (35) AND COALESCE(grade, grade_tv) < (45))");
      else if (grade == "2.5/5")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (45) AND COALESCE(grade, grade_tv) < (55))");
      else if (grade == "3/5")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (55) AND COALESCE(grade, grade_tv) < (65))");
      else if (grade == "3.5/5")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (65) AND COALESCE(grade, grade_tv) < (75))");
      else if (grade == "4/5")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (75) AND COALESCE(grade, grade_tv) < (85))");
      else if (grade == "4.5/5")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (85) AND COALESCE(grade, grade_tv) < (95))");
      else if (grade == "5/5")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (95))");
      else if (grade == "F")
        filterClauses.push("(COALESCE(grade, grade_tv) < (4.17))");
      else if (grade == "D-")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (4.17) AND COALESCE(grade, grade_tv) < (12.5))");
      else if (grade == "D")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (12.5) AND COALESCE(grade, grade_tv) < (20.83))");
      else if (grade == "D+")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (20.83) AND COALESCE(grade, grade_tv) < (29.17))");
      else if (grade == "C-")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (29.17) AND COALESCE(grade, grade_tv) < (37.5))");
      else if (grade == "C")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (37.5) AND COALESCE(grade, grade_tv) < (45.83))");
      else if (grade == "C+")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (45.83) AND COALESCE(grade, grade_tv) < (54.17))");
      else if (grade == "B-")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (54.17) AND COALESCE(grade, grade_tv) < (62.5))");
      else if (grade == "B")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (62.5) AND COALESCE(grade, grade_tv) < (70.83))");
      else if (grade == "B+")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (70.83) AND COALESCE(grade, grade_tv) < (79.17))");
      else if (grade == "A-")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (79.17) AND COALESCE(grade, grade_tv) < (87.5))");
      else if (grade == "A")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (87.5) AND COALESCE(grade, grade_tv) < (95.83))");
      else if (grade == "A+")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (95.83))");
      else if (grade == "1/10")
        filterClauses.push("(COALESCE(grade, grade_tv) < (5.56))");
      else if (grade == "2/10")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (5.56) AND COALESCE(grade, grade_tv) < (16.67))");
      else if (grade == "3/10")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (16.67) AND COALESCE(grade, grade_tv) < (27.78))");
      else if (grade == "4/10")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (27.78) AND COALESCE(grade, grade_tv) < (38.89))");
      else if (grade == "5/10")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (38.89) AND COALESCE(grade, grade_tv) < (50))");
      else if (grade == "6/10")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (50) AND COALESCE(grade, grade_tv) < (61.11))");
      else if (grade == "7/10")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (61.11) AND COALESCE(grade, grade_tv) < (72.22))");
      else if (grade == "8/10")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (72.22) AND COALESCE(grade, grade_tv) < (83.33))");
      else if (grade == "9/10")
        filterClauses.push("(COALESCE(grade, grade_tv) >= (83.33) AND COALESCE(grade, grade_tv) < (94.44))");
      else
        filterClauses.push("(COALESCE(grade, grade_tv) >= (94.44))");
    }
  }
  else
    filterClauses.push(`(EXTRACT(MONTH FROM COALESCE(release_date, start_date)) = EXTRACT(MONTH FROM CURRENT_DATE)) AND EXTRACT(DAY FROM COALESCE(release_date, start_date)) = EXTRACT(DAY FROM CURRENT_DATE)`);

  const whereClause = filterClauses.length > 0 ? `WHERE ${filterClauses.join(" AND ")}` : "";
  let orderByClause = "";
  const sanitizedSortOrder = ["ASC", "DESC"].includes(sortOrder.toUpperCase()) ? sortOrder.toUpperCase() : "ASC";

  switch (sortBy) {
    case "release_date":
      orderByClause = `ORDER BY COALESCE(release_date, start_date) ${sanitizedSortOrder}, title ASC`;
      break;
    case "runtime":
      orderByClause = `ORDER BY runtime ${sanitizedSortOrder}`;
      break;
    case "episodes":
      orderByClause = `ORDER BY episode_count ${sanitizedSortOrder}`;
      break;
    case "grade":
      orderByClause = `ORDER BY COALESCE(grade, grade_tv) ${sanitizedSortOrder}`;
      break;
    case "title":
    default:
      orderByClause = `ORDER BY title ${sanitizedSortOrder}`;
      break;
  }

  const sql = 
    `
      WITH FilteredData AS (
        SELECT m.id, m.title, m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id) AS grade_tv, m.release_date, (SELECT MIN(release_date) FROM seasons_episodes WHERE show_id = m.id) AS start_date, (SELECT MAX(release_date) FROM seasons_episodes WHERE show_id = m.id) AS end_date, m.rating, m.poster, m.runtime, (SELECT COUNT(*) FROM seasons_episodes WHERE show_id = m.id) AS episode_count, m.completed, m.type, seasons, directors, cast_members, writers
        FROM media m
        LEFT JOIN LATERAL (
          SELECT json_agg(json_build_object('ordering', md.ordering, 'media_id', md.media_id, 'director_id', md.director_id, 'name', p.name, 'birth_date', p.birth_date, 'death_date', p.death_date)) AS directors
          FROM media_directors md LEFT JOIN people p ON md.director_id = p.id WHERE m.id = md.media_id
        ) md ON TRUE
        LEFT JOIN LATERAL (
          SELECT json_agg(json_build_object('ordering', mc.ordering, 'media_id', mc.media_id, 'actor_id', mc.actor_id, 'name', p.name, 'birth_date', p.birth_date, 'death_date', p.death_date)) AS cast_members
          FROM media_cast mc LEFT JOIN people p ON mc.actor_id = p.id WHERE m.id = mc.media_id
        ) mc ON TRUE
        LEFT JOIN LATERAL (
          SELECT json_agg(json_build_object('ordering', mw.ordering, 'media_id', mw.media_id, 'writer_id', mw.writer_id, 'name', p.name, 'birth_date', p.birth_date, 'death_date', p.death_date)) AS writers
          FROM media_writers mw LEFT JOIN people p ON mw.writer_id = p.id WHERE m.id = mw.media_id
        ) mw ON TRUE
        LEFT JOIN LATERAL (
          SELECT json_agg(json_build_object('show_id', s.show_id, 'season', s.season, 'grade', s.grade, 'cast_members', sc.cast_members, 'episodes', se.episodes)) AS seasons
          FROM seasons s
          LEFT JOIN LATERAL (
            SELECT json_agg(json_build_object('ordering', sc.ordering, 'show_id', sc.show_id, 'season', sc.season, 'actor_id', sc.actor_id, 'name', p.name, 'birth_date', p.birth_date, 'death_date', p.death_date)) AS cast_members
            FROM seasons_cast sc LEFT JOIN people p ON sc.actor_id = p.id WHERE m.id = sc.show_id AND s.season = sc.season
          ) sc ON TRUE
          LEFT JOIN LATERAL (
            SELECT json_agg(json_build_object('show_id', se.show_id, 'season', se.season, 'episode', se.episode, 'release_date', se.release_date, 'title', se.title, 'directors', sd.directors, 'writers', sw.writers)) AS episodes
            FROM seasons_episodes se 
            LEFT JOIN LATERAL (
              SELECT json_agg(json_build_object('ordering', sd.ordering, 'show_id', sd.show_id, 'season', sd.season, 'episode', sd.episode, 'director_id', sd.director_id, 'name', p.name, 'birth_date', p.birth_date, 'death_date', p.death_date)) AS directors
              FROM seasons_directors sd LEFT JOIN people p ON sd.director_id = p.id WHERE m.id = sd.show_id AND s.season = sd.season AND se.episode = sd.episode
            ) sd ON TRUE
            LEFT JOIN LATERAL (
              SELECT json_agg(json_build_object('ordering', sw.ordering, 'show_id', sw.show_id, 'season', sw.season, 'episode', sw.episode, 'writer_id', sw.writer_id, 'name', p.name, 'birth_date', p.birth_date, 'death_date', p.death_date)) AS writers
              FROM seasons_writers sw LEFT JOIN people p ON sw.writer_id = p.id WHERE m.id = sw.show_id AND s.season = sw.season AND se.episode = sw.episode
            ) sw ON TRUE
            WHERE m.id = se.show_id AND s.season = se.season
          ) se ON TRUE
          WHERE m.id = s.show_id
        ) s ON TRUE
      ),
      FinalNumbered AS (
        SELECT ROW_NUMBER() OVER (${orderByClause}) AS RowNum, *
        FROM FilteredData 
        ${whereClause}
      )
      SELECT * FROM FinalNumbered
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
    filterType,
    minRuntime,
    maxRuntime,
    minEpisodes,
    maxEpisodes,
    ratings,
    grade,
    startDate,
    endDate
  } = req.query;

  let params = [];
  let filterClauses = [];
  let paramIndex = 1;

  if (searchTerm || (filterType && filterType !== "all") || minRuntime || maxRuntime || minEpisodes || maxEpisodes || ratings || grade || startDate || endDate) {
    if (searchTerm) {
      const searchSystem = `(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(title, 'à', 'a'), 'One Hundred and One', '101'), '''', ''), 'Thirteen', '13'), 'Twelve', '12'), 'Eleven', '11'), 'é', 'e'), 'Four', '4'), 'IV', '4'), 'Eight', '8'), 'VIII', '8'), 'Seven', '7'), 'VII', '7'), 'Six', '6'), 'VI', '6'), 'Five', '5'), 'V', '5'), 'Three', '3'), 'III', '3'), 'Two', '2'), 'II', '2'), 'Nine', '9'), 'IX', '9'), 'One', '1'), 'I', '1'), '.', ''), '&', 'and'), '-', ''), ':', ''), '!', ''), ',', '') ILIKE $${paramIndex++} OR REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(title, 'à', 'a'), 'One Hundred and One', '101'), '''', ''), 'Thirteen', '13'), 'Twelve', '12'), 'Eleven', '11'), 'é', 'e'), 'Four', '4'), 'IV', '4'), 'Eight', '8'), 'VIII', '8'), 'Seven', '7'), 'VII', '7'), 'Six', '6'), 'VI', '6'), 'Five', '5'), 'V', '5'), 'Three', '3'), 'III', '3'), 'Two', '2'), 'II', '2'), 'Nine', '9'), 'IX', '9'), 'One', '1'), 'I', '1'), '.', ''), '&', 'and'), '-', ''), ':', ''), '!', ''), ',', '') ILIKE $${paramIndex++} OR title ILIKE $${paramIndex-2} OR title ILIKE $${paramIndex-1})`;
      filterClauses.push(searchSystem);
      params.push(`% ${searchTerm}%`, `${searchTerm}%`);
    }

    if (filterType && filterType !== "all") {
      filterClauses.push(`m.type = $${paramIndex++}`);
      params.push(filterType);
    }

    if (minRuntime) {
      filterClauses.push(`m.runtime >= $${paramIndex++}`);
      params.push(minRuntime);
    }

    if (maxRuntime) {
      filterClauses.push(`m.runtime <= $${paramIndex++}`);
      params.push(maxRuntime);
    }

    if (minEpisodes) {
      filterClauses.push(`(SELECT COUNT(*) FROM seasons_episodes WHERE show_id = m.id) >= $${paramIndex++}`);
      params.push(minEpisodes);
    }

    if (maxEpisodes) {
      filterClauses.push(`(SELECT COUNT(*) FROM seasons_episodes WHERE show_id = m.id) <= $${paramIndex++}`);
      params.push(maxEpisodes);
    }

    if (ratings) {
      filterClauses.push(`m.rating = ANY($${paramIndex++})`);
      params.push(ratings.split(","));
    }

    if (startDate) {
      filterClauses.push(`COALESCE(m.release_date, (SELECT MIN(release_date) FROM seasons_episodes WHERE show_id = m.id)) >= $${paramIndex++}`);
      params.push(startDate);
    }

    if (endDate) {
      filterClauses.push(`COALESCE(m.release_date, (SELECT MIN(release_date) FROM seasons_episodes WHERE show_id = m.id)) <= $${paramIndex++}`);
      params.push(endDate);
    }

    if (grade) {
      if (grade == "0/4")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (6.25))");
      else if (grade == "0.5/4")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (6.25) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (18.75))");
      else if (grade == "1/4")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (18.75) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (31.25))");
      else if (grade == "1.5/4")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (31.25) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (43.75))");
      else if (grade == "2/4")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (43.75) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (56.25))");
      else if (grade == "2.5/4")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (56.25) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (68.75))");
      else if (grade == "3/4")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (68.75) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (81.25))");
      else if (grade == "3.5/4")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (81.25) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (93.75))");
      else if (grade == "4/4")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (93.75))");
      else if (grade == "0/5")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (5))");
      else if (grade == "0.5/5")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (5) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (15))");
      else if (grade == "1/5")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (15) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (25))");
      else if (grade == "1.5/5")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (25) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (35))");
      else if (grade == "2/5")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (35) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (45))");
      else if (grade == "2.5/5")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (45) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (55))");
      else if (grade == "3/5")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (55) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (65))");
      else if (grade == "3.5/5")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (65) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (75))");
      else if (grade == "4/5")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (75) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (85))");
      else if (grade == "4.5/5")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (85) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (95))");
      else if (grade == "5/5")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (95))");
      else if (grade == "F")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (4.17))");
      else if (grade == "D-")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (4.17) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (12.5))");
      else if (grade == "D")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (12.5) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (20.83))");
      else if (grade == "D+")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (20.83) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (29.17))");
      else if (grade == "C-")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (29.17) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (37.5))");
      else if (grade == "C")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (37.5) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (45.83))");
      else if (grade == "C+")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (45.83) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (54.17))");
      else if (grade == "B-")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (54.17) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (62.5))");
      else if (grade == "B")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (62.5) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (70.83))");
      else if (grade == "B+")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (70.83) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (79.17))");
      else if (grade == "A-")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (79.17) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (87.5))");
      else if (grade == "A")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (87.5) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (95.83))");
      else if (grade == "A+")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (95.83))");
      else if (grade == "1/10")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (5.56))");
      else if (grade == "2/10")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (5.56) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (16.67))");
      else if (grade == "3/10")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (16.67) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (27.78))");
      else if (grade == "4/10")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (27.78) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (38.89))");
      else if (grade == "5/10")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (38.89) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (50))");
      else if (grade == "6/10")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (50) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (61.11))");
      else if (grade == "7/10")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (61.11) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (72.22))");
      else if (grade == "8/10")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (72.22) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (83.33))");
      else if (grade == "9/10")
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (83.33) AND COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) < (94.44))");
      else
        filterClauses.push("(COALESCE(m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id)) >= (94.44))");
    }
  }
  else 
    filterClauses.push(`(EXTRACT(MONTH FROM COALESCE(release_date, (SELECT MIN(release_date) FROM seasons_episodes WHERE show_id = m.id))) = EXTRACT(MONTH FROM CURRENT_DATE)) AND EXTRACT(DAY FROM COALESCE(release_date, (SELECT MIN(release_date) FROM seasons_episodes WHERE show_id = m.id))) = EXTRACT(DAY FROM CURRENT_DATE)`);

  const whereClause = filterClauses.length > 0 ? `WHERE ${filterClauses.join(" AND ")}` : "";

  const sql = 
    `
      SELECT COUNT(*)
      FROM media m
      LEFT JOIN LATERAL (
        SELECT json_agg(json_build_object('show_id', s.show_id, 'season', s.season, 'grade', s.grade, 'episodes', se.episodes)) AS seasons
        FROM seasons s
        LEFT JOIN LATERAL (
          SELECT json_agg(json_build_object('show_id', se.show_id, 'season', se.season, 'episode', se.episode, 'release_date', se.release_date)) AS episodes
          FROM seasons_episodes se 
          WHERE m.id = se.show_id AND s.season = se.season
        ) se ON TRUE
        WHERE m.id = s.show_id
      ) s ON TRUE
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

export const indexShows = (req, res) => {
  const sql = 
    `
      SELECT id, title, (SELECT MIN(release_date) FROM seasons_episodes WHERE show_id = id) AS start_date
      FROM media m
      WHERE type = 'show' AND completed = false
      ORDER BY start_date DESC;
    `;

  query(sql)
  .then(results => {
    res.status(200).json(results.rows);
  })
  .catch((error) => {
    res.status(500).json({ error: `Error: ${error}.` });
  });
}

export const indexNew = (req, res) => {
  query("UPDATE media SET date_added = NULL WHERE date_added <= CURRENT_TIMESTAMP - INTERVAL '1 MONTH'");

  const sql = 
    `
      SELECT m.id, m.title, m.grade, (SELECT AVG(grade) FROM seasons WHERE show_id = m.id) AS grade_tv, m.release_date, (SELECT MIN(release_date) FROM seasons_episodes WHERE show_id = m.id) AS start_date, (SELECT MAX(release_date) FROM seasons_episodes WHERE show_id = m.id) AS end_date, m.rating, m.poster, m.runtime, (SELECT COUNT(*) FROM seasons_episodes WHERE show_id = m.id) AS episode_count, m.completed, m.type, seasons, directors, cast_members, writers
      FROM media m
      LEFT JOIN LATERAL (
        SELECT json_agg(json_build_object('ordering', md.ordering, 'media_id', md.media_id, 'director_id', md.director_id, 'name', p.name, 'birth_date', p.birth_date, 'death_date', p.death_date)) AS directors
        FROM media_directors md LEFT JOIN people p ON md.director_id = p.id WHERE m.id = md.media_id
      ) md ON TRUE
      LEFT JOIN LATERAL (
        SELECT json_agg(json_build_object('ordering', mc.ordering, 'media_id', mc.media_id, 'actor_id', mc.actor_id, 'name', p.name, 'birth_date', p.birth_date, 'death_date', p.death_date)) AS cast_members
        FROM media_cast mc LEFT JOIN people p ON mc.actor_id = p.id WHERE m.id = mc.media_id
      ) mc ON TRUE
      LEFT JOIN LATERAL (
        SELECT json_agg(json_build_object('ordering', mw.ordering, 'media_id', mw.media_id, 'writer_id', mw.writer_id, 'name', p.name, 'birth_date', p.birth_date, 'death_date', p.death_date)) AS writers
        FROM media_writers mw LEFT JOIN people p ON mw.writer_id = p.id WHERE m.id = mw.media_id
      ) mw ON TRUE
      LEFT JOIN LATERAL (
        SELECT json_agg(json_build_object('show_id', s.show_id, 'season', s.season, 'grade', s.grade, 'cast_members', sc.cast_members, 'episodes', se.episodes)) AS seasons
        FROM seasons s
        LEFT JOIN LATERAL (
          SELECT json_agg(json_build_object('ordering', sc.ordering, 'show_id', sc.show_id, 'season', sc.season, 'actor_id', sc.actor_id, 'name', p.name, 'birth_date', p.birth_date, 'death_date', p.death_date)) AS cast_members
          FROM seasons_cast sc LEFT JOIN people p ON sc.actor_id = p.id WHERE m.id = sc.show_id AND s.season = sc.season
        ) sc ON TRUE
        LEFT JOIN LATERAL (
          SELECT json_agg(json_build_object('show_id', se.show_id, 'season', se.season, 'episode', se.episode, 'release_date', se.release_date, 'title', se.title, 'directors', sd.directors, 'writers', sw.writers)) AS episodes
          FROM seasons_episodes se 
          LEFT JOIN LATERAL (
            SELECT json_agg(json_build_object('ordering', sd.ordering, 'show_id', sd.show_id, 'season', sd.season, 'episode', sd.episode, 'director_id', sd.director_id, 'name', p.name, 'birth_date', p.birth_date, 'death_date', p.death_date)) AS directors
            FROM seasons_directors sd LEFT JOIN people p ON sd.director_id = p.id WHERE m.id = sd.show_id AND s.season = sd.season AND se.episode = sd.episode
          ) sd ON TRUE
          LEFT JOIN LATERAL (
            SELECT json_agg(json_build_object('ordering', sw.ordering, 'show_id', sw.show_id, 'season', sw.season, 'episode', sw.episode, 'writer_id', sw.writer_id, 'name', p.name, 'birth_date', p.birth_date, 'death_date', p.death_date)) AS writers
            FROM seasons_writers sw LEFT JOIN people p ON sw.writer_id = p.id WHERE m.id = sw.show_id AND s.season = sw.season AND se.episode = sw.episode
          ) sw ON TRUE
          WHERE m.id = se.show_id AND s.season = se.season
        ) se ON TRUE
        WHERE m.id = s.show_id
      ) s ON TRUE
      WHERE (m.date_added IS NOT NULL AND m.date_added > CURRENT_TIMESTAMP - INTERVAL '1 MONTH')
      ORDER BY m.date_added DESC;
    `;

  query(sql)
  .then(results => {
    res.status(200).json(results.rows);
  })
  .catch((error) => {
    res.status(500).json({ error: `Error: ${error}.` });
  });
}

export const seasonCount = (req, res) => {
  const sql = 
    `
      SELECT COUNT(*)
      FROM seasons s
      LEFT JOIN media m ON m.id = s.show_id
	    WHERE m.id = $1;
    `;

  query(sql, [req.query.id])
  .then(results => {
    res.status(200).json(results.rows);
  })
  .catch((error) => {
    res.status(500).json({ error: `Error: ${error}.` });
  });
}

export const create = async (req, res) => {
  const media = req.body;
  const getIdsByRole = (role) => Array.isArray(media.castAndCrew?.filter(person => person[role])) && (media.castAndCrew?.filter(person => person[role]).map(person => person.id) || []);
  const directors = getIdsByRole("director");
  const writers = getIdsByRole("writer");
  const castMembers = getIdsByRole("cast");

  try {
    let result;

    if (media.type === "movie")
      result = await createMovie(media, { directors, writers, castMembers });
    else if (media.type === "show") {
      if (media.id === "na")
        result = await createNewShow(media, { castMembers });
      else
        result = await addSeasonToShow(media, { castMembers });
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

export const update = async (req, res) => {
  const media = req.body[0];
  const og = req.body[1];
  const client = await connect();
  const originalPersonIds = new Set();

  const addIdsToSet = (people, idKey) => {
    if (people && Array.isArray(people))
      people.forEach(p => originalPersonIds.add(p[idKey]));
  };

  addIdsToSet(og.directors, 'director_id');
  addIdsToSet(og.writers, 'writer_id');
  addIdsToSet(og.cast_members, 'actor_id');
  addIdsToSet(og.seasons[media.season - 1].cast_members, 'actor_id');
  const getIdsByRole = (role) => Array.isArray(media.castAndCrew?.filter(person => person[role])) && (media.castAndCrew?.filter(person => person[role]).map(person => person.id) || []);
  const directors = getIdsByRole("director");
  const writers = getIdsByRole("writer");
  const castMembers = getIdsByRole("cast");

  try {
    await client.query("BEGIN");
    
    if (media.type === "movie")
      await updateMovie(media, og, { directors, writers, castMembers });
    else if (media.type === "show")
      await updateShow(media, og, { castMembers });
    else
      return res.status(400).json({ error: "Invalid media type specified." });
    
    await deleteOrphanedPeople(Array.from(originalPersonIds));
    await client.query("COMMIT");
    res.status(200).json({ message: "Title updated successfully." });
  } 
  catch (error) {
    await client.query("ROLLBACK");
    console.error("Error updating media:", error);
    res.status(500).json({ error: "An error occurred while updating the title." });
  }
  finally {
    client.release();
  }
};

async function createMovie(media, { directors, writers, castMembers }) {
  const sql = 
    `
      WITH new_media AS (
        INSERT INTO media (id, title, grade, release_date, rating, poster, runtime, type, date_added)
        SELECT COALESCE(MAX(id), 0) + 1, $1, $2, $3, $4, $5, $6, 'movie', CURRENT_TIMESTAMP
        FROM media
        RETURNING id
      )
      SELECT id FROM new_media;
    `;
  
  const params = [
    media.title, 
    media.grade, 
    media.release_date, 
    media.rating,
    media.poster, 
    media.runtime
  ];

  const result = await query(sql, params);

  for (const director of directors) {
    await query(`INSERT INTO media_directors (ordering, media_id, director_id) VALUES ((SELECT COALESCE(MAX(ordering), 0) + 1 FROM media_directors WHERE media_id = $1), $1, $2)`, [result.rows[0].id, director]);
  }

  for (const cast of castMembers) {
    await query(`INSERT INTO media_cast (ordering, media_id, actor_id) VALUES ((SELECT COALESCE(MAX(ordering), 0) + 1 FROM media_cast WHERE media_id = $1), $1, $2)`, [result.rows[0].id, cast]);
  }

  for (const writer of writers) {
    await query(`INSERT INTO media_writers (ordering, media_id, writer_id) VALUES ((SELECT COALESCE(MAX(ordering), 0) + 1 FROM media_writers WHERE media_id = $1), $1, $2)`, [result.rows[0].id, writer]);
  }

  return { id: result.rows[0].id };
}

async function createNewShow(media, { castMembers }) {
  const sql = 
    `
      WITH new_media AS (
        INSERT INTO media (id, title, poster, rating, completed, type, date_added)
        SELECT COALESCE(MAX(id), 0) + 1, $1, $2, $3, $4, 'show', CURRENT_TIMESTAMP
        FROM media
        RETURNING id
      ),
      insert_season AS (
        INSERT INTO seasons (season, show_id, grade)
        VALUES (1, (SELECT id FROM new_media), $5)
      ),
      insert_episodes AS (
        INSERT INTO seasons_episodes (show_id, season, episode, title, release_date)
        SELECT (SELECT id FROM new_media), 1, ep.n, (ep.obj->>'title'), NULLIF(ep.obj->>'release_date', '')::date
        FROM json_array_elements($6::json) WITH ORDINALITY AS ep(obj, n)
      )
      SELECT id FROM new_media;
    `;
  
  const params = [
    media.title, 
    media.poster, 
    media.rating, 
    media.completed || false,
    media.grade, 
    JSON.stringify(media.episodes)
  ];
  
  const result = await query(sql, params);
  const newShowId = result.rows[0].id;

  for (let i = 0; i < media.episodes.length; i++) {
    const epNum = i + 1;
    if (media.episodes[i].creatives) {
      for (const creative of media.episodes[i].creatives) {
        if (creative.director)
          await query(`INSERT INTO seasons_directors (ordering, show_id, season, episode, director_id) VALUES ((SELECT COALESCE(MAX(ordering), 0) + 1 FROM seasons_directors WHERE show_id = $1 AND season = 1 AND episode = $2), $1, 1, $2, $3)`, [newShowId, epNum, creative.id]);

        if (creative.writer)
          await query(`INSERT INTO seasons_writers (ordering, show_id, season, episode, writer_id) VALUES ((SELECT COALESCE(MAX(ordering), 0) + 1 FROM seasons_writers WHERE show_id = $1 AND season = 1 AND episode = $2), $1, 1, $2, $3)`, [newShowId, epNum, creative.id]);
      }
    }
  }

  for (const cast of castMembers) {
    await query(
      `INSERT INTO seasons_cast (ordering, season, show_id, actor_id)
       VALUES ((SELECT COALESCE(MAX(ordering), 0) + 1 FROM seasons_cast WHERE show_id = $1 AND season = 1), 1, $1, $2)`,
       [newShowId, cast]
    );
  }

  return { id: newShowId };
}

async function addSeasonToShow(media, { castMembers }) {
  await query(`UPDATE media SET completed = $1 AND date_added = CURRENT_TIMESTAMP WHERE id = $2;`, [media.completed || false, media.id]);

  const seasonResult = await query(`SELECT COALESCE(MAX(season), 0) + 1 AS next_season FROM seasons WHERE show_id = $1`, [media.id]);
  const seasonNum = seasonResult.rows[0].next_season;

  await query(`INSERT INTO seasons (season, show_id, grade) VALUES ($1, $2, $3)`, [seasonNum, media.id, media.grade]);

  await query(
    `INSERT INTO seasons_episodes (show_id, season, episode, title, release_date) 
    SELECT $1, $2, ep.n, (ep.obj->>'title'), NULLIF(ep.obj->>'release_date', '')::date 
    FROM json_array_elements($3::json) WITH ORDINALITY AS ep(obj, n)`, 
    [media.id, seasonNum, JSON.stringify(media.episodes)]
  );

  for (let i = 0; i < media.episodes.length; i++) {
    const epNum = i + 1;
    if (media.episodes[i].creatives) {
      for (const creative of media.episodes[i].creatives) {
        if (creative.director)
          await query(`INSERT INTO seasons_directors (ordering, show_id, season, episode, director_id) VALUES ((SELECT COALESCE(MAX(ordering), 0) + 1 FROM seasons_directors WHERE show_id = $1 AND season = $2 AND episode = $3), $1, $2, $3, $4)`, [media.id, seasonNum, epNum, creative.id]);

        if (creative.writer)
          await query(`INSERT INTO seasons_writers (ordering, show_id, season, episode, writer_id) VALUES ((SELECT COALESCE(MAX(ordering), 0) + 1 FROM seasons_writers WHERE show_id = $1 AND season = $2 AND episode = $3), $1, $2, $3, $4)`, [media.id, seasonNum, epNum, creative.id]);
      }
    }
  }

  for (const cast of castMembers) {
    await query(
      `INSERT INTO seasons_cast (ordering, season, show_id, actor_id)
       VALUES ((SELECT COALESCE(MAX(ordering), 0) + 1 FROM seasons_cast WHERE show_id = $2 AND season = $1), $1, $2, $3)`,
       [seasonNum, media.id, cast]
    );
  }

  return { id: media.id };
}

async function updateMovie(media, og, { directors, writers, castMembers }) {
  let sql = ``;

  if (media.title != og.title) {
    sql = `UPDATE media SET title = $1 WHERE id = $2;`;
    await query(sql, [media.title, media.id]);
  }

  if (media.grade != og.grade) {
    sql = `UPDATE media SET grade = $1 WHERE id = $2;`;
    await query(sql, [media.grade, media.id]);
  }

  if (media.release_date != new Date(og.release_date).toISOString().split("T")[0]) {
    sql = `UPDATE media SET release_date = $1 WHERE id = $2;`;
    await query(sql, [media.release_date, media.id]);
  }

  if (media.poster != og.poster) {
    sql = `UPDATE media SET poster = $1 WHERE id = $2;`;
    await query(sql, [media.poster, media.id]);
  }

  if (media.runtime != og.runtime) {
    sql = `UPDATE media SET runtime = $1 WHERE id = $2;`;
    await query(sql, [media.runtime, media.id]);
  }

  if (media.rating != og.rating) {
    sql = `UPDATE media SET rating = $1 WHERE id = $2;`;
    await query(sql, [media.rating, media.id]);
  }

  if (!og.directors || !directors || og.directors.length != directors.length || !(directors.every(d => og.directors.some(ogd => ogd["director_id"] === d)))) {
    sql = `DELETE FROM media_directors WHERE media_id = $1;`;
    await query(sql, [media.id]);

    for (const director of directors) {
      sql = 
        `
          INSERT INTO media_directors (ordering, media_id, director_id)
          VALUES ((SELECT COALESCE(MAX(ordering), 0) + 1 FROM media_directors WHERE media_id = $1), $1, $2);
        `;

      await query(sql, [media.id, director]);
    }
  }

  if (!og.writers || !writers || og.writers.length != writers.length || !(writers.every(w => og.writers.some(ogw => ogw["writer_id"] === w)))) {
    sql = `DELETE FROM media_writers WHERE media_id = $1;`;
    await query(sql, [media.id]);

    for (const writer of writers) {
      sql = 
        `
          INSERT INTO media_writers (ordering, media_id, writer_id)
          VALUES ((SELECT COALESCE(MAX(ordering), 0) + 1 FROM media_writers WHERE media_id = $1), $1, $2);
        `;

      await query(sql, [media.id, writer]);
    }
  }

  if (!og.cast_members || !castMembers || og.cast_members.length != castMembers.length || !(castMembers.every(cm => og.cast_members.some(ogcm => ogcm["actor_id"] === cm)))) {
    sql = `DELETE FROM media_cast WHERE media_id = $1;`;
    await query(sql, [media.id]);

    for (const cast of castMembers) {
      sql = 
      `
        INSERT INTO media_cast (ordering, media_id, actor_id)
        VALUES ((SELECT COALESCE(MAX(ordering), 0) + 1 FROM media_cast WHERE media_id = $1), $1, $2);
      `;

      await query(sql, [media.id, cast]);
    }
  }
}

async function updateShow(media, og, { castMembers }) {
  if (media.title !== og.title)
    await query(`UPDATE media SET title = $1 WHERE id = $2;`, [media.title, media.id]);

  if (media.poster !== og.poster)
    await query(`UPDATE media SET poster = $1 WHERE id = $2;`, [media.poster, media.id]);

  if (media.completed !== og.completed)
    await query(`UPDATE media SET completed = $1 WHERE id = $2;`, [media.completed || false, media.id]);

  if (media.rating !== og.rating)
    await query(`UPDATE media SET rating = $1 WHERE id = $2;`, [media.rating, media.id]);

  if (media.grade !== og.seasons[media.season - 1].grade)
    await query(`UPDATE seasons SET grade = $1 WHERE show_id = $2 AND season = $3;`, [media.grade, media.id, media.season]);

  const ogCast = og.seasons[media.season - 1].cast_members?.map(cm => cm.actor_id) || [];

  if (JSON.stringify(castMembers) !== JSON.stringify(ogCast)) {
    await query(`DELETE FROM seasons_cast WHERE show_id = $1 AND season = $2;`, [media.id, media.season]);
    
    for (const cast of castMembers) {
      await query(`INSERT INTO seasons_cast (ordering, season, show_id, actor_id) VALUES ((SELECT COALESCE(MAX(ordering), 0) + 1 FROM seasons_cast WHERE show_id = $2 AND season = $1), $1, $2, $3);`, [media.season, media.id, cast]);
    }
  }

  if (JSON.stringify(media.episodes) !== JSON.stringify(og.seasons[media.season - 1].episodes)) {
    await query(`DELETE FROM seasons_episodes WHERE show_id = $1 AND season = $2;`, [media.id, media.season]);
    await query(`DELETE FROM seasons_directors WHERE show_id = $1 AND season = $2;`, [media.id, media.season]);
    await query(`DELETE FROM seasons_writers WHERE show_id = $1 AND season = $2;`, [media.id, media.season]);

    await query(
      `INSERT INTO seasons_episodes (show_id, season, episode, title, release_date)
       SELECT $1, $2, ep.n, (ep.obj->>'title'), NULLIF(ep.obj->>'release_date', '')::date
       FROM json_array_elements($3::json) WITH ORDINALITY AS ep(obj, n);`,
      [media.id, media.season, JSON.stringify(media.episodes)]
    );

    for (let i = 0; i < media.episodes.length; i++) {
      const epNum = i + 1;
      const creatives = media.episodes[i].creatives || [];

      for (const creative of creatives) {
        if (creative.director) 
          await query(`INSERT INTO seasons_directors (ordering, show_id, season, episode, director_id) VALUES ((SELECT COALESCE(MAX(ordering), 0) + 1 FROM seasons_directors WHERE show_id = $1 AND season = $2 AND episode = $3), $1, $2, $3, $4)`, [media.id, media.season, epNum, creative.id]);

        if (creative.writer)
          await query(`INSERT INTO seasons_writers (ordering, show_id, season, episode, writer_id) VALUES ((SELECT COALESCE(MAX(ordering), 0) + 1 FROM seasons_writers WHERE show_id = $1 AND season = $2 AND episode = $3), $1, $2, $3, $4)`, [media.id, media.season, epNum, creative.id]);
      }
    }
  }
}

async function deleteOrphanedPeople(personIds) {
  let subtractor = 0;

  if (!personIds || personIds.length === 0)
    return;

  const uniquePersonIds = [...new Set(personIds)];

  for (let personId of uniquePersonIds) {
    personId = personId - subtractor;

    const checkSql = 
      `
        SELECT SUM(total) as reference_count
        FROM (
          SELECT COUNT(*) as total FROM media_directors WHERE director_id = $1
          UNION ALL
          SELECT COUNT(*) as total FROM seasons_directors WHERE director_id = $1
          UNION ALL
          SELECT COUNT(*) as total FROM media_writers WHERE writer_id = $1
          UNION ALL
          SELECT COUNT(*) as total FROM seasons_writers WHERE writer_id = $1
          UNION ALL
          SELECT COUNT(*) as total FROM media_cast WHERE actor_id = $1
          UNION ALL
          SELECT COUNT(*) as total FROM seasons_cast WHERE actor_id = $1
        ) as counts;
      `;

    const result = await query(checkSql, [personId]);
    const referenceCount = parseInt(result.rows[0].reference_count, 10);

    if (referenceCount === 0) {
      const deleteSql = `DELETE FROM people WHERE id = $1;`;
      await query(deleteSql, [personId]);
      await shiftIdsAfterDeletion(personId);
      subtractor++;
    }
  }
}

async function shiftIdsAfterDeletion(deletedPersonId) {
  const client = await connect();
  try {
    await client.query("BEGIN");
    const peopleToUpdate = await client.query("SELECT id FROM people WHERE id > $1 ORDER BY id ASC", [deletedPersonId]);
    const idsToShift = Array.isArray(peopleToUpdate.rows) && peopleToUpdate.rows.map(p => p.id);

    for (const oldId of idsToShift) {
      const newId = oldId - 1;
      await client.query("UPDATE people SET id = $1 WHERE id = $2", [newId, oldId]);
    }

    const maxIdResult = await client.query("SELECT COALESCE(MAX(id), 0) as max_id FROM people");
    await client.query(`ALTER SEQUENCE people_id_seq RESTART WITH ${maxIdResult.rows[0].max_id + 1}`);
    await client.query("COMMIT");
  } 
  catch (error) {
    await client.query("ROLLBACK");
    console.error("Failed to shift IDs due to an error. Transaction was rolled back.", error);
    throw error;
  } 
  finally {
    client.release();
  }
}
