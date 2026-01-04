import { query, connect } from "../config/pgClient.js";
import { spawn, execSync } from "node:child_process";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const backupDatabase = () => {
  const rootPath = path.resolve(__dirname, "../../../"); 
  const backupPath = path.join(rootPath, "database.sql");
  const pgDumpPath = path.join(rootPath, "sql_binaries/bin/pg_dump.exe");
  const gitPath = path.join(rootPath, "git_binaries/bin/git.exe");

  if (!fs.existsSync(pgDumpPath)) {
    console.error(`Binary not found at: ${pgDumpPath}`);
    return;
  }

  if (!fs.existsSync(gitPath)) {
    console.error(`Binary not found at: ${gitPath}`);
    return;
  }

  const fileStream = fs.createWriteStream(backupPath);

  const child = spawn(pgDumpPath, ["-U", "postgres", "--no-owner", "--no-privileges", "--clean", "--if-exists", "mainstream"], {
    shell: true,
    env: { ...process.env, PGPASSWORD: process.env.DB_PASSWORD }
  });

  child.stdout.pipe(fileStream);

  child.stderr.on("data", (data) => {
    console.error(`PG_DUMP ERROR: ${data.toString()}`);
  });

  try {
    const gitCmdBase = `"${gitPath}" --work-tree="${rootPath}" --git-dir="${path.join(rootPath, ".git")}"`;
    
    execSync(`${gitCmdBase} add --all`, { cwd: rootPath });
    execSync(`${gitCmdBase} commit -m "Update at ${new Date().toLocaleString()}"`, { cwd: rootPath });
    execSync(`${gitCmdBase} push origin main`, { cwd: rootPath });
    
    console.log("--- Git Backup Successful ---");
  } 
  catch (error) {
    console.log("Git Backup Note: No changes detected or push failed.");
  }

  child.on("close", (code) => {
    if (code === 0) 
      console.log("SUCCESS: Database synced to root.");
    else 
      console.error(`PROCESS EXITED with code: ${code}`);
  });
};

export const index = (req, res) => {
  const { 
    searchTerm,
    beginRecord,
    endRecord,
    sortBy,
    sortOrder = "DESC",
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
    filterClauses.push(`COALESCE(m.runtime, s.runtime) >= $${paramIndex++}`);
    params.push(minRuntime);
  }

  if (maxRuntime) {
    filterClauses.push(`COALESCE(m.runtime, s.runtime) <= $${paramIndex++}`);
    params.push(maxRuntime);
  }

  if (minEpisodes) {
    filterClauses.push(`s.episodes >= $${paramIndex++}`);
    params.push(minEpisodes);
  }

  if (maxEpisodes) {
    filterClauses.push(`s.episodes <= $${paramIndex++}`);
    params.push(maxEpisodes);
  }

  if (ratings) {
    filterClauses.push(`m.rating = ANY($${paramIndex++})`);
    params.push(ratings.split(","));
  }

  if (startDate) {
    filterClauses.push(`COALESCE(m.release_date, s.start_date) >= $${paramIndex++}`);
    params.push(startDate);
  }

  if (endDate) {
    filterClauses.push(`COALESCE(m.release_date, s.start_date) <= $${paramIndex++}`);
    params.push(endDate);
  }

  if (grade) {
    if (grade == "0/4")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '0/4') OR (COALESCE(m.grade, s.grade) = '0/5') OR (COALESCE(m.grade, s.grade) = '0.5/5') OR (COALESCE(m.grade, s.grade) = 'F')");
    else if (grade == "0.5/4")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '0.5/4')");
    else if (grade == "1/4")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '1/4') OR (COALESCE(m.grade, s.grade) = '1/5') OR (COALESCE(m.grade, s.grade) = '1.5/5') OR (COALESCE(m.grade, s.grade) = 'D-') OR (COALESCE(m.grade, s.grade) = 'D') OR (COALESCE(m.grade, s.grade) = 'D+')");
    else if (grade == "1.5/4")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '1.5/4')");
    else if (grade == "2/4")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '2/4') OR (COALESCE(m.grade, s.grade) = '2/5') OR (COALESCE(m.grade, s.grade) = '2.5/5') OR (COALESCE(m.grade, s.grade) = '3/5') OR (COALESCE(m.grade, s.grade) = 'C-') OR (COALESCE(m.grade, s.grade) = 'C') OR (COALESCE(m.grade, s.grade) = 'C+')");
    else if (grade == "2.5/4")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '2.5/4')");
    else if (grade == "3/4")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '3/4') OR (COALESCE(m.grade, s.grade) = '3.5/5') OR (COALESCE(m.grade, s.grade) = '4/5') OR (COALESCE(m.grade, s.grade) = 'B-') OR (COALESCE(m.grade, s.grade) = 'B') OR (COALESCE(m.grade, s.grade) = 'B+')");
    else if (grade == "3.5/4")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '3.5/4')");
    else if (grade == "4/4")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '4/4') OR (COALESCE(m.grade, s.grade) = '4.5/5') OR (COALESCE(m.grade, s.grade) = '5/5') OR (COALESCE(m.grade, s.grade) = 'A-') OR (COALESCE(m.grade, s.grade) = 'A') OR (COALESCE(m.grade, s.grade) = 'A+')");
    else if (grade == "0/5")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '0/4') OR (COALESCE(m.grade, s.grade) = '0/5') OR (COALESCE(m.grade, s.grade) = 'F')");
    else if (grade == "0.5/5")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '0.5/5')");
    else if (grade == "1/5")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '0.5/4') OR (COALESCE(m.grade, s.grade) = '1/4') OR (COALESCE(m.grade, s.grade) = '1/5') OR (COALESCE(m.grade, s.grade) = 'D-') OR (COALESCE(m.grade, s.grade) = 'D')");
    else if (grade == "1.5/5")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '1.5/5')");
    else if (grade == "2/5")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '1.5/4') OR (COALESCE(m.grade, s.grade) = '2/5') OR (COALESCE(m.grade, s.grade) = 'D+') OR (COALESCE(m.grade, s.grade) = 'C-') OR (COALESCE(m.grade, s.grade) = 'C')");
    else if (grade == "2.5/5")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '2.5/5')");
    else if (grade == "3/5")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '2/4') OR (COALESCE(m.grade, s.grade) = '2.5/4') OR (COALESCE(m.grade, s.grade) = '3/5') OR (COALESCE(m.grade, s.grade) = 'C+') OR (COALESCE(m.grade, s.grade) = 'B-')");
    else if (grade == "3.5/5")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '3.5/5')");
    else if (grade == "4/5")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '3/4') OR (COALESCE(m.grade, s.grade) = '3.5/4') OR (COALESCE(m.grade, s.grade) = '4/5') OR (COALESCE(m.grade, s.grade) = 'B') OR (COALESCE(m.grade, s.grade) = 'B+') OR (COALESCE(m.grade, s.grade) = 'A-')");
    else if (grade == "4.5/5")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '4.5/5')");
    else if (grade == "5/5")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '4/4') OR (COALESCE(m.grade, s.grade) = '5/5') OR (COALESCE(m.grade, s.grade) = 'A') OR (COALESCE(m.grade, s.grade) = 'A+')");
    else if (grade == "F")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '0/4') OR (COALESCE(m.grade, s.grade) = '0.5/4') OR (COALESCE(m.grade, s.grade) = '0/5') OR (COALESCE(m.grade, s.grade) = '0.5/5') OR (COALESCE(m.grade, s.grade) = 'F')");
    else if (grade == "D-")
      filterClauses.push("(COALESCE(m.grade, s.grade) = 'D-')");
    else if (grade == "D")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '1/4') OR (COALESCE(m.grade, s.grade) = '1.5/4') OR (COALESCE(m.grade, s.grade) = '1/5') OR (COALESCE(m.grade, s.grade) = '1.5/5') OR (COALESCE(m.grade, s.grade) = 'D')");
    else if (grade == "D+")
      filterClauses.push("(COALESCE(m.grade, s.grade) = 'D+')");
    else if (grade == "C-")
      filterClauses.push("(COALESCE(m.grade, s.grade) = 'C-')");
    else if (grade == "C")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '2/4') OR (COALESCE(m.grade, s.grade) = '2/5') OR (COALESCE(m.grade, s.grade) = '2.5/5') OR (COALESCE(m.grade, s.grade) = '3/5') OR (COALESCE(m.grade, s.grade) = 'C')");
    else if (grade == "C+")
      filterClauses.push("(COALESCE(m.grade, s.grade) = 'C+')");
    else if (grade == "B-")
      filterClauses.push("(COALESCE(m.grade, s.grade) = 'B-')");
    else if (grade == "B")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '2.5/4') OR (COALESCE(m.grade, s.grade) = '3/4') OR (COALESCE(m.grade, s.grade) = '3.5/5') OR (COALESCE(m.grade, s.grade) = '4/5') OR (COALESCE(m.grade, s.grade) = 'B')");
    else if (grade == "B+")
      filterClauses.push("(COALESCE(m.grade, s.grade) = 'B+')");
    else if (grade == "A-")
      filterClauses.push("(COALESCE(m.grade, s.grade) = 'A-')");
    else if (grade == "A")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '3.5/4') OR (COALESCE(m.grade, s.grade) = '4/4') OR (COALESCE(m.grade, s.grade) = '4.5/5') OR (COALESCE(m.grade, s.grade) = '5/5') OR (COALESCE(m.grade, s.grade) = 'A')");
    else if (grade == "A+")
      filterClauses.push("(COALESCE(m.grade, s.grade) = 'A+')");
    else if (grade == "1/10")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '0/4') OR (COALESCE(m.grade, s.grade) = '0/5') OR (COALESCE(m.grade, s.grade) = '0.5/5') OR (COALESCE(m.grade, s.grade) = 'F')");
    else if (grade == "2/10")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '0.5/4') OR (COALESCE(m.grade, s.grade) = '1/5')");
    else if (grade == "3/10")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '1/4') OR (COALESCE(m.grade, s.grade) = '1.5/5') OR (COALESCE(m.grade, s.grade) = 'D-') OR (COALESCE(m.grade, s.grade) = 'D')");
    else if (grade == "4/10")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '1.5/4') OR (COALESCE(m.grade, s.grade) = '2/5') OR (COALESCE(m.grade, s.grade) = 'D+')");
    else if (grade == "5/10")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '2/4') OR (COALESCE(m.grade, s.grade) = '2.5/5') OR (COALESCE(m.grade, s.grade) = 'C-') OR (COALESCE(m.grade, s.grade) = 'C')");
    else if (grade == "6/10")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '3/5') OR (COALESCE(m.grade, s.grade) = 'C+')");
    else if (grade == "7/10")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '2.5/4') OR (COALESCE(m.grade, s.grade) = '3.5/5') OR (COALESCE(m.grade, s.grade) = 'B-') OR (COALESCE(m.grade, s.grade) = 'B')");
    else if (grade == "8/10")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '3/4') OR (COALESCE(m.grade, s.grade) = '4/5') OR (COALESCE(m.grade, s.grade) = 'B+')");
    else if (grade == "9/10")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '3.5/4') OR (COALESCE(m.grade, s.grade) = '4.5/5') OR (COALESCE(m.grade, s.grade) = 'A-') OR (COALESCE(m.grade, s.grade) = 'A')");
    else if (grade == "10/10")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '4/4') OR (COALESCE(m.grade, s.grade) = '5/5') OR (COALESCE(m.grade, s.grade) = 'A+')");
  }

  const whereClause = filterClauses.length > 0 ? `WHERE ${filterClauses.join(" AND ")}` : "";
  let orderByClause = "";
  const sanitizedSortOrder = ["ASC", "DESC"].includes(sortOrder.toUpperCase()) ? sortOrder.toUpperCase() : "DESC";

  switch (sortBy) {
    case "title":
      orderByClause = `ORDER BY m.title ${sanitizedSortOrder}, s.season ${sanitizedSortOrder}`;
      break;
    case "runtime":
      orderByClause = `ORDER BY COALESCE(m.runtime, s.runtime) ${sanitizedSortOrder}`;
      break;
    case "episodes":
      orderByClause = `ORDER BY s.episodes ${sanitizedSortOrder}`;
      break;
    case "grade":
      orderByClause = `ORDER BY COALESCE(m.grade, s.grade) ${sanitizedSortOrder}`;
      break;
    case "release_date":
    default:
      orderByClause = `ORDER BY COALESCE(m.release_date, s.start_date) ${sanitizedSortOrder}, m.title ASC`;
      break;
  }

  const sql = 
    `
      WITH NumberedRecords AS (
        SELECT ROW_NUMBER() OVER (${orderByClause}) AS RowNum, 
              m.id, m.title, m.grade, m.release_date, m.rating, m.poster, m.runtime, m.completed, m.type, 
              s.season, s.grade AS grade_tv, s.episodes, s.runtime AS runtime_tv, s.start_date, s.end_date, 
              directors, directors_tv, cast_members, cast_members_tv, writers, writers_tv
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
        ${whereClause}
      )
      SELECT * FROM NumberedRecords
      WHERE (RowNum BETWEEN $1 AND $2);
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
    filterClauses.push(`COALESCE(m.runtime, s.runtime) >= $${paramIndex++}`);
    params.push(minRuntime);
  }

  if (maxRuntime) {
    filterClauses.push(`COALESCE(m.runtime, s.runtime) <= $${paramIndex++}`);
    params.push(maxRuntime);
  }

  if (minEpisodes) {
    filterClauses.push(`s.episodes >= $${paramIndex++}`);
    params.push(minEpisodes);
  }

  if (maxEpisodes) {
    filterClauses.push(`s.episodes <= $${paramIndex++}`);
    params.push(maxEpisodes);
  }

  if (ratings) {
    filterClauses.push(`m.rating = ANY($${paramIndex++})`);
    params.push(ratings.split(','));
  }

  if (startDate) {
    filterClauses.push(`COALESCE(m.release_date, s.start_date) >= $${paramIndex++}`);
    params.push(startDate);
  }

  if (endDate) {
    filterClauses.push(`COALESCE(m.release_date, s.start_date) <= $${paramIndex++}`);
    params.push(endDate);
  }

  if (grade) {
    if (grade == "0/4")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '0/4') OR (COALESCE(m.grade, s.grade) = '0/5') OR (COALESCE(m.grade, s.grade) = '0.5/5') OR (COALESCE(m.grade, s.grade) = 'F')");
    else if (grade == "0.5/4")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '0.5/4')");
    else if (grade == "1/4")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '1/4') OR (COALESCE(m.grade, s.grade) = '1/5') OR (COALESCE(m.grade, s.grade) = '1.5/5') OR (COALESCE(m.grade, s.grade) = 'D-') OR (COALESCE(m.grade, s.grade) = 'D') OR (COALESCE(m.grade, s.grade) = 'D+')");
    else if (grade == "1.5/4")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '1.5/4')");
    else if (grade == "2/4")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '2/4') OR (COALESCE(m.grade, s.grade) = '2/5') OR (COALESCE(m.grade, s.grade) = '2.5/5') OR (COALESCE(m.grade, s.grade) = '3/5') OR (COALESCE(m.grade, s.grade) = 'C-') OR (COALESCE(m.grade, s.grade) = 'C') OR (COALESCE(m.grade, s.grade) = 'C+')");
    else if (grade == "2.5/4")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '2.5/4')");
    else if (grade == "3/4")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '3/4') OR (COALESCE(m.grade, s.grade) = '3.5/5') OR (COALESCE(m.grade, s.grade) = '4/5') OR (COALESCE(m.grade, s.grade) = 'B-') OR (COALESCE(m.grade, s.grade) = 'B') OR (COALESCE(m.grade, s.grade) = 'B+')");
    else if (grade == "3.5/4")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '3.5/4')");
    else if (grade == "4/4")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '4/4') OR (COALESCE(m.grade, s.grade) = '4.5/5') OR (COALESCE(m.grade, s.grade) = '5/5') OR (COALESCE(m.grade, s.grade) = 'A-') OR (COALESCE(m.grade, s.grade) = 'A') OR (COALESCE(m.grade, s.grade) = 'A+')");
    else if (grade == "0/5")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '0/4') OR (COALESCE(m.grade, s.grade) = '0/5') OR (COALESCE(m.grade, s.grade) = 'F')");
    else if (grade == "0.5/5")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '0.5/5')");
    else if (grade == "1/5")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '0.5/4') OR (COALESCE(m.grade, s.grade) = '1/4') OR (COALESCE(m.grade, s.grade) = '1/5') OR (COALESCE(m.grade, s.grade) = 'D-') OR (COALESCE(m.grade, s.grade) = 'D')");
    else if (grade == "1.5/5")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '1.5/5')");
    else if (grade == "2/5")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '1.5/4') OR (COALESCE(m.grade, s.grade) = '2/5') OR (COALESCE(m.grade, s.grade) = 'D+') OR (COALESCE(m.grade, s.grade) = 'C-') OR (COALESCE(m.grade, s.grade) = 'C')");
    else if (grade == "2.5/5")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '2.5/5')");
    else if (grade == "3/5")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '2/4') OR (COALESCE(m.grade, s.grade) = '2.5/4') OR (COALESCE(m.grade, s.grade) = '3/5') OR (COALESCE(m.grade, s.grade) = 'C+') OR (COALESCE(m.grade, s.grade) = 'B-')");
    else if (grade == "3.5/5")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '3.5/5')");
    else if (grade == "4/5")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '3/4') OR (COALESCE(m.grade, s.grade) = '3.5/4') OR (COALESCE(m.grade, s.grade) = '4/5') OR (COALESCE(m.grade, s.grade) = 'B') OR (COALESCE(m.grade, s.grade) = 'B+') OR (COALESCE(m.grade, s.grade) = 'A-')");
    else if (grade == "4.5/5")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '4.5/5')");
    else if (grade == "5/5")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '4/4') OR (COALESCE(m.grade, s.grade) = '5/5') OR (COALESCE(m.grade, s.grade) = 'A') OR (COALESCE(m.grade, s.grade) = 'A+')");
    else if (grade == "F")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '0/4') OR (COALESCE(m.grade, s.grade) = '0.5/4') OR (COALESCE(m.grade, s.grade) = '0/5') OR (COALESCE(m.grade, s.grade) = '0.5/5') OR (COALESCE(m.grade, s.grade) = 'F')");
    else if (grade == "D-")
      filterClauses.push("(COALESCE(m.grade, s.grade) = 'D-')");
    else if (grade == "D")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '1/4') OR (COALESCE(m.grade, s.grade) = '1.5/4') OR (COALESCE(m.grade, s.grade) = '1/5') OR (COALESCE(m.grade, s.grade) = '1.5/5') OR (COALESCE(m.grade, s.grade) = 'D')");
    else if (grade == "D+")
      filterClauses.push("(COALESCE(m.grade, s.grade) = 'D+')");
    else if (grade == "C-")
      filterClauses.push("(COALESCE(m.grade, s.grade) = 'C-')");
    else if (grade == "C")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '2/4') OR (COALESCE(m.grade, s.grade) = '2/5') OR (COALESCE(m.grade, s.grade) = '2.5/5') OR (COALESCE(m.grade, s.grade) = '3/5') OR (COALESCE(m.grade, s.grade) = 'C')");
    else if (grade == "C+")
      filterClauses.push("(COALESCE(m.grade, s.grade) = 'C+')");
    else if (grade == "B-")
      filterClauses.push("(COALESCE(m.grade, s.grade) = 'B-')");
    else if (grade == "B")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '2.5/4') OR (COALESCE(m.grade, s.grade) = '3/4') OR (COALESCE(m.grade, s.grade) = '3.5/5') OR (COALESCE(m.grade, s.grade) = '4/5') OR (COALESCE(m.grade, s.grade) = 'B')");
    else if (grade == "B+")
      filterClauses.push("(COALESCE(m.grade, s.grade) = 'B+')");
    else if (grade == "A-")
      filterClauses.push("(COALESCE(m.grade, s.grade) = 'A-')");
    else if (grade == "A")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '3.5/4') OR (COALESCE(m.grade, s.grade) = '4/4') OR (COALESCE(m.grade, s.grade) = '4.5/5') OR (COALESCE(m.grade, s.grade) = '5/5') OR (COALESCE(m.grade, s.grade) = 'A')");
    else if (grade == "A+")
      filterClauses.push("(COALESCE(m.grade, s.grade) = 'A+')");
    else if (grade == "1/10")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '0/4') OR (COALESCE(m.grade, s.grade) = '0/5') OR (COALESCE(m.grade, s.grade) = '0.5/5') OR (COALESCE(m.grade, s.grade) = 'F')");
    else if (grade == "2/10")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '0.5/4') OR (COALESCE(m.grade, s.grade) = '1/5')");
    else if (grade == "3/10")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '1/4') OR (COALESCE(m.grade, s.grade) = '1.5/5') OR (COALESCE(m.grade, s.grade) = 'D-') OR (COALESCE(m.grade, s.grade) = 'D')");
    else if (grade == "4/10")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '1.5/4') OR (COALESCE(m.grade, s.grade) = '2/5') OR (COALESCE(m.grade, s.grade) = 'D+')");
    else if (grade == "5/10")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '2/4') OR (COALESCE(m.grade, s.grade) = '2.5/5') OR (COALESCE(m.grade, s.grade) = 'C-') OR (COALESCE(m.grade, s.grade) = 'C')");
    else if (grade == "6/10")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '3/5') OR (COALESCE(m.grade, s.grade) = 'C+')");
    else if (grade == "7/10")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '2.5/4') OR (COALESCE(m.grade, s.grade) = '3.5/5') OR (COALESCE(m.grade, s.grade) = 'B-') OR (COALESCE(m.grade, s.grade) = 'B')");
    else if (grade == "8/10")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '3/4') OR (COALESCE(m.grade, s.grade) = '4/5') OR (COALESCE(m.grade, s.grade) = 'B+')");
    else if (grade == "9/10")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '3.5/4') OR (COALESCE(m.grade, s.grade) = '4.5/5') OR (COALESCE(m.grade, s.grade) = 'A-') OR (COALESCE(m.grade, s.grade) = 'A')");
    else if (grade == "10/10")
      filterClauses.push("(COALESCE(m.grade, s.grade) = '4/4') OR (COALESCE(m.grade, s.grade) = '5/5') OR (COALESCE(m.grade, s.grade) = 'A+')");
  }

  const whereClause = filterClauses.length > 0 ? `WHERE ${filterClauses.join(" AND ")}` : "";

  const sql = 
    `
      SELECT COUNT(*)
      FROM media m
      LEFT JOIN seasons s ON m.id = s.show_id
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
      SELECT id, title, s.start_date
      FROM media m
      LEFT JOIN seasons s ON m.id = s.show_id
      WHERE type = 'show' AND completed = false AND s.season = 1
      ORDER BY s.start_date DESC;
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
  query("UPDATE seasons SET date_added = NULL WHERE date_added <= CURRENT_TIMESTAMP - INTERVAL '1 MONTH'");
  
  const sql = 
    `
      SELECT m.id, m.title, m.grade, m.release_date, m.rating, m.poster, m.runtime, m.completed, m.type, s.season, s.grade AS grade_tv, s.episodes, s.runtime AS runtime_tv, s.start_date, s.end_date, directors, directors_tv, cast_members, cast_members_tv, writers, writers_tv
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
      WHERE (m.date_added IS NOT NULL AND m.date_added > CURRENT_TIMESTAMP - INTERVAL '1 MONTH') OR (s.date_added IS NOT NULL AND s.date_added > CURRENT_TIMESTAMP - INTERVAL '1 MONTH')
      ORDER BY COALESCE(m.date_added, s.date_added) DESC;
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

export const show = (req, res) => {
  const sql = 
    `
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
      WHERE id = $1;
    `;

  query(sql, [req.params.id])
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

export const create = async (req, res) => {
  const media = req.body;
  const getIdsByRole = (role) => media.castAndCrew?.filter(person => person[role]).map(person => person.id) || [];
  const directors = getIdsByRole("director");
  const writers = getIdsByRole("writer");
  const castMembers = getIdsByRole("cast");

  try {
    let result;

    if (media.type === "movie")
      result = await createMovie(media, { directors, writers, castMembers });
    else if (media.type === "show") {
      if (media.id === "na")
        result = await createNewShow(media, { directors, writers, castMembers });
      else
        result = await addSeasonToShow(media, { directors, writers, castMembers });
    } 
    else
      return res.status(400).json({ error: "Invalid media type specified." });
    
    res.location(`/media/${result.id}`);
    backupDatabase();
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
  addIdsToSet(og.directors_tv, 'director_id');
  addIdsToSet(og.writers_tv, 'writer_id');
  addIdsToSet(og.cast_members_tv, 'actor_id');
  const getIdsByRole = (role) => media.castAndCrew?.filter(person => person[role]).map(person => person.id) || [];
  const directors = getIdsByRole("director");
  const writers = getIdsByRole("writer");
  const castMembers = getIdsByRole("cast");

  try {
    await client.query("BEGIN");
    
    if (media.type === "movie")
      await updateMovie(media, og, { directors, writers, castMembers });
    else if (media.type === "show")
      await updateShow(media, og, { directors, writers, castMembers });
    else
      return res.status(400).json({ error: "Invalid media type specified." });
    
    await deleteOrphanedPeople(Array.from(originalPersonIds));
    await client.query("COMMIT");
    backupDatabase();
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
        SELECT COALESCE(MAX(id), 0) + 1, $1, $2, $3, $4, $5, $6, 'movie', $7
        FROM media
        RETURNING id
      ),
      insert_directors AS (
        INSERT INTO media_directors (ordering, media_id, director_id)
        SELECT row_number() OVER (), (SELECT id FROM new_media), director_id
        FROM unnest($8::int[]) AS director_id
      ),
      insert_cast AS (
        INSERT INTO media_cast (ordering, media_id, actor_id)
        SELECT row_number() OVER (), (SELECT id FROM new_media), actor_id
        FROM unnest($9::int[]) AS actor_id
      ),
      insert_writers AS (
        INSERT INTO media_writers (ordering, media_id, writer_id)
        SELECT row_number() OVER (), (SELECT id FROM new_media), writer_id
        FROM unnest($10::int[]) AS writer_id
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
    new Date(),
    directors, 
    castMembers, 
    writers
  ];

  const result = await query(sql, params);
  return { id: result.rows[0].id };
}

async function createNewShow(media, { directors, writers, castMembers }) {
  const sql = 
    `
      WITH new_media AS (
        INSERT INTO media (id, title, poster, rating, completed, type)
        SELECT COALESCE(MAX(id), 0) + 1, $1, $2, $3, $4, 'show'
        FROM media
        RETURNING id
      ),
      insert_season AS (
        INSERT INTO seasons (season, show_id, grade, episodes, runtime, start_date, end_date, date_added)
        VALUES (1, (SELECT id FROM new_media), $5, $6, $7, $8, $9, $10)
      ),
      insert_directors AS (
        INSERT INTO seasons_directors (ordering, show_id, season, director_id)
        SELECT row_number() OVER (), (SELECT id FROM new_media), 1, director_id
        FROM unnest($11::int[]) AS director_id
      ),
      insert_cast AS (
        INSERT INTO seasons_cast (ordering, season, show_id, actor_id)
        SELECT row_number() OVER (), 1, (SELECT id FROM new_media), actor_id
        FROM unnest($12::int[]) AS actor_id
      ),
      insert_writers AS (
        INSERT INTO seasons_writers (ordering, show_id, season, writer_id)
        SELECT row_number() OVER (), (SELECT id FROM new_media), 1, writer_id
        FROM unnest($13::int[]) AS writer_id
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
    media.runtime,
    media.start_date, 
    media.end_date,
    new Date(),
    directors, 
    castMembers, 
    writers
  ];
  
  const result = await query(sql, params);
  return { id: result.rows[0].id };
}

async function addSeasonToShow(media, { directors, writers, castMembers }) {
  let sql = ``;
  sql = `UPDATE media SET completed = $1 WHERE id = $2;`;
  await query(sql, [media.completed || false, media.id]);

  sql = 
    `
      WITH new_season_info AS (
        SELECT COALESCE(MAX(season), 0) + 1 AS season_num FROM seasons WHERE show_id = $1
      )
      INSERT INTO seasons (season, show_id, grade, episodes, runtime, start_date, end_date, date_added)
      SELECT season_num, $1, $2, $3, $4, $5, $6, $7 FROM new_season_info;
    `;

  await query(sql, [media.id, media.grade, media.episodes, media.runtime, media.start_date, media.end_date, new Date()]);

  sql = 
    `
      WITH new_season_info AS (
        SELECT COALESCE(MAX(season), 0) AS season_num FROM seasons WHERE show_id = $1
      )
      INSERT INTO seasons_directors (ordering, show_id, season, director_id)
      SELECT row_number() OVER (), $1, (SELECT season_num FROM new_season_info), director_id
      FROM unnest($2::int[]) AS director_id;
    `;

  await query(sql, [media.id, directors]);

  sql = 
    `
      WITH new_season_info AS (
        SELECT COALESCE(MAX(season), 0) AS season_num FROM seasons WHERE show_id = $1
      )
      INSERT INTO seasons_cast (ordering, season, show_id, actor_id)
      SELECT row_number() OVER (), (SELECT season_num FROM new_season_info), $1, actor_id
      FROM unnest($2::int[]) AS actor_id;
    `;

  await query(sql, [media.id, castMembers]);

  sql = 
    `
      WITH new_season_info AS (
        SELECT COALESCE(MAX(season), 0) AS season_num FROM seasons WHERE show_id = $1
      )
      INSERT INTO seasons_writers (ordering, show_id, season, writer_id)
      SELECT row_number() OVER (), $1, (SELECT season_num FROM new_season_info), writer_id
      FROM unnest($2::int[]) AS writer_id;
    `;

  await query(sql, [media.id, writers]);
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

    sql = 
      `
        INSERT INTO media_directors (ordering, media_id, director_id)
        SELECT row_number() OVER (), $1, director_id
        FROM unnest($2::int[]) AS director_id;
      `;

    await query(sql, [media.id, directors]);
  }

  if (!og.writers || !writers || og.writers.length != writers.length || !(writers.every(w => og.writers.some(ogw => ogw["writer_id"] === w)))) {
    sql = `DELETE FROM media_writers WHERE media_id = $1;`;
    await query(sql, [media.id]);

    sql = 
      `
        INSERT INTO media_writers (ordering, media_id, writer_id)
        SELECT row_number() OVER (), $1, writer_id
        FROM unnest($2::int[]) AS writer_id;
      `;

    await query(sql, [media.id, writers]);
  }

  if (!og.cast_members || !castMembers || og.cast_members.length != castMembers.length || !(castMembers.every(cm => og.cast_members.some(ogcm => ogcm["actor_id"] === cm)))) {
    sql = `DELETE FROM media_cast WHERE media_id = $1;`;
    await query(sql, [media.id]);

    sql = 
      `
        INSERT INTO media_cast (ordering, media_id, actor_id)
        SELECT row_number() OVER (), $1, actor_id
        FROM unnest($2::int[]) AS actor_id;
      `;

    await query(sql, [media.id, castMembers]);
  }
}

async function updateShow(media, og, { directors, writers, castMembers }) {
  let sql = ``;

  if (media.title != og.title) {
    sql = `UPDATE media SET title = $1 WHERE id = $2;`;
    await query(sql, [media.title, media.id]);
  }

  if (media.poster != og.poster) {
    sql = `UPDATE media SET poster = $1 WHERE id = $2;`;
    await query(sql, [media.poster, media.id]);
  }

  if (media.completed != og.completed) {
    sql = `UPDATE media SET completed = $1 WHERE id = $2;`;
    await query(sql, [media.completed || false, media.id]);
  }

  if (media.rating != og.rating) {
    sql = `UPDATE media SET rating = $1 WHERE id = $2;`;
    await query(sql, [media.rating, media.id]);
  }

  if (media.start_date != new Date(og.start_date).toISOString().split("T")[0]) {
    sql = `UPDATE seasons SET start_date = $1 WHERE show_id = $2 AND season = $3;`;
    await query(sql, [media.start_date, media.id, media.season]);
  }

  if (media.end_date != new Date(og.end_date).toISOString().split("T")[0]) {
    sql = `UPDATE seasons SET end_date = $1 WHERE show_id = $2 AND season = $3;`;
    await query(sql, [media.end_date, media.id, media.season]);
  }

  if (media.grade != og.grade) {
    sql = `UPDATE seasons SET grade = $1 WHERE show_id = $2 AND season = $3;`;
    await query(sql, [media.grade, media.id, media.season]);
  }

  if (media.episodes != og.episodes) {
    sql = `UPDATE seasons SET episode = $1 WHERE show_id = $2 AND season = $3;`;
    await query(sql, [media.episodes, media.id, media.season]);
  }

  if (media.runtime != og.runtime) {
    sql = `UPDATE seasons SET runtime = $1 WHERE show_id = $2 AND season = $3;`;
    await query(sql, [media.runtime, media.id, media.season]);
  }

  if (!og.directors_tv || !directors || og.directors_tv.length != directors.length || !(directors.every(d => og.directors_tv.some(ogd => ogd["director_id"] === d)))) {
    sql = `DELETE FROM seasons_directors WHERE show_id = $1 AND season = $2;`;
    await query(sql, [media.id, media.season]);
    
    sql = 
      `
        INSERT INTO seasons_directors (ordering, season, show_id, director_id)
        SELECT row_number() OVER (), $1, $2, director_id
        FROM unnest($3::int[]) AS director_id;
      `;

    await query(sql, [media.season, media.id, directors]);
  }

  if (!og.writers_tv || !writers || og.writers_tv.length != writers.length || !(writers.every(w => og.writers_tv.some(ogw => ogw["writer_id"] === w)))) {
    sql = `DELETE FROM seasons_writers WHERE show_id = $1 AND season = $2;`;
    await query(sql, [media.id, media.season]);

    sql = 
      `
        INSERT INTO seasons_writers (ordering, season, show_id, writer_id)
        SELECT row_number() OVER (), $1, $2, writer_id
        FROM unnest($3::int[]) AS writer_id;
      `;

    await query(sql, [media.season, media.id, writers]);
  }

  if (!og.cast_members_tv || !castMembers || og.cast_members_tv.length != castMembers.length || !(castMembers.every(cm => og.cast_members_tv.some(ogcm => ogcm["actor_id"] === cm)))) {
    sql = `DELETE FROM seasons_cast WHERE show_id = $1 AND season = $2;`;
    await query(sql, [media.id, media.season]);

    sql = 
      `
        INSERT INTO seasons_cast (ordering, season, show_id, actor_id)
        SELECT row_number() OVER (), $1, $2, actor_id
        FROM unnest($3::int[]) AS actor_id;
      `;

    await query(sql, [media.season, media.id, castMembers]);
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
    const idsToShift = peopleToUpdate.rows.map(p => p.id);

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
