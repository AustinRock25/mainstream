import axios from "axios";
import { Button, Card, Col, Badge, Stack } from "react-bootstrap";
import MediaForm from "../modals/MediaForm";
import { useEffect, useState } from "react";
import { useSelector } from "react-redux";

function MediaCard ({media}) {
  const { isAdmin, user } = useSelector(state => state.auth);
  const [seasonCount, setSeasonCount] = useState(0);
  const [showMediaModal, setShowMediaModal] = useState(false);

  function handleEditMediaClick() {
    setShowMediaModal(true);
  }

  useEffect(() => {
    if (media.type === 'show') {
      axios.get("/api/media/seasons", { params: { id: media.id } })
      .then(response => {
        setSeasonCount(response.data[0].count);
      })
      .catch(error => {
      });
    }
  }, [media.id, media.type]);

  const getNames = (people) => {
    if (!people || people.length === 0)
      return [];

    people.sort((a, b) => (a.ordering > b.ordering ? 1 : -1));
    return people.map(p => `${p.name}${p.death_date ? '†' : ''}`);
  };

  const combineDirectorsAndWriters = (media) => {
    const directorIds = (media.directors || media.directors_tv || []).map(d => d.director_id).sort().join(',');
    const writerIds = (media.writers || media.writers_tv || []).map(w => w.writer_id).sort().join(',');
    return directorIds && writerIds && directorIds === writerIds;
  };
  
  const directors = getNames(media.directors || media.directors_tv);
  const writers = getNames(media.writers || media.writers_tv);
  const creators = getNames(media.creators);
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
    if (startYear === endYear) return startYear;
    return `${startYear}–${String(endYear).slice(-2)}`;
  };
  
  const getTitle = (media) => {
    if (media.type === "movie")
        return `(${new Date(media.release_date).getFullYear()})`;

    if (media.type === "show") {
      if (seasonCount === 1 && media.completed)
        return `(${getYearRange(media.start_date, media.end_date)})`;

      return `Season ${media.season} (${getYearRange(media.start_date, media.end_date)})`;
    }

    return '';
  };

  const getGrade = (media) => {
    if (!media.grade)
      media.grade = media.grade_tv;

    if (user.rating_scale == 1) {
      if (media.grade <= 11)
        return "0/4";
      else if (media.grade <= 22)
        return "0.5/4";
      else if (media.grade <= 33)
        return "1/4";
      else if (media.grade <= 44)
        return "1.5/4";
      else if (media.grade <= 55)
        return "2/4";
      else if (media.grade <= 66)
        return "2.5/4";
      else if (media.grade <= 77)
        return "3/4";
      else if (media.grade <= 88)
        return "3.5/4";
      else
        return "4/4";
    }
    else if (user.rating_scale == 2) {
      if (media.grade <= 9)
        return "0/5";
      else if (media.grade <= 18)
        return "0.5/5";
      else if (media.grade <= 27)
        return "1/5";
      else if (media.grade <= 36)
        return "1.5/5";
      else if (media.grade <= 45)
        return "2/5";
      else if (media.grade <= 54)
        return "2.5/5";
      else if (media.grade <= 63)
        return "3/5";
      else if (media.grade <= 72)
        return "3.5/5";
      else if (media.grade <= 81)
        return "4/5";
      else if (media.grade <= 90)
        return "4.5/5";
      else
        return "5/5";
    }
    else if (user.rating_scale == 3) {
      if (media.grade <= 19)
        return "F";
      else if (media.grade <= 26)
        return "D-";
      else if (media.grade <= 32)
        return "D";
      else if (media.grade <= 39)
        return "D+";
      else if (media.grade <= 46)
        return "C-";
      else if (media.grade <= 52)
        return "C";
      else if (media.grade <= 59)
        return "C+";
      else if (media.grade <= 66)
        return "B-";
      else if (media.grade <= 72)
        return "B";
      else if (media.grade <= 79)
        return "B+";
      else if (media.grade <= 86)
        return "A-";
      else if (media.grade <= 92)
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
          src={media.type === 'movie' ? `posters/${media.poster}_poster.jpg` : `posters/${media.poster}-season-${media.season}_poster.jpg`}
          alt={`Poster for ${media.title}`} 
          fluid
        />
        <Card.Body className="d-flex flex-column">
          <Card.Title className="h6">
            <span className="fw-normal text-white-50"><i>{media.title}</i> {getTitle(media)}</span>
          </Card.Title>
          
          <Stack direction="horizontal" gap={2} className="mt-2 mb-3">
            <Badge bg="success" pill>{getGrade(media)}</Badge>
            <Badge bg="secondary" pill>{media.rating}</Badge>
            {media.type === 'movie' && <Badge bg="dark" pill>{time(media.runtime)}</Badge>}
            {media.type === 'show' && <Badge bg="dark" pill>{media.episodes} eps</Badge>}
          </Stack>

          <div className="small text-white-50" style={{fontSize: '0.8rem'}}>
            {creators.length > 0 && (
              <div className="mb-1">
                <b>Created by</b>
                {creators.map((name, index) => <div key={`creator-${index}`}>{name}</div>)}
              </div>
            )}
            {isCombined && (
              <div className="mb-1">
                <b>Written & Directed by</b>
                {directors.map((name, index) => <div key={`director-writer-${index}`}>{name}</div>)}
              </div>
            )}
            {!isCombined && directors.length > 0 && (
              <div className="mb-1">
                <b>Directed by</b>
                {directors.map((name, index) => <div key={`director-${index}`}>{name}</div>)}
              </div>
            )}
            {!isCombined && writers.length > 0 && (
              <div className="mb-1">
                <b>Written by</b>
                {writers.map((name, index) => <div key={`writer-${index}`}>{name}</div>)}
              </div>
            )}
            {cast.length > 0 && (
              <div className="mb-1">
                <b>Starring</b>
                {cast.map((name, index) => <div key={`cast-${index}`}>{name}</div>)}
              </div>
            )}
          </div>

        </Card.Body>
        {isAdmin && (
          <Card.Footer className="text-end bg-transparent border-top-0">
            <Button variant="outline-light" size="sm" onClick={handleEditMediaClick}>
              Edit
            </Button>
          </Card.Footer>
        )}
      </Card>
      <MediaForm show={showMediaModal} setShow={setShowMediaModal} media={media} />
    </Col>
  );
}
  
export default MediaCard;