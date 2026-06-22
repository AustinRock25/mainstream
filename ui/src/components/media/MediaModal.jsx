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
      timeStr += `${years}y `;
    
    if (months > 0) 
      timeStr += `${months}mo `;
    
    if (weeks > 0) 
      timeStr += `${weeks}w `;
    
    if (days > 0) 
      timeStr += `${days}d `;
    
    if (hours > 0) 
      timeStr += `${hours}h `;

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
    if (!user || user.rating_scale == 2) {
      if (g < (25/5))
        return "0/5";
      else if (g < (75/5))
        return "0.5/5";
      else if (g < (125/5))
        return "1/5";
      else if (g < (175/5))
        return "1.5/5";
      else if (g < (225/5))
        return "2/5";
      else if (g < (275/5))
        return "2.5/5";
      else if (g < (325/5))
        return "3/5";
      else if (g < (375/5))
        return "3.5/5";
      else if (g < (425/5))
        return "4/5";
      else if (g < (475/5))
        return "4.5/5";
      else
        return "5/5";
    }
    if (user.rating_scale == 1) {
      if (g < (25/4))
        return "0/4";
      else if (g < (75/4))
        return "0.5/4";
      else if (g < (125/4))
        return "1/4";
      else if (g < (175/4))
        return "1.5/4";
      else if (g < (225/4))
        return "2/4";
      else if (g < (275/4))
        return "2.5/4";
      else if (g < (325/4))
        return "3/4";
      else if (g < (375/4))
        return "3.5/4";
      else
        return "4/4";
    }
    else {
      if (g < (125/10))
        return "1/10";
      else if (g < (175/10))
        return "1.5/10";
      else if (g < (225/10))
        return "2/10";
      else if (g < (275/10))
        return "2.5/10";
      else if (g < (325/10))
        return "3/10";
      else if (g < (375/10))
        return "3.5/10";
      else if (g < (425/10))
        return "4/10";
      else if (g < (475/10))
        return "4.5/10";
      else if (g < (525/10))
        return "5/10";
      else if (g < (575/10))
        return "5.5/10";
      else if (g < (625/10))
        return "6/10";
      else if (g < (675/10))
        return "6.5/10";
      else if (g < (725/10))
        return "7/10";
      else if (g < (775/10))
        return "7.5/10";
      else if (g < (825/10))
        return "8/10";
      else if (g < (875/10))
        return "8.5/10";
      else if (g < (925/10))
        return "9/10";
      else if (g < (975/10))
        return "9.5/10";
      else
        return "10/10";
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
              {!!user && user.rating_scale == 1 && <span className={`fw-bold fs-5 text-${(media.grade || media.grade_tv) < (175/4) ? "danger" : (media.grade || media.grade_tv) < (225/4) ? "warning" : "success"}`}>{getGrade(media)}</span>}
              {!user || (!!user && user.rating_scale == 2) && <span className={`fw-bold fs-5 text-${(media.grade || media.grade_tv) < (175/5) ? "danger" : (media.grade || media.grade_tv) < (325/5) ? "warning" : "success"}`}>{getGrade(media)}</span>}
              {!!user && user.rating_scale == 3 && <span className={`fw-bold fs-5 text-${(media.grade || media.grade_tv) < (375/10) ? "danger" : (media.grade || media.grade_tv) < (625/10) ? "warning" : "success"}`}>{getGrade(media)}</span>}
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
            {media.type == "show" && media.seasons.length > 1 && !!user && user.rating_scale == 1 && <p className={`fw-bold fs-5 text-${media.seasons[currentSeason].grade < (175/4) ? "danger" : media.seasons[currentSeason].grade < (225/4) ? "warning" : "success"}`}>{getGradeSeason(media.seasons[currentSeason])}</p>}
            {!user || (media.type == "show" && media.seasons.length > 1 && !!user && user.rating_scale == 2) && <p className={`fw-bold fs-5 text-${media.seasons[currentSeason].grade < (175/5) ? "danger" : media.seasons[currentSeason].grade < (325/5) ? "warning" : "success"}`}>{getGradeSeason(media.seasons[currentSeason])}</p>}
            {media.type == "show" && media.seasons.length > 1 && !!user && user.rating_scale == 3 && <p className={`fw-bold fs-5 text-${media.seasons[currentSeason].grade < (375/10) ? "danger" : media.seasons[currentSeason].grade < (625/10) ? "warning" : "success"}`}>{getGradeSeason(media.seasons[currentSeason])}</p>}
            {media.type == "show" && media.runtime_tv != media.seasons[currentSeason].runtime && <p className="fw-bold fs-5 text-white">{time(media.seasons[currentSeason].runtime)}</p>}
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