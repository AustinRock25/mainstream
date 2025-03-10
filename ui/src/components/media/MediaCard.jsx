import { Button, Card, Col, Image } from "react-bootstrap";
import MediaForm from "../modals/MediaForm";
import { useState } from "react";
import { useSelector } from "react-redux";

function MediaCard ({media}) {
  const { isAdmin } = useSelector(state => state.auth);
  const [showMediaModal, setShowMediaModal] = useState(false);

  function handleEditMediaClick() {
    setShowMediaModal(true);
  }

  const meaning = () => {
    if (media.score == 0)
      return "Awful";
    else if (media.score == 1)
      return "Bad";
    else if (media.score == 2)
      return "Mediocre";
    else if (media.score == 3)
      return "Decent";
    else if (media.score == 4)
      return "Good";
    else
      return "Great";
  }

  console.log(media);

  const directorNames = (media) => {
    let array = [];
    media.directors.sort((a, b) => a.ordering > b.ordering ? 1 : -1);
    for (let x = 0; x < media.directors.length; x++) {
      if (media.directors[x].death_year != null)
        array[x] = media.directors[x].name + "†";
      else
        array[x] = media.directors[x].name;
    }
    
    if (media.directors.length == 2)
      return array.join("\r\n𝐚𝐧𝐝 ");
    else if (media.directors.length >= 3)
      return array.slice(0, -1).join("\r\n") + "\r\n𝐚𝐧𝐝 " + array[array.length - 1];
    else
      return array[0];
  }

  const castNames = (media) => {
    let array = [];
    media.cast_members.sort((a, b) => a.ordering > b.ordering ? 1 : -1);
    for (let x = 0; x < media.cast_members.length; x++) {
      if (media.cast_members[x].death_year != null)
        array[x] = media.cast_members[x].name + "†";
      else
        array[x] = media.cast_members[x].name;
    }
    
    if (media.cast_members.length == 2)
      return array.join("\r\n𝐚𝐧𝐝 ");
    else if (media.cast_members.length >= 3)
      return array.slice(0, -1).join("\r\n") + "\r\n𝐚𝐧𝐝 " + array[array.length - 1];
    else
      return array[0];
  }

  const time = (media) => {
    let hours = Math.floor(media.runtime / 60);
    let minutes = media.runtime % 60;
  
    if (hours == 1)
      hours += " hour";
    else if (hours == 0)
      hours = "";
    else
      hours += " hours";
  
    if (minutes == 1)
      minutes += " minute";
    else if (minutes == 0)
      minutes = "";
    else
      minutes += " minutes";

    return hours + " " + minutes;
  }

  const getYear = (media) => {
    const date = new Date(media.release_date);
    return date.getFullYear();
  }

  return (
    <Col>
      <div className="border border-dark rounded m-1">
        <Card className="bg-secondary text-white">
          <Card.Header className="fw-bold">
            {media.title} ({getYear(media)})
            <Image src={`public/posters/${media.poster}_poster.jpg`} className="border border-dark" alt={`Poster for ${media.title}`} fluid></Image>
            {media.score == 0 && <span className="fs-3"><span className="fa fa-star unchecked"></span><span className="fa fa-star unchecked"></span><span className="fa fa-star unchecked"></span><span className="fa fa-star unchecked"></span><span className="fa fa-star unchecked"></span></span>}
            {media.score == 1 && <span className="fs-3"><span className="fa fa-star checked"></span><span className="fa fa-star unchecked"></span><span className="fa fa-star unchecked"></span><span className="fa fa-star unchecked"></span><span className="fa fa-star unchecked"></span></span>}
            {media.score == 2 && <span className="fs-3"><span className="fa fa-star checked"></span><span className="fa fa-star checked"></span><span className="fa fa-star unchecked"></span><span className="fa fa-star unchecked"></span><span className="fa fa-star unchecked"></span></span>}
            {media.score == 3 && <span className="fs-3"><span className="fa fa-star checked"></span><span className="fa fa-star checked"></span><span className="fa fa-star checked"></span><span className="fa fa-star unchecked"></span><span className="fa fa-star unchecked"></span></span>}
            {media.score == 4 && <span className="fs-3"><span className="fa fa-star checked"></span><span className="fa fa-star checked"></span><span className="fa fa-star checked"></span><span className="fa fa-star checked"></span><span className="fa fa-star unchecked"></span></span>}
            {media.score == 5 && <span className="fs-3"><span className="fa fa-star checked"></span><span className="fa fa-star checked"></span><span className="fa fa-star checked"></span><span className="fa fa-star checked"></span><span className="fa fa-star checked"></span></span>}
            <p className="fs-6">{meaning()}</p>
          </Card.Header>
          <Card.Body>
            {media.rating == "Not Rated" && <p className="fs-6">{media.rating}</p>}
            {media.rating != "Not Rated" && <p className="fs-6">Rated {media.rating}</p>}
            {media.type == "movie" && <p className="fs-6">Runtime: {time(media)}</p>}
            {media.type == "movie" && <p className="fs-6"><b>Directed by</b> <br />{directorNames(media)}</p>}
            <p className="fs-6"><b>Starring</b> <br />{castNames(media)}</p>
          </Card.Body>
          <Card.Footer>
            {isAdmin &&
              <Button variant="secondary" onClick={() => handleEditMediaClick()} className="me-1">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-pen" viewBox="0 0 16 16">
                  <path d="m13.498.795.149-.149a1.207 1.207 0 1 1 1.707 1.708l-.149.148a1.5 1.5 0 0 1-.059 2.059L4.854 14.854a.5.5 0 0 1-.233.131l-4 1a.5.5 0 0 1-.606-.606l1-4a.5.5 0 0 1 .131-.232l9.642-9.642a.5.5 0 0 0-.642.056L6.854 4.854a.5.5 0 1 1-.708-.708L9.44.854A1.5 1.5 0 0 1 11.5.796a1.5 1.5 0 0 1 1.998-.001m-.644.766a.5.5 0 0 0-.707 0L1.95 11.756l-.764 3.057 3.057-.764L14.44 3.854a.5.5 0 0 0 0-.708z" />
                </svg>
              </Button>
            }
          </Card.Footer>
        </Card>
        <MediaForm show={showMediaModal} setShow={setShowMediaModal} media={media} />
      </div>
    </Col>
  );
}

export default MediaCard;