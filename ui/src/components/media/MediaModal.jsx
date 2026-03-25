import { Modal, Row, Col, Badge, Stack, Accordion } from "react-bootstrap";

function MediaModal({ show, setShow, media, user, seasonCount, pillColor, pillTextColor }) {
  const handleClose = () => {
    setShow(false)
  };

  const getNames = (people) => {
    if (!people || people.length === 0) 
      return [];

    return [...people].sort((a, b) => (a.ordering > b.ordering ? 1 : -1)).map(p => `${p.name}${p.death_date ? "†" : ""}`);
  };

  const combineDirectorsAndWriters = (media) => {
    const directors = media.directors || media.directors_tv || [];
    const writers = media.writers || media.writers_tv || [];

    if (directors.length === 0 || writers.length === 0) 
      return false;
    
    const directorIds = directors.map(d => d.director_id).sort().join(",");
    const writerIds = writers.map(w => w.writer_id).sort().join(",");
    return directorIds === writerIds;
  };

  const getSeason = (media) => {
    if ((media.type === "show" && media.completed && seasonCount == 1) || media.type === "movie")
      return ``;
    else
      return `season ${media.season}`;
  };

  const getYear = (media) => {
    if (media.type !== "show") 
      return `(${new Date(media.release_date).getFullYear()})`;
    else
      return ``;
  };

  const time = (runtime) => {
    if (!runtime) 
      return "";

    const hours = Math.floor(runtime / 60);
    const minutes = runtime % 60;
    let timeStr = "";

    if (hours > 0) 
      timeStr += `${hours}h `;

    if (minutes > 0) 
      timeStr += `${minutes}m`;

    return timeStr.trim();
  }

  const getGrade = () => {
    if (!user) {
      if (media.grade < 5.56)
        return "1/10";
      else if (media.grade < 16.67)
        return "2/10";
      else if (media.grade < 27.78)
        return "3/10";
      else if (media.grade < 38.89)
        return "4/10";
      else if (media.grade < 50)
        return "5/10";
      else if (media.grade < 61.11)
        return "6/10";
      else if (media.grade < 72.22)
        return "7/10";
      else if (media.grade < 83.33)
        return "8/10";
      else if (media.grade < 94.44)
        return "9/10";
      else
        return "10/10";
    }
    else if (user.rating_scale == 1) {
      if (media.grade < 6.25)
        return "0/4";
      else if (media.grade < 18.75)
        return "0.5/4";
      else if (media.grade < 31.25)
        return "1/4";
      else if (media.grade < 43.75)
        return "1.5/4";
      else if (media.grade < 56.25)
        return "2/4";
      else if (media.grade < 68.75)
        return "2.5/4";
      else if (media.grade < 81.25)
        return "3/4";
      else if (media.grade < 93.75)
        return "3.5/4";
      else
        return "4/4";
    }
    else if (user.rating_scale == 2) {
      if (media.grade < 5)
        return "0/5";
      else if (media.grade < 15)
        return "0.5/5";
      else if (media.grade < 25)
        return "1/5";
      else if (media.grade < 35)
        return "1.5/5";
      else if (media.grade < 45)
        return "2/5";
      else if (media.grade < 55)
        return "2.5/5";
      else if (media.grade < 65)
        return "3/5";
      else if (media.grade < 75)
        return "3.5/5";
      else if (media.grade < 85)
        return "4/5";
      else if (media.grade < 95)
        return "4.5/5";
      else
        return "5/5";
    }
    else {
      if (media.grade < 4.17)
        return "F";
      else if (media.grade < 12.5)
        return "D-";
      else if (media.grade < 20.83)
        return "D";
      else if (media.grade < 29.17)
        return "D+";
      else if (media.grade < 37.5)
        return "C-";
      else if (media.grade < 45.83)
        return "C";
      else if (media.grade < 54.17)
        return "C+";
      else if (media.grade < 62.5)
        return "B-";
      else if (media.grade < 70.83)
        return "B";
      else if (media.grade < 79.17)
        return "B+";
      else if (media.grade < 87.5)
        return "A-";
      else if (media.grade < 95.83)
        return "A";
      else
        return "A+";
    }
  };

  const directors = getNames(media.directors || media.directors_tv);
  const writers = getNames(media.writers || media.writers_tv);
  const cast = getNames(media.cast_members || media.cast_members_tv);
  const isCombined = combineDirectorsAndWriters(media);

  return (
    <Modal show={show} onHide={handleClose} size="lg" centered contentClassName="bg-dark text-white">
      <Modal.Header closeButton closeVariant="white">
        <Modal.Title><i>{media.title}</i> {getSeason(media)}<span className="fw-light fs-5 text-white-50">{getYear(media)}</span></Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Row>
          <Col xs={12} md={4} className="text-center mb-4 mb-md-0">
            <img 
              src={media.type !== "show" ? `posters/${media.poster}_poster.jpg` : `posters/${media.poster}-season-${media.season}_poster.jpg`}
              alt={media.title}
              className="img-fluid rounded mb-3 shadow"
              style={{ maxHeight: "300px" }}
            />
            <Stack direction="horizontal" gap={2} className="justify-content-center">
              <Badge bg={pillColor} text={pillTextColor} pill>{getGrade()}</Badge>
              <Badge bg="secondary" pill>{media.rating === "Not Rated" ? "NR" : media.rating}</Badge>
              <Badge bg="dark" pill className="border border-secondary">{time(media.runtime)}</Badge>
            </Stack>
          </Col>
          <Col xs={12} md={8}>
            <div className="mb-4">
              {isCombined && (
                <div className="mb-2">
                  <h6 className="text-uppercase text-secondary small fw-bold">Written & Directed by</h6>
                  <p>{directors.join(", ")}</p>
                </div>
              )}
              {!isCombined && directors.length > 0 && (
                <div className="mb-2">
                  <h6 className="text-uppercase text-secondary small fw-bold">Directed by</h6>
                  <p>{directors.join(", ")}</p>
                </div>
              )}
              {!isCombined && writers.length > 0 && (
                <div className="mb-2">
                  <h6 className="text-uppercase text-secondary small fw-bold">Written by</h6>
                  <p>{writers.join(", ")}</p>
                </div>
              )}
              {cast.length > 0 && (
                <div className="mb-2">
                  <h6 className="text-uppercase text-secondary small fw-bold">Starring</h6>
                  <p>{cast.join(", ")}</p>
                </div>
              )}
            </div>
            {media.type === "show" && media.episodes && (
              <div className="mt-4">
                <h5 className="mb-3 border-bottom border-secondary pb-2">Episodes</h5>
                <Accordion variant="dark">
                  {media.episodes.map((ep, index) => (
                    <Accordion.Item eventKey={index.toString()} key={index} bg="dark" className="text-white">
                      <Accordion.Header>
                        <span className="fs-5 fw-bold text-white">{ep.episode}. {ep.title} <small className="ms-2 text-white-50 fw-light">({new Date(ep.release_date).getFullYear()})</small></span>
                      </Accordion.Header>
                      <Accordion.Body className="text-white-50">Released: {new Date(ep.release_date).toLocaleDateString("en-US", { timeZone: "UTC"})}</Accordion.Body>
                    </Accordion.Item>
                  ))}
                </Accordion>
              </div>
            )}
          </Col>
        </Row>
      </Modal.Body>
    </Modal>
  );
}

export default MediaModal;