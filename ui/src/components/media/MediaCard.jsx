import api from "../../api";
import { Card, Col } from "react-bootstrap";
import MediaModal from "./MediaModal";
import { useEffect, useState } from "react";
import { useSelector } from "react-redux";

function MediaCard ({media}) {
  const { user } = useSelector(state => state.auth);
  const [seasonCount, setSeasonCount] = useState(0);
  const [maxYear, setMaxYear] = useState(media.start_date.getUTCFullYear() || 0);
  const [showMediaModal, setShowMediaModal] = useState(false);

  useEffect(() => {
    if (media.type === "show") {
      api.get("/media/seasons", { params: { id: media.id } })
      .then(response => {
        setSeasonCount(response.data[0].count);
      });

      const findMaxSeason = async () => {
        while (true) {
          let found = false;

          for (let d = maxYear; d <= new Date().getUTCFullYear(); d++) {
            const testPath = `posters/${d}_${getPoster(media)}_s${seasonCount}.jpg`;
            const response = await fetch(testPath, { method: "HEAD" });

            if (response.ok) {
              setMaxYear(d);
              found = true;
              break;
            }
          }
          
          if (found)
            setSeasonCount(seasonCount + 1);
          else
            break;
        }

        setSeasonCount(seasonCount - 1);
      };

      findMaxSeason();
    }
  }, [media.id, media.type, media.poster]);

  const handleOpenModal = () => {
    setShowMediaModal(true);
  }

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

  return (
    <Col>
      <Card>
        <Card.Img 
          variant="top" 
          src={media.type !== "show" ? `posters/${new Date(media.release_date).getUTCFullYear()}_${getPoster(media)}.jpg` : `posters/${maxYear}_${getPoster(media)}_s${seasonCount}.jpg`}
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