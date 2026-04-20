import api from "../../api";
import { Card, Col } from "react-bootstrap";
import MediaModal from "./MediaModal";
import { useEffect, useState } from "react";
import { useSelector } from "react-redux";

function MediaCard ({media}) {
  const { user } = useSelector(state => state.auth);
  const [seasonCount, setSeasonCount] = useState(0);
  const [showMediaModal, setShowMediaModal] = useState(false);

  useEffect(() => {
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
          src={media.type !== "show" ? `posters/${media.poster}_poster.jpg` : `posters/${media.poster}-season-${seasonCount}_poster.jpg`}
          className="rounded"
          alt={`Poster for ${media.title}`} 
          onClick={handleOpenModal}
          fluid
        />
      </Card>
      <MediaModal show={showMediaModal} setShow={setShowMediaModal} media={media} user={user} seasonCount={seasonCount} />
    </Col>
  );
}
  
export default MediaCard;