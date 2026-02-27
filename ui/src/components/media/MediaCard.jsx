import api from "../../api";
import { Button, Card, Col, Badge, Stack } from "react-bootstrap";
import MediaForm from "../modals/MediaForm";
import { useEffect, useState } from "react";
import { useSelector } from "react-redux";

function MediaCard ({media}) {
  const { isAdmin, user } = useSelector(state => state.auth);
  const [pillColor, setPillColor] = useState("danger");
  const [pillTextColor, setPillTextColor] = useState("white");
  const [seasonCount, setSeasonCount] = useState(0);
  const [showMediaModal, setShowMediaModal] = useState(false);
  const [showRuntime, setShowRuntime] = useState(false);

  function handleEditMediaClick() {
    setShowMediaModal(true);
  }

  function handlePillClick() {
    if (showRuntime)
      setShowRuntime(false);
    else
      setShowRuntime(true);
  }

  useEffect(() => {
    if (!media.grade)
      media.grade = media.grade_tv;

    
    if (media.grade <= 49) {
      setPillColor("danger");
      setPillTextColor("white");
    }
    else if (media.grade <= 74) {
      setPillColor("warning");
      setPillTextColor("black");
    }
    else {
      setPillColor("success");
      setPillTextColor("white");
    }

    if (media.type === "show") {
      api.get("/media/seasons", { params: { id: media.id } })
      .then(response => {
        setSeasonCount(response.data[0].count);
      });
    }
  }, [media.id, media.type]);

  const getNames = (people) => {
    if (!people || people.length === 0)
      return [];

    people.sort((a, b) => (a.ordering > b.ordering ? 1 : -1));
    return Array.isArray(people) && people.map(p => `${p.name}${p.death_date ? "†" : ""}`);
  };

  const combineDirectorsAndWriters = (media) => {
    const directorIds = Array.isArray(media.directors || media.directors_tv || []) && (media.directors || media.directors_tv || []).map(d => d.director_id).sort().join(",");
    const writerIds = Array.isArray(media.writers || media.writers_tv || []) && (media.writers || media.writers_tv || []).map(w => w.writer_id).sort().join(",");
    return directorIds && writerIds && directorIds === writerIds;
  };
  
  const directors = getNames(media.directors || media.directors_tv);
  const writers = getNames(media.writers || media.writers_tv);
  const cast = getNames(media.cast_members || media.cast_members_tv);
  const isCombined = combineDirectorsAndWriters(media);

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

  const getYearRange = (start, end) => {
    const startYear = new Date(start).getFullYear();

    if (!end) 
      return startYear;

    const endYear = new Date(end).getFullYear();

    if (startYear === endYear)
      return startYear;

    return `${startYear}–${String(endYear).slice(-2)}`;
  };
  
  const getYear = (media) => {
    if (media.type !== "show")
      return `(${new Date(media.release_date).getFullYear()})`;
    else {
      if (seasonCount == 1 && media.completed == true)
        return `(${getYearRange(media.start_date, media.end_date)})`;
      else
        return `season ${media.season} (${getYearRange(media.start_date, media.end_date)})`;
    }
  };

  const getGrade = (media) => {
    if (!media.grade)
      media.grade = media.grade_tv;

    if (!user) {
      if (media.grade < 50/9)
        return "1/10";
      else if (media.grade < 150/9)
        return "2/10";
      else if (media.grade < 250/9)
        return "3/10";
      else if (media.grade < 350/9)
        return "4/10";
      else if (media.grade < 450/9)
        return "5/10";
      else if (media.grade < 550/9)
        return "6/10";
      else if (media.grade < 650/9)
        return "7/10";
      else if (media.grade < 750/9)
        return "8/10";
      else if (media.grade < 850/9)
        return "9/10";
      else
        return "10/10";
    }
    else if (user.rating_scale == 1) {
      if (media.grade < 25/4)
        return "0/4";
      else if (media.grade < 75/4)
        return "0.5/4";
      else if (media.grade < 125/4)
        return "1/4";
      else if (media.grade < 175/4)
        return "1.5/4";
      else if (media.grade < 225/4)
        return "2/4";
      else if (media.grade < 275/4)
        return "2.5/4";
      else if (media.grade < 325/4)
        return "3/4";
      else if (media.grade < 375/4)
        return "3.5/4";
      else
        return "4/4";
    }
    else if (user.rating_scale == 2) {
      if (media.grade < 25/5)
        return "0/5";
      else if (media.grade < 75/5)
        return "0.5/5";
      else if (media.grade < 125/5)
        return "1/5";
      else if (media.grade < 175/5)
        return "1.5/5";
      else if (media.grade < 225/5)
        return "2/5";
      else if (media.grade < 275/5)
        return "2.5/5";
      else if (media.grade < 325/5)
        return "3/5";
      else if (media.grade < 375/5)
        return "3.5/5";
      else if (media.grade < 425/5)
        return "4/5";
      else if (media.grade < 475/5)
        return "4.5/5";
      else
        return "5/5";
    }
    else {
      if (media.grade < 50/12)
        return "F";
      else if (media.grade < 150/12)
        return "D-";
      else if (media.grade < 250/12)
        return "D";
      else if (media.grade < 350/12)
        return "D+";
      else if (media.grade < 450/12)
        return "C-";
      else if (media.grade < 550/12)
        return "C";
      else if (media.grade < 650/12)
        return "C+";
      else if (media.grade < 750/12)
        return "B-";
      else if (media.grade < 850/12)
        return "B";
      else if (media.grade < 950/12)
        return "B+";
      else if (media.grade < 1050/12)
        return "A-";
      else if (media.grade < 1150/12)
        return "A";
      else
        return "A+";
    }
  }

  return (
    <Col>
      <Card className="h-100">
        <Card.Img 
          variant="top" 
          src={media.type !== "show" ? `posters/${media.poster}_poster.jpg` : `posters/${media.poster}-season-${media.season}_poster.jpg`}
          alt={`Poster for ${media.title}`} 
          fluid
        />
        <Card.Body className="d-flex flex-column">
          <Card.Title className="h6">
            <span className="fw-normal text-white-50"><i>{media.title}</i> {getYear(media)}</span>
          </Card.Title>
          <Stack direction="horizontal" gap={2} className="mt-2 mb-3 mx-auto">
            <Badge bg={pillColor} text={pillTextColor} pill>{getGrade(media)}</Badge>
            <Badge bg="secondary" pill>{media.rating == "Not Rated" ? "NR" : media.rating}</Badge>
            {media.type === "movie" ? <Badge bg="dark" pill>{time(media.runtime)}</Badge> : <Badge bg="dark" pill onClick={handlePillClick} style={{ cursor: "pointer" }}>{showRuntime ? time(media.runtime_tv) : media.episodes + "eps"}</Badge>}
          </Stack>
          {(media.id != 1597) 
            ? 
              <div className="small text-white-50" style={{fontSize: "0.8rem"}}>
                {isCombined && (
                  <div className="mb-1">
                    <b>Written & Directed by</b>
                    {Array.isArray(directors) && directors.map((name, index) => <div key={`director-writer-${index}`}>{name}</div>)}
                  </div>
                )}
                {!isCombined && directors.length > 0 && (
                  <div className="mb-1">
                    <b>Directed by</b>
                    {Array.isArray(directors) && directors.map((name, index) => <div key={`director-${index}`}>{name}</div>)}
                  </div>
                )}
                {!isCombined && writers.length > 0 && (
                  <div className="mb-1">
                    <b>Written by</b>
                    {Array.isArray(writers) && writers.map((name, index) => <div key={`writer-${index}`}>{name}</div>)}
                  </div>
                )}
                {cast.length > 0 && (
                  <div className="mb-1">
                    <b>Starring</b>
                    {Array.isArray(cast) && cast.map((name, index) => <div key={`cast-${index}`}>{name}</div>)}
                  </div>
                )}
              </div>
            : 
              <>
                <div className="text-white-50">
                  <i>Planet Terror</i>
                  <div className="mb-1 small text-white-50" style={{fontSize: "0.8rem"}}>
                    <b>Written & Directed by</b>
                    <div key={`director-writer-0`}>{media.directors[0].name}{media.directors[0].death_date ? "†" : ""}</div>
                  </div>
                  <div className="mb-1 small text-white-50" style={{fontSize: "0.8rem"}}>
                    <b>Starring</b>
                    <div key={`cast-0`}>{media.cast_members[0].name}{media.cast_members[0].death_date ? "†" : ""}</div>
                    <div key={`cast-1`}>{media.cast_members[1].name}{media.cast_members[1].death_date ? "†" : ""}</div>
                    <div key={`cast-2`}>{media.cast_members[2].name}{media.cast_members[2].death_date ? "†" : ""}</div>
                    <div key={`cast-3`}>{media.cast_members[3].name}{media.cast_members[3].death_date ? "†" : ""}</div>
                    <div key={`cast-4`}>{media.cast_members[4].name}{media.cast_members[4].death_date ? "†" : ""}</div>
                    <div key={`cast-5`}>{media.cast_members[5].name}{media.cast_members[5].death_date ? "†" : ""}</div>
                  </div>
                </div>
                <div className="text-white-50">
                  <i>Death Proof</i>
                  <div className="mb-1 small text-white-50" style={{fontSize: "0.8rem"}}>
                    <b>Written & Directed by</b>
                    <div key={`director-writer-1`}>{media.directors[1].name}{media.directors[1].death_date ? "†" : ""}</div>
                  </div>
                  <div className="mb-1 small text-white-50" style={{fontSize: "0.8rem"}}>
                    <b>Starring</b>
                    <div key={`cast-6`}>{media.cast_members[6].name}{media.cast_members[6].death_date ? "†" : ""}</div>
                    <div key={`cast-7`}>{media.cast_members[7].name}{media.cast_members[7].death_date ? "†" : ""}</div>
                    <div key={`cast-8`}>{media.cast_members[8].name}{media.cast_members[8].death_date ? "†" : ""}</div>
                    <div key={`cast-9`}>{media.cast_members[9].name}{media.cast_members[9].death_date ? "†" : ""}</div>
                    <div key={`cast-0`}>{media.cast_members[0].name}{media.cast_members[0].death_date ? "†" : ""}</div>
                    <div key={`cast-10`}>{media.cast_members[10].name}{media.cast_members[10].death_date ? "†" : ""}</div>
                    <div key={`cast-11`}>{media.cast_members[11].name}{media.cast_members[11].death_date ? "†" : ""}</div>
                    <div key={`cast-12`}>{media.cast_members[12].name}{media.cast_members[12].death_date ? "†" : ""}</div>
                    <div key={`cast-13`}>{media.cast_members[13].name}{media.cast_members[13].death_date ? "†" : ""}</div>
                  </div>
                </div>
              </>
          }
        </Card.Body>
        {isAdmin && (
          <Card.Footer className="text-end bg-transparent border-top-0">
            <Button variant="outline-light" size="sm" onClick={handleEditMediaClick}>
              Edit
            </Button>
          </Card.Footer>
        )}
      </Card>
      {!!user && <MediaForm show={showMediaModal} setShow={setShowMediaModal} media={media} />}
    </Col>
  );
}
  
export default MediaCard;