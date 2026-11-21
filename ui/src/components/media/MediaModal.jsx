import MediaForm from "../modals/MediaForm";
import { Modal, Row, Col, ToggleButton, Stack, Accordion, Button } from "react-bootstrap";
import { useSelector } from "react-redux";
import { useEffect, useState } from "react";
import { FastAverageColor } from "fast-average-color";
import api from "../../api";

const fac = new FastAverageColor();

function getContrastingTextColor(r, g, b) {
  const linearize = (c) => {
    const norm = c / 255;
    return norm <= 0.04045 ? norm / 12.92 : Math.pow((norm + 0.055) / 1.055, 2.4);
  };

  const luminance =
    0.2126 * linearize(r) +
    0.7152 * linearize(g) +
    0.0722 * linearize(b);

  return luminance > 0.1791 ? "#000000" : "#FFFFFF";
}

function MediaModal({ show, setShow, media, user }) {
  const { isAdmin, ratingScale } = useSelector(state => state.auth);
  const [showMediaForm, setShowMediaForm] = useState(false);
  const [currentSeason, setCurrentSeason] = useState(0);
  const [scales, setScales] = useState([]);
  const [theme, setTheme] = useState({
    backgroundColor: "#212529",
    textColor: "#FFFFFF",
  });

  useEffect(() => {
    api.get("/auth/get")
      .then(response => {
        setScales(response.data);
      })
      .catch(error => console.error("Failed to fetch rating scales", error));
  }, []);
  
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

    return [...people].sort((a, b) => (a.ordering > b.ordering ? 1 : -1)).map((p, index, arr) => (<span key={p.person_id || p.id || index}>{p.death_date ? <i>{p.name}</i> : p.name}{index < arr.length - 1 ? ", " : ""}</span>));
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
    if (media.type !== "show") 
      return new Date(media.release_date).getUTCFullYear();
    else if (media.completed)
      return (new Date(media.start_date).getUTCFullYear() === new Date(media.end_date).getUTCFullYear()) ? new Date(media.start_date).getUTCFullYear() : ((new Date(media.start_date).getUTCFullYear() % 1000 > new Date(media.end_date).getUTCFullYear() % 1000) ? `${new Date(media.start_date).getUTCFullYear()}-${new Date(media.end_date).getUTCFullYear()}` : `${new Date(media.start_date).getUTCFullYear()}–${String(new Date(media.end_date).getUTCFullYear()).slice(-2)}`);
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

  const getPosterSrc = (mediaItem, seasonIndex) => {
    if (!mediaItem) 
      return "";

    if (mediaItem.type !== "show")
      return `posters/${new Date(mediaItem.release_date).getUTCFullYear()}_${getPoster(mediaItem)}.jpg`;

    const baseYear = new Date(mediaItem.seasons?.[0]?.episodes?.[0]?.release_date || mediaItem.start_date).getUTCFullYear();
    return `posters/${baseYear}_${getPoster(mediaItem)}/${seasonIndex + 1}.jpg`;
  };

  useEffect(() => {
    let cancelled = false;
    const posterSrc = getPosterSrc(media, currentSeason);

    if (!show || !posterSrc)
      return;

    fac.getColorAsync(posterSrc, { crossOrigin: "anonymous" })
      .then((color) => {
        if (cancelled) 
          return;

        const [r, g, b] = color.value;

        setTheme({ backgroundColor: color.hex, textColor: getContrastingTextColor(r, g, b) });
      })
      .catch(() => {
        if (cancelled) 
          return;

        setTheme({ backgroundColor: "#212529", textColor: "#FFFFFF" });
      });

    return () => { cancelled = true; };
  }, [show, media, currentSeason]);

  const time = (runtime) => {
    let timeStr = "";

    if (!runtime) 
      return "";

    const centuries = Math.floor(runtime / 52560000);

    if (centuries > 0) 
      timeStr += `${centuries}c `;

    runtime %= 52560000;

    const years = Math.floor(runtime / 525600);

    if (years > 0) 
      timeStr += `${years}yr `;

    runtime %= 525600;

    const months = Math.floor(runtime / 43200);

    if (months > 0) 
      timeStr += `${months}m `;

    runtime %= 43200;

    const weeks = Math.floor(runtime / 10080);

    if (weeks > 0) 
      timeStr += `${weeks}wk `;

    runtime %= 10080;

    const days = Math.floor(runtime / 1440);

    if (days > 0) 
      timeStr += `${days}d `;
    
    runtime %= 1440;

    const hours = Math.floor(runtime / 60);

    if (hours > 0) 
      timeStr += `${hours}hr `;

    const minutes = runtime % 60;

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
    const scaleId = user ? user.rating_scale : ratingScale;
    const activeScale = scales.find(s => Number(s.id) === Number(scaleId));
    const scaleMin = user ? user.rating_scale_min : activeScale?.min;
    const scaleMax = user ? user.rating_scale_max : activeScale?.max;
    const scaleStep = user ? user.rating_scale_step : activeScale?.step;
    let newGrade = Math.round((Number.parseFloat((g / 100) * scaleMax)) * (1 / scaleStep)) / (1 / scaleStep);

    if (newGrade < scaleMin)
      newGrade = scaleMin;
    
    if (Number(scaleId) == 20) {
      if (newGrade <= 2)
        return "F";
      else if (newGrade == 3)
        return "D-";
      else if (newGrade == 4)
        return "D";
      else if (newGrade == 5)
        return "D+";
      else if (newGrade == 6)
        return "C-";
      else if (newGrade == 7)
        return "C";
      else if (newGrade == 8)
        return "C+";
      else if (newGrade == 9)
        return "B-";
      else if (newGrade == 10)
        return "B";
      else if (newGrade == 11)
        return "B+";
      else if (newGrade == 12)
        return "A-";
      else if (newGrade == 13)
        return "A";
      else
        return "A+";
    }
    else
      return newGrade + `/${scaleMax}`;
  }

  const isLightBg = theme.textColor === "#000000";
  const mutedTextColor = isLightBg ? "rgba(0, 0, 0, 0.65)" : "rgba(255, 255, 255, 0.65)";

  return (
    <Modal show={show} onHide={handleClose} size="lg" centered contentClassName="border-0">
      <Modal.Header closeButton closeVariant={isLightBg ? "dark" : "white"} style={{ backgroundColor: theme.backgroundColor, color: theme.textColor }}>
        <Modal.Title className="w-100">
          <div className="d-flex align-items-center justify-content-between">
            <div className="flex-wrap" style={{ maxWidth: "50%" }}>
              <span>
                <i className="me-2">{media.title}</i>
                <span className="fw-light fs-5" style={{ color: mutedTextColor }}>{getYear(media)}</span>
              </span>
            </div>
            <div className="d-flex flex-column flex-md-row gap-xs-1 gap-md-4">
              <span className="fw-light fs-5" style={{ color: mutedTextColor }}>{media.rating === "Not Rated" ? "NR" : media.rating}</span>
              <span className="fw-light fs-5" style={{ color: mutedTextColor }}>{time(media.runtime || media.runtime_tv)}</span>
              {media.type == "movie" && <span className="fw-bold fs-5" style={{ color: mutedTextColor }}>{getGrade(media)}</span>}
              {media.type == "show" && <span className="fw-bold fs-5" style={{ color: mutedTextColor }}>{getGrade(media)}</span>}
            </div>
          </div>
        </Modal.Title>
      </Modal.Header>
      <Modal.Body style={{ backgroundColor: theme.backgroundColor, color: theme.textColor }}>
        {media.type == "show" &&
          <Row>
            <Col className="justify-content-center">
              <Stack direction="horizontal" gap={2} className="justify-content-center">
                {media.seasons.sort((a, b) => (a.season > b.season ? 1 : -1)).map((s, index) => (
                  <ToggleButton key={s.season ?? index} type="radio" variant="link" style={{ color: theme.textColor, fontWeight: (index === currentSeason) ? "bold" : "normal" }} onClick={() => changeSeason(index)}>{s.season}</ToggleButton>
                ))}
              </Stack>
            </Col>
          </Row>
        }
        <Row>
          <Col xs={12} md={4} className="text-center mb-4 mb-md-0">
            <img 
              src={media.type !== "show" ? `posters/${new Date(media.release_date).getUTCFullYear()}_${getPoster(media)}.jpg` : `posters/${new Date(media.seasons[0].episodes[0].release_date).getUTCFullYear()}_${getPoster(media)}/${currentSeason + 1}.jpg`}
              alt={media.title}
              className="img-fluid rounded mb-3 shadow"
              style={{ maxHeight: "300px" }}
            />
            <Stack direction="horizontal" gap={3} className="justify-content-center align-items-center mb-4 mb-md-0">
              {(media.type == "show" && media.runtime_tv != media.seasons[currentSeason].runtime) && <p className="fw-bold fs-5 text-white mb-0">{time(media.seasons[currentSeason].runtime)}</p>}
              {(media.type == "show" && media.seasons.length > 1) && <p className="fw-bold fs-5 text-white-50 mb-0" style={{ color: mutedTextColor }}>{getGradeSeason(media.seasons[currentSeason])}</p>}
            </Stack>
          </Col>
          <Col xs={12} md={8}>
            <div className="mb-4">
              {combineDirectorsAndWriters(media) && (
                <div className="mb-2">
                  <h6 className="text-uppercase small fw-bold" style={{ color: mutedTextColor }}>Written & Directed by</h6>
                  <p>{getNames(media.directors)}</p>
                </div>
              )}
              {!combineDirectorsAndWriters(media) && getNames(media.directors).length > 0 && (
                <div className="mb-2">
                  <h6 className="text-uppercase small fw-bold" style={{ color: mutedTextColor }}>Directed by</h6>
                  <p>{getNames(media.directors)}</p>
                </div>
              )}
              {!combineDirectorsAndWriters(media) && getNames(media.writers).length > 0 && (
                <div className="mb-2">
                  <h6 className="text-uppercase small fw-bold" style={{ color: mutedTextColor }}>Written by</h6>
                  <p>{getNames(media.writers)}</p>
                </div>
              )}
              {(getNames(media.cast_members).length > 0 || (!!media.seasons && getNames(media.seasons[currentSeason].cast_members).length > 0)) && (
                <div className="mb-2">
                  <h6 className="text-uppercase small fw-bold" style={{ color: mutedTextColor }}>Starring</h6>
                  <p>{getNames(media.cast_members || media.seasons[currentSeason].cast_members)}</p>
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
                    <Accordion.Item eventKey={index.toString()} key={index} className="border-0" style={{ backgroundColor: theme.backgroundColor, color: theme.textColor }}>
                      <Accordion.Header className="w-100 d-flex align-items-center position-relative">
                        <div style={{ maxWidth: "50%" }}>
                          <span className="fs-5 fw-bold">{ep.episode}. {ep.title}<small className="ms-2 small opacity-50">{new Date(ep.release_date).getUTCFullYear()}</small></span>
                        </div>
                        <span className="fs-5 fw-bold opacity-50 text-nowrap position-absolute" style={{ right: "3.5rem" }}>{time(ep.runtime)}</span>
                      </Accordion.Header>
                      <Accordion.Body style={{ backgroundColor: theme.backgroundColor, color: mutedTextColor }}>
                        <Row>
                          <Col xs={12} md={8}>
                            {combineDirectorsAndWriters(ep) && (
                              <div className="mb-2">
                                <h6 className="text-uppercase small fw-bold" style={{ color: mutedTextColor }}>Written & Directed by</h6>
                                <p>{getNames(ep.directors)}</p>
                              </div>
                            )}
                            {!combineDirectorsAndWriters(ep) && getNames(ep.directors).length > 0 && (
                              <div className="mb-2">
                                <h6 className="text-uppercase small fw-bold" style={{ color: mutedTextColor }}>Directed by</h6>
                                <p>{getNames(ep.directors)}</p>
                              </div>
                            )}
                            {!combineDirectorsAndWriters(ep) && getNames(ep.writers).length > 0 && (
                              <div className="mb-2">
                                <h6 className="text-uppercase small fw-bold" style={{ color: mutedTextColor }}>Written by</h6>
                                <p>{getNames(ep.writers)}</p>
                              </div>
                            )}
                          </Col>
                          <Col xs={12} md={4} className="text-center mb-1 mb-md-0">
                            <img 
                              src={`posters/${new Date(media.seasons[0].episodes[0].release_date).getUTCFullYear()}_${getPoster(media)}/${currentSeason + 1}x${ep.episode}.jpg`}
                              alt={media.title}
                              className="img-fluid rounded mb-1 shadow"
                            />
                          </Col>
                        </Row>
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
        {(((new Date().getUTCFullYear() - new Date(media.release_date || media.start_date).getUTCFullYear()) % 5 == 0) && (new Date().getUTCFullYear() - new Date(media.release_date || media.start_date).getUTCFullYear()) >= 10) && <div className="flex-wrap">
          <p className="text-center fs-6"><b>{(new Date().getUTCFullYear() - new Date(media.release_date || media.start_date).getUTCFullYear())}th Anniversary</b></p>
        </div>}
      </Modal.Body>
      {isAdmin && (
        <div className="d-flex justify-content-end m-4" style={{ backgroundColor: theme.backgroundColor, color: theme.textColor }}>
          <Button variant={isLightBg ? "outline-dark" : "outline-light"} size="sm" onClick={handleEditMediaClick}>Edit</Button>
        </div>
      )}
      {!!user && <MediaForm show={showMediaForm} setShow={setShowMediaForm} media={media} season={media.seasons?.[currentSeason]?.season || 0} />}
    </Modal>
  );
}

export default MediaModal;