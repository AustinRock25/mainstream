const pgClient = require("../config/pgClient");

const index = (req, res) => {
  let searchSystem = "";
  let params = [];

  if (req.query.searchTerm != undefined && req.query.searchTerm != "") {
    searchSystem = "WHERE regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(name, '[ŽŹŻ]+', 'Z'), '[žźż]+', 'z'), '[ŸŶÝ]+', 'Y'), '[ÿŷý]+', 'y'), 'Ŵ', 'W'), 'ŵ', 'w'), '[ŪÚÙÜÛŲŮŰŨǓ]+', 'U'), '[ūúùüûųůűũǔ]+', 'u'), '[ȚŤÞ]+', 'T'), '[țťþ]+', 't'), '[ŚŠẞŞȘ]+', 'S'), '[ßśšşș]+', 's'), 'Ř', 'R'), 'ř', 'r'), '[ÕŌØŒÓÒÖÔŐǑ]+', 'O'), '[õōøœóòöôőǒ]+', 'o'), '[ŃÑŇŅ]+', 'N'), '[ńñňņ]+', 'n'), '[ŁĽĻ]+', 'L'), '[łľļ]+', 'l'), 'Ķ', 'K'), 'ķ', 'k'), '[ÌĮĪÍÏÎİĨǏ]+', 'I'), '[ìįīíïîıĩǐ]+', 'i'), 'Ħ', 'H'), 'ħ', 'h'), '[ĞĠ]+', 'G'), '[ğġ]+', 'g'), '[ÈÉÊËĒĖĘĚẼ]+', 'E'), '[èéêëēėęěẽ]+', 'e'), '[ĎÐ]+', 'D'), '[ďð]+', 'd'), '[ÇĆČĊ]+', 'C'), '[çćčċ]+', 'c'), '[ÀÁÂÄÆÃÅĀǍĂĄ]+', 'A'), '[àáâäæãåāǎăą]+', 'a') ILIKE $3 OR regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(name, '[ŽŹŻ]+', 'Z'), '[žźż]+', 'z'), '[ŸŶÝ]+', 'Y'), '[ÿŷý]+', 'y'), 'Ŵ', 'W'), 'ŵ', 'w'), '[ŪÚÙÜÛŲŮŰŨǓ]+', 'U'), '[ūúùüûųůűũǔ]+', 'u'), '[ȚŤÞ]+', 'T'), '[țťþ]+', 't'), '[ŚŠẞŞȘ]+', 'S'), '[ßśšşș]+', 's'), 'Ř', 'R'), 'ř', 'r'), '[ÕŌØŒÓÒÖÔŐǑ]+', 'O'), '[õōøœóòöôőǒ]+', 'o'), '[ŃÑŇŅ]+', 'N'), '[ńñňņ]+', 'n'), '[ŁĽĻ]+', 'L'), '[łľļ]+', 'l'), 'Ķ', 'K'), 'ķ', 'k'), '[ÌĮĪÍÏÎİĨǏ]+', 'I'), '[ìįīíïîıĩǐ]+', 'i'), 'Ħ', 'H'), 'ħ', 'h'), '[ĞĠ]+', 'G'), '[ğġ]+', 'g'), '[ÈÉÊËĒĖĘĚẼ]+', 'E'), '[èéêëēėęěẽ]+', 'e'), '[ĎÐ]+', 'D'), '[ďð]+', 'd'), '[ÇĆČĊ]+', 'C'), '[çćčċ]+', 'c'), '[ÀÁÂÄÆÃÅĀǍĂĄ]+', 'A'), '[àáâäæãåāǎăą]+', 'a') ILIKE $4 OR name ILIKE $3 OR name ILIKE $4";
    params = [
      req.query.beginRecord,
      req.query.endRecord,
      `${req.query.searchTerm}%`,
      `% ${req.query.searchTerm}%`
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
      SELECT ROW_NUMBER() OVER (ORDER BY birth_year ASC, name ASC) AS RowNum, id, name, birth_year, death_year
      FROM people
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
    searchSystem = "WHERE regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(name, '[ŽŹŻ]+', 'Z'), '[žźż]+', 'z'), '[ŸŶÝ]+', 'Y'), '[ÿŷý]+', 'y'), 'Ŵ', 'W'), 'ŵ', 'w'), '[ŪÚÙÜÛŲŮŰŨǓ]+', 'U'), '[ūúùüûųůűũǔ]+', 'u'), '[ȚŤÞ]+', 'T'), '[țťþ]+', 't'), '[ŚŠẞŞȘ]+', 'S'), '[ßśšşș]+', 's'), 'Ř', 'R'), 'ř', 'r'), '[ÕŌØŒÓÒÖÔŐǑ]+', 'O'), '[õōøœóòöôőǒ]+', 'o'), '[ŃÑŇŅ]+', 'N'), '[ńñňņ]+', 'n'), '[ŁĽĻ]+', 'L'), '[łľļ]+', 'l'), 'Ķ', 'K'), 'ķ', 'k'), '[ÌĮĪÍÏÎİĨǏ]+', 'I'), '[ìįīíïîıĩǐ]+', 'i'), 'Ħ', 'H'), 'ħ', 'h'), '[ĞĠ]+', 'G'), '[ğġ]+', 'g'), '[ÈÉÊËĒĖĘĚẼ]+', 'E'), '[èéêëēėęěẽ]+', 'e'), '[ĎÐ]+', 'D'), '[ďð]+', 'd'), '[ÇĆČĊ]+', 'C'), '[çćčċ]+', 'c'), '[ÀÁÂÄÆÃÅĀǍĂĄ]+', 'A'), '[àáâäæãåāǎăą]+', 'a') ILIKE $1 OR regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(name, '[ŽŹŻ]+', 'Z'), '[žźż]+', 'z'), '[ŸŶÝ]+', 'Y'), '[ÿŷý]+', 'y'), 'Ŵ', 'W'), 'ŵ', 'w'), '[ŪÚÙÜÛŲŮŰŨǓ]+', 'U'), '[ūúùüûųůűũǔ]+', 'u'), '[ȚŤÞ]+', 'T'), '[țťþ]+', 't'), '[ŚŠẞŞȘ]+', 'S'), '[ßśšşș]+', 's'), 'Ř', 'R'), 'ř', 'r'), '[ÕŌØŒÓÒÖÔŐǑ]+', 'O'), '[õōøœóòöôőǒ]+', 'o'), '[ŃÑŇŅ]+', 'N'), '[ńñňņ]+', 'n'), '[ŁĽĻ]+', 'L'), '[łľļ]+', 'l'), 'Ķ', 'K'), 'ķ', 'k'), '[ÌĮĪÍÏÎİĨǏ]+', 'I'), '[ìįīíïîıĩǐ]+', 'i'), 'Ħ', 'H'), 'ħ', 'h'), '[ĞĠ]+', 'G'), '[ğġ]+', 'g'), '[ÈÉÊËĒĖĘĚẼ]+', 'E'), '[èéêëēėęěẽ]+', 'e'), '[ĎÐ]+', 'D'), '[ďð]+', 'd'), '[ÇĆČĊ]+', 'C'), '[çćčċ]+', 'c'), '[ÀÁÂÄÆÃÅĀǍĂĄ]+', 'A'), '[àáâäæãåāǎăą]+', 'a') ILIKE $2 OR name ILIKE $1 OR name ILIKE $2";
    params = [
      `${req.query.searchTerm}%`,
      `% ${req.query.searchTerm}%`
    ];
  }

  const sql = `
    SELECT COUNT(*) 
    FROM people
    ${searchSystem}`;

  pgClient.query(sql, params)
  .then(results => {
    res.status(200).json(results.rows);
  })
  .catch((error) => {
    res.status(500).json({ error: `Error: ${error}.` });
  });
}

const indexSelect = (req, res) => {
  let searchSystem = "";
  let params = [];

  if (req.query.searchTerm != undefined && req.query.searchTerm != "") {
    searchSystem = "SELECT id, name, birth_year, death_year FROM people WHERE regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(name, '[ŽŹŻ]+', 'Z'), '[žźż]+', 'z'), '[ŸŶÝ]+', 'Y'), '[ÿŷý]+', 'y'), 'Ŵ', 'W'), 'ŵ', 'w'), '[ŪÚÙÜÛŲŮŰŨǓ]+', 'U'), '[ūúùüûųůűũǔ]+', 'u'), '[ȚŤÞ]+', 'T'), '[țťþ]+', 't'), '[ŚŠẞŞȘ]+', 'S'), '[ßśšşș]+', 's'), 'Ř', 'R'), 'ř', 'r'), '[ÕŌØŒÓÒÖÔŐǑ]+', 'O'), '[õōøœóòöôőǒ]+', 'o'), '[ŃÑŇŅ]+', 'N'), '[ńñňņ]+', 'n'), '[ŁĽĻ]+', 'L'), '[łľļ]+', 'l'), 'Ķ', 'K'), 'ķ', 'k'), '[ÌĮĪÍÏÎİĨǏ]+', 'I'), '[ìįīíïîıĩǐ]+', 'i'), 'Ħ', 'H'), 'ħ', 'h'), '[ĞĠ]+', 'G'), '[ğġ]+', 'g'), '[ÈÉÊËĒĖĘĚẼ]+', 'E'), '[èéêëēėęěẽ]+', 'e'), '[ĎÐ]+', 'D'), '[ďð]+', 'd'), '[ÇĆČĊ]+', 'C'), '[çćčċ]+', 'c'), '[ÀÁÂÄÆÃÅĀǍĂĄ]+', 'A'), '[àáâäæãåāǎăą]+', 'a') ILIKE $1 OR regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(REPLACE(REPLACE(regexp_replace(regexp_replace(regexp_replace(regexp_replace(name, '[ŽŹŻ]+', 'Z'), '[žźż]+', 'z'), '[ŸŶÝ]+', 'Y'), '[ÿŷý]+', 'y'), 'Ŵ', 'W'), 'ŵ', 'w'), '[ŪÚÙÜÛŲŮŰŨǓ]+', 'U'), '[ūúùüûųůűũǔ]+', 'u'), '[ȚŤÞ]+', 'T'), '[țťþ]+', 't'), '[ŚŠẞŞȘ]+', 'S'), '[ßśšşș]+', 's'), 'Ř', 'R'), 'ř', 'r'), '[ÕŌØŒÓÒÖÔŐǑ]+', 'O'), '[õōøœóòöôőǒ]+', 'o'), '[ŃÑŇŅ]+', 'N'), '[ńñňņ]+', 'n'), '[ŁĽĻ]+', 'L'), '[łľļ]+', 'l'), 'Ķ', 'K'), 'ķ', 'k'), '[ÌĮĪÍÏÎİĨǏ]+', 'I'), '[ìįīíïîıĩǐ]+', 'i'), 'Ħ', 'H'), 'ħ', 'h'), '[ĞĠ]+', 'G'), '[ğġ]+', 'g'), '[ÈÉÊËĒĖĘĚẼ]+', 'E'), '[èéêëēėęěẽ]+', 'e'), '[ĎÐ]+', 'D'), '[ďð]+', 'd'), '[ÇĆČĊ]+', 'C'), '[çćčċ]+', 'c'), '[ÀÁÂÄÆÃÅĀǍĂĄ]+', 'A'), '[àáâäæãåāǎăą]+', 'a') ILIKE $2 OR name ILIKE $1 OR name ILIKE $2 ORDER BY birth_year ASC, name ASC";
    params = [
      `${req.query.searchTerm}%`,
      `% ${req.query.searchTerm}%`
    ];
  }

  const sql = `${searchSystem}`;

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
    SELECT id, name, birth_year, death_year
    FROM people
    WHERE id = $1`;

  pgClient.query(sql, [req.params.id])
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

const create = async (req, res) => {
  const person = req.body;

  if (!person.birth_year)
    person.birth_year = null;

  if (!person.death_year)
    person.death_year = null;
  
  pgClient.query("SELECT * FROM people")
  .then(result => {
    pgClient.query("INSERT INTO people (id, name, birth_year, death_year) VALUES ($1, $2, $3, $4)", [result.rows.length + 1, person.name, person.birth_year, person.death_year])
    .then(results => {
      res.location(`/people/${result.rows.length + 1}`);
      res.status(201).json({ message: "Person created successfully." });
    })
    .catch((error) => {
      res.status(500).json({ error: `Error: ${ error }.` });
    });
  })
}

const update = async (req, res) => {
  const person = req.body;

  if (!person.birth_year)
    person.birth_year = null;

  if (!person.death_year)
    person.death_year = null;

  pgClient.query("UPDATE people SET name = $1, birth_year = $2, death_year = $3 WHERE id = $4", [person.name, person.birth_year, person.death_year, person.id])
  .then(results => {
    res.status(201).json({ message: "Person successfully updated." });
  })
  .catch((error) => {
    res.status(500).json({ error: `Error: ${ error }` });
  })
}

module.exports = { index, indexLength, indexSelect, show, create, update };