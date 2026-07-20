import MediaForm from "../modals/MediaForm";
import { Modal, Row, Col, ToggleButton, Stack, Accordion, Button } from "react-bootstrap";
import { useSelector } from "react-redux";
import { useState } from "react";

function MediaModal({ show, setShow, media, user, seasonCount }) {
  const { isAdmin } = useSelector(state => state.auth);
  const [showMediaForm, setShowMediaForm] = useState(false);
  const [currentSeason, setCurrentSeason] = useState(0);
  
  const handleClose = () => {
    setShow(false);
  };

  const handleEditMediaClick = () => {
    setShowMediaForm(true);
  }

  const changeSeason = (season) => {
    setCurrentSeason(season);
  }

  const getNames = (people) => {
    if (!people || people.length === 0) 
      return [];

    return people.sort((a, b) => (a.ordering > b.ordering ? 1 : -1)).map(p => `${p.name}${p.death_date ? "†" : ""}`);
  };

  const combineDirectorsAndWriters = (media) => {
    const directors = media.directors || [];
    const writers = media.writers || [];

    if (directors.length === 0 || writers.length === 0) 
      return false;
    
    const directorIds = directors.map(d => d.director_id).sort().join(",");
    const writerIds = writers.map(w => w.writer_id).sort().join(",");
    return directorIds === writerIds;
  };

  const getYear = (media) => {
    if (media.type !== "show" || (seasonCount == 1 && media.completed)) 
      return new Date(media.release_date || media.start_date).getUTCFullYear();
    else if (seasonCount > 1 && media.completed)
      return `${new Date(media.start_date).getUTCFullYear()}-${new Date(media.end_date).getUTCFullYear()}`;
    else
      return `${new Date(media.start_date).getUTCFullYear()}-`;
  };

  const getPoster = (media) => {
    const wordsList = String(media.title).replace(/&/g, "and").split(" ");
    const processedWords = [];
    const strictArticles = new Set(["The", "A", "An"]);
    
    wordsList.forEach(word => {
      const wordCleaned = word.replace(/['’.]/g, "").replace(/[^a-zA-Z0-9½⅓àáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿÆŒ]/g, "_");
      
      if (strictArticles.has(wordCleaned))
        return;
      
      processedWords.push(wordCleaned);
    });
    
    let finalTitleStr = processedWords.join("_");
    let cleanTitle = finalTitleStr.trim().toLowerCase().replace(/[^a-z0-9½⅓àáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿæœ]/g, "_").replace(/_+/g, "_").replace(/^_+|_+$/g, "");
    
    return `${cleanTitle}`;
  }

  const time = (runtime) => {
    if (!runtime) 
      return "";

    const centuries = Math.floor(runtime / 52560000);
    const years = Math.floor((runtime % 52560000) / 525960);
    const months = Math.floor((runtime % 525960) / 43800);
    const weeks = Math.floor((runtime % 43800) / 10080);
    const days = Math.floor((runtime % 10080) / 1440);
    const hours = Math.floor((runtime % 1440) / 60);
    const minutes = runtime % 60;
    let timeStr = "";

    if (centuries > 0) 
      timeStr += `${centuries}c `;
    
    if (years > 0) 
      timeStr += `${years}yr `;
    
    if (months > 0) 
      timeStr += `${months}m `;
    
    if (weeks > 0) 
      timeStr += `${weeks}wk `;
    
    if (days > 0) 
      timeStr += `${days}d `;
    
    if (hours > 0) 
      timeStr += `${hours}hr `;

    if (minutes > 0) 
      timeStr += `${minutes}min`;

    return timeStr.trim();
  }

  const getGrade = (media) => {
    if (media.type == "show")
      media.grade = media.grade_tv;

    return grade(media.grade);
  };

  const getGradeSeason = (season) => {
    return grade(season.grade);
  };

  function grade(g) {
    let newGrade;

    if (!user)
      newGrade = (g + 100) / 2;
    else if (user.rating_scale == 1)
      newGrade = (g / 100) * 4;
    else if (user.rating_scale == 2)
      newGrade = (g / 100) * 5;
    else
      newGrade = ((g / 100) * 9) + 1;

    console.log(media.id + ": " + g + ", " + newGrade + ", " + Math.round(newGrade * 2) / 2);

    newGrade = Math.round(newGrade * 2) / 2;
    
    if (!user) {
      if (newGrade <= 59)
        return "F";
      else if (newGrade <= 62)
        return "D-";
      else if (newGrade <= 66)
        return "D";
      else if (newGrade <= 69)
        return "D+";
      else if (newGrade <= 72)
        return "C-";
      else if (newGrade <= 76)
        return "C";
      else if (newGrade <= 79)
        return "C+";
      else if (newGrade <= 82)
        return "B-";
      else if (newGrade <= 86)
        return "B";
      else if (newGrade <= 89)
        return "B+";
      else if (newGrade <= 92)
        return "A-";
      else if (newGrade <= 96)
        return "A";
      else
        return "A+";
    }
    else {
      if (user.rating_scale == 1)
        return newGrade + "/4";
      else if (user.rating_scale == 2)
        return newGrade + "/5";
      else
        return newGrade + "/10";
    }
  }

  return (
    <Modal show={show} onHide={handleClose} size="lg" centered className="bg-dark text-white">
      <Modal.Header closeButton closeVariant="white">
        <Modal.Title className="w-100">
          <div className="d-flex align-items-center justify-content-between">
            <div className="flex-wrap" style={{ maxWidth: "50%" }}>
              <span>
                <i className="me-2">{media.title}</i>
                <span className="fw-light fs-5 text-white-50">{getYear(media)}</span>
              </span>
            </div>
            <div className="d-flex flex-column flex-md-row gap-xs-1 gap-md-4">
              <span className="fw-light fs-5 text-white-50">{media.rating === "Not Rated" ? "NR" : media.rating}</span>
              <span className="fw-light fs-5 text-white-50">{time(media.runtime || media.runtime_tv)}</span>
              {media.type == "movie" && <span className={`fw-bold fs-5 text-${(Math.round((media.grade + 100) / 2)) <= 69 ? "danger" : Math.round((media.grade + 100) / 2) <= 79 ? "warning" : "success"}`}>{getGrade(media)}</span>}
              {media.type == "show" && <span className={`fw-bold fs-5 text-${(Math.round((media.grade_tv + 100) / 2)) <= 69 ? "danger" : Math.round((media.grade_tv + 100) / 2) <= 79 ? "warning" : "success"} mb-0`}>{getGrade(media)}</span>}
            </div>
          </div>
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        {media.type == "show" &&
          <Row>
            <Col className="justify-content-center">
              <Stack direction="horizontal" gap={2} className="justify-content-center">
                {media.seasons.sort((a, b) => (a.season > b.season ? 1 : -1)).map((s, index) => (
                  <ToggleButton type="radio" variant="link" style={{ color: "white", fontWeight: (index === currentSeason) ? "bold" : "normal" }} onClick={() => changeSeason(index)}>{s.season}</ToggleButton>
                ))}
              </Stack>
            </Col>
          </Row>
        }
        <Row>
          <Col xs={12} md={4} className="text-center mb-4 mb-md-0">
            <img 
              src={media.type !== "show" ? `posters/${new Date(media.release_date).getUTCFullYear()}_${getPoster(media)}.jpg` : `posters/${new Date(media.seasons[currentSeason].episodes[0].release_date).getUTCFullYear()}_${getPoster(media)}_s${currentSeason + 1}.jpg`}
              alt={media.title}
              className="img-fluid rounded mb-3 shadow"
              style={{ maxHeight: "300px" }}
            />
            <Stack direction="horizontal" gap={3} className="justify-content-center align-items-center mb-4 mb-md-0">
              {media.type == "show" && media.runtime_tv != media.seasons[currentSeason].runtime && <p className="fw-bold fs-5 text-white mb-0">{time(media.seasons[currentSeason].runtime)}</p>}
              {media.type == "show" && media.seasons.length > 1 && <p className={`fw-bold fs-5 text-${(Math.round((media.seasons[currentSeason].grade + 100) / 2)) <= 69 ? "danger" : Math.round((media.seasons[currentSeason].grade + 100) / 2) <= 79 ? "warning" : "success"} mb-0`}>{getGradeSeason(media.seasons[currentSeason])}</p>}
            </Stack>
          </Col>
          <Col xs={12} md={8}>
            <div className="mb-4">
              {combineDirectorsAndWriters(media) && (
                <div className="mb-2">
                  <h6 className="text-uppercase text-secondary small fw-bold">Written & Directed by</h6>
                  <p>{getNames(media.directors).join(", ")}</p>
                </div>
              )}
              {!combineDirectorsAndWriters(media) && getNames(media.directors).length > 0 && (
                <div className="mb-2">
                  <h6 className="text-uppercase text-secondary small fw-bold">Directed by</h6>
                  <p>{getNames(media.directors).join(", ")}</p>
                </div>
              )}
              {!combineDirectorsAndWriters(media) && getNames(media.writers).length > 0 && (
                <div className="mb-2">
                  <h6 className="text-uppercase text-secondary small fw-bold">Written by</h6>
                  <p>{getNames(media.writers).join(", ")}</p>
                </div>
              )}
              {(getNames(media.cast_members).length > 0 || (!!media.seasons && getNames(media.seasons[currentSeason].cast_members).length > 0)) && (
                <div className="mb-2">
                  <h6 className="text-uppercase text-secondary small fw-bold">Starring</h6>
                  <p>{getNames(media.cast_members || media.seasons[currentSeason].cast_members).join(", ")}</p>
                </div>
              )}
            </div>
          </Col>
        </Row>
        <hr className="my-3" />
        <Row>
          <Col xs={12} md={12}>
            {media.type === "show" && media.seasons[currentSeason].episodes ? (
              <div className="mt-4">
                <h5 className="mb-3 border-bottom border-secondary pb-2">Episodes</h5>
                <Accordion flush>
                  {media.seasons[currentSeason].episodes.sort((a, b) => (a.episode > b.episode ? 1 : -1)).map((ep, index) => (
                    <Accordion.Item eventKey={index.toString()} key={index} className="border-0">
                      <Accordion.Header className="w-100 d-flex align-items-center position-relative">
                        <div style={{ maxWidth: "50%" }}>
                          <span className="fs-5 fw-bold">{ep.episode}. {ep.title}<small className="ms-2 small opacity-50">{new Date(ep.release_date).getUTCFullYear()}</small></span>
                        </div>
                        <span className="fs-5 fw-bold opacity-50 text-nowrap position-absolute" style={{ right: "3.5rem" }}>{time(ep.runtime)}</span>
                      </Accordion.Header>
                      <Accordion.Body className="bg-dark text-white-50">
                        {combineDirectorsAndWriters(ep) && (
                          <div className="mb-2">
                            <h6 className="text-uppercase text-secondary small fw-bold">Written & Directed by</h6>
                            <p>{getNames(ep.directors).join(", ")}</p>
                          </div>
                        )}
                        {!combineDirectorsAndWriters(ep) && getNames(ep.directors).length > 0 && (
                          <div className="mb-2">
                            <h6 className="text-uppercase text-secondary small fw-bold">Directed by</h6>
                            <p>{getNames(ep.directors).join(", ")}</p>
                          </div>
                        )}
                        {!combineDirectorsAndWriters(ep) && getNames(ep.writers).length > 0 && (
                          <div className="mb-2">
                            <h6 className="text-uppercase text-secondary small fw-bold">Written by</h6>
                            <p>{getNames(ep.writers).join(", ")}</p>
                          </div>
                        )}
                        <hr className="my-3" />
                        <p className="text-center">{ep.synopsis}</p>
                      </Accordion.Body>
                    </Accordion.Item>
                  ))}
                </Accordion>
              </div>
            ) : 
            <p className="text-center">{media.synopsis}</p>
          }
          </Col>
        </Row>
      </Modal.Body>
      {isAdmin && (
        <div className="d-flex justify-content-end m-4">
          <Button variant="outline-light" size="sm" onClick={handleEditMediaClick}>Edit</Button>
        </div>
      )}
      {!!user && <MediaForm show={showMediaForm} setShow={setShowMediaForm} media={media} season={media.seasons?.[currentSeason]?.season || 0} />}
    </Modal>
  );
}

export default MediaModal;