import { query } from "../config/pgClient.js";
import { execSync, spawn } from "node:child_process";
import fs from "node:fs";import path from "node:path";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const backupDatabase = () => {
  const rootPath = path.resolve(__dirname, "../../../"); 
  const backupPath = path.join(rootPath, "database.sql");
  const pgDumpPath = path.join(rootPath, "sql_binaries/bin/pg_dump.exe");

  if (!fs.existsSync(pgDumpPath)) {
    console.error(`Binary not found at: ${pgDumpPath}`);
    return;
  }

  const fileStream = fs.createWriteStream(backupPath);

  const child = spawn(pgDumpPath, ["-U", "postgres", "--no-owner", "--no-privileges", "--clean", "--if-exists","mainstream"], {
    shell: true,
    env: { ...process.env, PGPASSWORD: process.env.DB_PASSWORD }
  });

  child.stdout.pipe(fileStream);

  child.stderr.on("data", (data) => {
    console.error(`PG_DUMP ERROR: ${data.toString()}`);
  });

  child.on("close", (code) => {
    if (code === 0) 
      console.log("SUCCESS: Database synced to root.");
    else 
      console.error(`PROCESS EXITED with code: ${code}`);
  });

  try {
    console.log("--- Starting Git Backup ---");
    execSync("git add database.sql");
    console.log("Update at ${new Date().toLocaleString()}");
    execSync(`git commit -m "Update at ${new Date().toLocaleString()}"`);
    execSync("git push origin main");
    console.log("--- Git Backup Successful ---");
  } 
  catch (error) {
      console.log("Git Backup Note: No changes detected or push failed.");
  }
};

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

  const whereClause = filterClauses.length > 0 ? `WHERE ${filterClauses.join(" AND ")}` : "";
  let orderByClause = "";
  const sanitizedSortOrder = ['ASC', 'DESC'].includes(sortOrder.toUpperCase()) ? sortOrder.toUpperCase() : "ASC";

  switch (sortBy) {
    case "name":
      orderByClause = `ORDER BY name ${sanitizedSortOrder}`;
      break;
    case "birth_date":
      orderByClause = `ORDER BY birth_date ${sanitizedSortOrder} NULLS LAST`;
      break;
    case "death_date":
      orderByClause = `ORDER BY death_date ${sanitizedSortOrder} NULLS LAST`;
      break;
    default:
      orderByClause = `ORDER BY birth_date ASC NULLS LAST`;
  }

  const sql = 
    `
      WITH DirectorCredits AS (
        SELECT
          md.director_id,
          json_agg(json_build_object('id', m.id, 'title', m.title, 'release_date', m.release_date)) AS credited_as_director
        FROM media_directors md
        JOIN media m ON md.media_id = m.id
        GROUP BY md.director_id
      ), DirectorTVCredits AS (
        SELECT
          sd.director_id,
          json_agg(json_build_object('id', m.id, 'title', m.title, 'start_date', s.start_date, 'end_date', s.end_date)) AS credited_as_director_tv
        FROM seasons_directors sd
        JOIN seasons s ON s.season = sd.season AND s.show_id = sd.show_id
        JOIN media m ON m.id = s.show_id
        GROUP BY sd.director_id
      ), WriterCredits AS (
        SELECT
          mw.writer_id,
          json_agg(json_build_object('id', m.id, 'title', m.title, 'release_date', m.release_date)) AS credited_as_writer
        FROM media_writers mw
        JOIN media m ON mw.media_id = m.id
        GROUP BY mw.writer_id
      ), WriterTVCredits AS (
        SELECT
          sw.writer_id,
          json_agg(json_build_object('id', m.id, 'title', m.title, 'start_date', s.start_date, 'end_date', s.end_date)) AS credited_as_writer_tv
        FROM seasons_writers sw
        JOIN seasons s ON s.season = sw.season AND s.show_id = sw.show_id
        JOIN media m ON m.id = s.show_id
        GROUP BY sw.writer_id
      ), CastCredits AS (
        SELECT
          mcm.actor_id,
          json_agg(json_build_object('id', m.id, 'title', m.title, 'release_date', m.release_date)) AS credited_as_cast_member
        FROM media_cast mcm
        JOIN media m ON mcm.media_id = m.id
        GROUP BY mcm.actor_id
      ), CastTVCredits AS (
        SELECT
          scm.actor_id,
          json_agg(json_build_object('id', m.id, 'title', m.title, 'start_date', s.start_date, 'end_date', s.end_date)) AS credited_as_cast_member_tv
        FROM seasons_cast scm
        JOIN seasons s ON s.season = scm.season AND s.show_id = scm.show_id
        JOIN media m ON m.id = s.show_id
        GROUP BY scm.actor_id
      ), NumberedRecords AS (
        SELECT 
          ROW_NUMBER() OVER (${orderByClause}) AS RowNum,
          p.id, 
          p.name, 
          p.birth_date, 
          p.death_date,
          d.credited_as_director,
          dtv.credited_as_director_tv,
          w.credited_as_writer,
          wtv.credited_as_writer_tv,
          c.credited_as_cast_member,
          ctv.credited_as_cast_member_tv
        FROM people p
        LEFT JOIN DirectorCredits d ON p.id = d.director_id
        LEFT JOIN DirectorTVCredits dtv ON p.id = dtv.director_id
        LEFT JOIN WriterCredits w ON p.id = w.writer_id
        LEFT JOIN WriterTVCredits wtv ON p.id = wtv.writer_id
        LEFT JOIN CastCredits c ON p.id = c.actor_id
        LEFT JOIN CastTVCredits ctv ON p.id = ctv.actor_id
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

  if (noDeathDate === "true")
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

  if (req.query.searchTerm != undefined && req.query.searchTerm != "") {
    searchSystem = 
      `
        WITH DirectorCredits AS (
          SELECT
            md.director_id,
            json_agg(json_build_object('id', m.id, 'title', m.title, 'release_date', m.release_date)) AS credited_as_director
          FROM media_directors md
          JOIN media m ON md.media_id = m.id
          GROUP BY md.director_id
        ), DirectorTVCredits AS (
          SELECT
            sd.director_id,
            json_agg(json_build_object('id', m.id, 'title', m.title, 'start_date', s.start_date, 'end_date', s.end_date)) AS credited_as_director_tv
          FROM seasons_directors sd
          JOIN seasons s ON s.season = sd.season AND s.show_id = sd.show_id
          JOIN media m ON m.id = s.show_id
          GROUP BY sd.director_id
        ), WriterCredits AS (
          SELECT
            mw.writer_id,
            json_agg(json_build_object('id', m.id, 'title', m.title, 'release_date', m.release_date)) AS credited_as_writer
          FROM media_writers mw
          JOIN media m ON mw.media_id = m.id
          GROUP BY mw.writer_id
        ), WriterTVCredits AS (
          SELECT
            sw.writer_id,
            json_agg(json_build_object('id', m.id, 'title', m.title, 'start_date', s.start_date, 'end_date', s.end_date)) AS credited_as_writer_tv
          FROM seasons_writers sw
          JOIN seasons s ON s.season = sw.season AND s.show_id = sw.show_id
          JOIN media m ON m.id = s.show_id
          GROUP BY sw.writer_id
        ), CastCredits AS (
          SELECT
            mcm.actor_id,
            json_agg(json_build_object('id', m.id, 'title', m.title, 'release_date', m.release_date)) AS credited_as_cast_member
          FROM media_cast mcm
          JOIN media m ON mcm.media_id = m.id
          GROUP BY mcm.actor_id
        ), CastTVCredits AS (
          SELECT
            scm.actor_id,
            json_agg(json_build_object('id', m.id, 'title', m.title, 'start_date', s.start_date, 'end_date', s.end_date)) AS credited_as_cast_member_tv
          FROM seasons_cast scm
          JOIN seasons s ON s.season = scm.season AND s.show_id = scm.show_id
          JOIN media m ON m.id = s.show_id
          GROUP BY scm.actor_id
        ), Records AS (
            SELECT
              p.id, 
              p.name, 
              p.birth_date, 
              p.death_date,
              d.credited_as_director,
              dtv.credited_as_director_tv,
              w.credited_as_writer,
              wtv.credited_as_writer_tv,
              c.credited_as_cast_member,
              ctv.credited_as_cast_member_tv
            FROM people p
            LEFT JOIN DirectorCredits d ON p.id = d.director_id
            LEFT JOIN DirectorTVCredits dtv ON p.id = dtv.director_id
            LEFT JOIN WriterCredits w ON p.id = w.writer_id
            LEFT JOIN WriterTVCredits wtv ON p.id = wtv.writer_id
            LEFT JOIN CastCredits c ON p.id = c.actor_id
            LEFT JOIN CastTVCredits ctv ON p.id = ctv.actor_id
            WHERE regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(name, '[ŽŹŻ]+', 'Z'), '[žźż]+', 'z'), '[ŸŶÝ]+', 'Y'), '[ÿŷý]+', 'y'), 'Ŵ', 'W'), 'ŵ', 'w'), '[ŪÚÙÜÛŲŮŰŨǓ]+', 'U'), '[ūúùüûųůűũǔ]+', 'u'), '[ȚŤÞ]+', 'T'), '[țťþ]+', 't'), '[ŚŠẞŞȘ]+', 'S'), '[ßśšşș]+', 's'), 'Ř', 'R'), 'ř', 'r'), '[ÕŌØŒÓÒÖÔŐǑ]+', 'O'), '[õōøœóòöôőǒ]+', 'o'), '[ŃÑŇŅ]+', 'N'), '[ńñňņ]+', 'n'), '[ŁĽĻ]+', 'L'), '[łľļ]+', 'l'), 'Ķ', 'K'), 'ķ', 'k'), '[ÌĮĪÍÏÎİĨǏ]+', 'I'), '[ìįīíïîıĩǐ]+', 'i'), 'Ħ', 'H'), 'ħ', 'h'), '[ĞĠ]+', 'G'), '[ğġ]+', 'g'), '[ÈÉÊËĒĖĘĚẼ]+', 'E'), '[èéêëēėęěẽ]+', 'e'), '[ĎÐ]+', 'D'), '[ďð]+', 'd'), '[ÇĆČĊ]+', 'C'), '[çćčċ]+', 'c'), '[ÀÁÂÄÆÃÅĀǍĂĄ]+', 'A'), '[àáâäæãåāǎăą]+', 'a') ILIKE $1 OR regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(name, '[ŽŹŻ]+', 'Z'), '[žźż]+', 'z'), '[ŸŶÝ]+', 'Y'), '[ÿŷý]+', 'y'), 'Ŵ', 'W'), 'ŵ', 'w'), '[ŪÚÙÜÛŲŮŰŨǓ]+', 'U'), '[ūúùüûųůűũǔ]+', 'u'), '[ȚŤÞ]+', 'T'), '[țťþ]+', 't'), '[ŚŠẞŞȘ]+', 'S'), '[ßśšşș]+', 's'), 'Ř', 'R'), 'ř', 'r'), '[ÕŌØŒÓÒÖÔŐǑ]+', 'O'), '[õōøœóòöôőǒ]+', 'o'), '[ŃÑŇŅ]+', 'N'), '[ńñňņ]+', 'n'), '[ŁĽĻ]+', 'L'), '[łľļ]+', 'l'), 'Ķ', 'K'), 'ķ', 'k'), '[ÌĮĪÍÏÎİĨǏ]+', 'I'), '[ìįīíïîıĩǐ]+', 'i'), 'Ħ', 'H'), 'ħ', 'h'), '[ĞĠ]+', 'G'), '[ğġ]+', 'g'), '[ÈÉÊËĒĖĘĚẼ]+', 'E'), '[èéêëēėęěẽ]+', 'e'), '[ĎÐ]+', 'D'), '[ďð]+', 'd'), '[ÇĆČĊ]+', 'C'), '[çćčċ]+', 'c'), '[ÀÁÂÄÆÃÅĀǍĂĄ]+', 'A'), '[àáâäæãåāǎăą]+', 'a') ILIKE $2 OR name ILIKE $1 OR name ILIKE $2 ORDER BY birth_date ASC, name ASC
        )
        SELECT * FROM Records;
      `;

    params = [
      `${req.query.searchTerm}%`,
      `% ${req.query.searchTerm}%`
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

export const show = (req, res) => {
  const sql = 
    `
      SELECT id, name, birth_date, death_date
      FROM people
      WHERE id = $1;
    `;

  query(sql, [req.params.id])
    .then(results => {
      if (results.rowCount > 0)
        res.json(results.rows[0]);
      else
        res.status(404).json({ error: `Person not found for id ${req.params.id}.` });
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
    backupDatabase();
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
    backupDatabase();
    res.status(201).json({ message: "Person successfully updated." });
  })
  .catch((error) => {
    res.status(500).json({ error: `Error: ${ error }` });
  })
}