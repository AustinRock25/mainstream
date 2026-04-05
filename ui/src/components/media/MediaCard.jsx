import api from "../../api";
import { Card, Col } from "react-bootstrap";
import MediaModal from "./MediaModal";
import { useEffect, useState } from "react";
import { useSelector } from "react-redux";

function MediaCard ({media}) {
  const { user } = useSelector(state => state.auth);
  const [pillColor, setPillColor] = useState("danger");
  const [pillTextColor, setPillTextColor] = useState("white");
  const [seasonCount, setSeasonCount] = useState(0);
  const [showMediaModal, setShowMediaModal] = useState(false);

  useEffect(() => {
    if (!media.grade)
      media.grade = media.grade_tv;

    if (media.grade <= 33.33) {
      setPillColor("danger");
      setPillTextColor("white");
    }
    else if (media.grade <= 66.67) {
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

  const handleOpenModal = () => {
    setShowMediaModal(true);
  }

  return (
    <Col>
      <Card>
        <Card.Img 
          variant="top" 
          src={media.type !== "show" ? `posters/${media.poster}_poster.jpg` : `posters/${media.poster}-season-${media.season}_poster.jpg`}
          alt={`Poster for ${media.title}`} 
          onClick={handleOpenModal}
          fluid
          rounded
        />
      </Card>
      <MediaModal show={showMediaModal} setShow={setShowMediaModal} media={media} user={user} seasonCount={seasonCount} pillColor={pillColor} pillTextColor={pillTextColor} />
    </Col>
  );
}
  
export default MediaCard;