import api from "../../api";
import { Card, Col } from "react-bootstrap";
import MediaModal from "./MediaModal";
import { useEffect, useState } from "react";
import { useSelector } from "react-redux";

function MediaCard ({media}) {
  const { user } = useSelector(state => state.auth);
  const [seasonCount, setSeasonCount] = useState(0);
  const [maxYear, setMaxYear] = useState(0);
  const [showMediaModal, setShowMediaModal] = useState(false);

  useEffect(() => {
    if (media.type !== "show") return;

    const fetchAndFindMaxSeason = async () => {
      try {
        const response = await api.get("/media/seasons", { params: { id: media.id } });
        const startYear = new Date(media.start_date).getUTCFullYear();
        const endYear = new Date().getUTCFullYear();
        let currentSearchSeason = response.data[0].count;
        let currentMaxYear = startYear;

        while (true) {
          let found = false;

          for (let d = currentMaxYear; d <= endYear; d++) {
            const testPath = `posters/${d}_${getPoster(media)}_s${currentSearchSeason}.jpg`;
            const checkResponse = await fetch(testPath, { method: "HEAD" });

            if (checkResponse.ok) {
              currentMaxYear = d;
              found = true;
              break;
            }
          }
          
          if (found)
            currentSearchSeason++;
          else
            break;
        }

        setMaxYear(currentMaxYear);
        setSeasonCount(currentSearchSeason - 1);
      } 
      catch (error) {
        console.error("Error calculating maximum seasons and years:", error);
      }
    };

    fetchAndFindMaxSeason();
  }, [media.id, media.type, media.start_date, media.poster]);

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