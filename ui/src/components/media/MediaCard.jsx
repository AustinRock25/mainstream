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

      const findMaxSeason = async () => {
        let currentSearch = 1;

        while (true) {
          const testPath = `posters/${media.poster}-season-${currentSearch}_poster.jpg`;
          const response = await fetch(testPath, { method: "HEAD" });
          
          if (response.ok)
            currentSearch++;
          else
            break;
        }
        
        setSeasonCount(currentSearch - 1);
      };

      findMaxSeason();
    }
  }, [media.id, media.type, media.poster]);

  const handleOpenModal = () => {
    setShowMediaModal(true);
  }

  const getPoster = (media) => {
    const wordsList = String(media.title).split(' ');
    const processedWords = [];
    const strictArticles = new Set(['The', 'A', 'An']);
    
    wordsList.forEach(word => {
      const wordCleaned = word.replace(/['’.]/g, '').replace(/[^a-zA-Z0-9½⅓àáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿÆŒ]/g, '');
      
      if (strictArticles.has(wordCleaned))
        return;
      
      processedWords.push(wordCleaned);
    });
    
    let finalTitleStr = processedWords.join(' ').replace(/&/g, 'and');
    let cleanTitle = finalTitleStr.trim().toLowerCase().replace(/[^a-z0-9½⅓àáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿæœ]/g, '_').replace(/_+/g, '_').replace(/^_+|_+$/g, '');
    
    return `${new Date(media.release_date || media.start_date).getUTCFullYear()}_${cleanTitle}.jpg`;
  }

  return (
    <Col>
      <Card>
        <Card.Img 
          variant="top" 
          src={media.type !== "show" ? `posters/${getPoster(media)}.jpg` : `posters/${getPoster(media)}_s${seasonCount}.jpg`}
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