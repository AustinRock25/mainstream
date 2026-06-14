import api from "../api";
import { Container, Row } from "react-bootstrap";
import MediaCard from "./media/MediaCard";
import { useEffect, useState } from "react";

function Home() {
  const [newMedia, setNewMedia] = useState([]);
  const [totals, setTotals] = useState([]);

  useEffect(() => {
    api.get("/media/new")
    .then(response => {
      setNewMedia(response.data);
    })
  }, [newMedia]);

  useEffect(() => {
    api.get("/media/totals")
    .then(response => {
      setTotals(response.data[0]);
    })
  }, [totals]);

  const time = (runtime) => {
    if (!runtime) 
      return "";

    const centuries = Math.floor(runtime / 52560000);
    const years = Math.floor((runtime % 52560000) / 525960);
    const months = Math.floor((runtime % 525960) / 43800);
    const weeks = Math.floor((runtime % 43800) / 10080);
    const days = Math.floor((runtime % 10080) / 1440);
    const hours = Math.floor((runtime % 1440) / 60);
    const minutes = runtime % 60;
    let timeStr = "";

    if (centuries > 0) 
      timeStr += `${centuries}c `;
    
    if (years > 0) 
      timeStr += `${years}y `;
    
    if (months > 0) 
      timeStr += `${months}mo `;
    
    if (weeks > 0) 
      timeStr += `${weeks}w `;
    
    if (days > 0) 
      timeStr += `${days}d `;
    
    if (hours > 0) 
      timeStr += `${hours}h `;

    if (minutes > 0) 
      timeStr += `${minutes}min`;

    return timeStr.trim();
  }

  return (
    <Container className="pt-3 text-center">
      <h1 className="display-5 fw-bold">Welcome to The Mainstream</h1>
      <hr className="my-4" />
      <h3 className="fw-bold">There are currently {totals.total_titles} titles ({time(totals.total_runtime)} worth of content)</h3>
      <hr className="my-4" />
      <p className="lead mt-4 text-white-50">
        Hello and welcome to my database, where I keep a list of all of the movies and TV shows that I have watched and give them a rating that shows what I think about it. For shows, I will be rating individual seasons.
      </p>
      <hr className="my-4" />
      <p className="text-white-50 small">
        If you don't see a certain movie or show in this database, that means I haven't seen/finished it yet and I will watch it soon, or that it doesn't fit my criteria, which are the following: a film has to have a runtime of 60 minutes or more, and each episode in a TV show has to have a runtime of 15 minutes or more with no segments.
      </p>
      <p className="lead mt-4 text-white fw-bold">
        Recently Added Titles
      </p>
      <Row className="g-4 justify-content-center" xs={1} sm={2} md={3} lg={4} xl={5}>
        {Array.isArray(newMedia) && newMedia.map(n => <MediaCard key={`${n.id}-${n.type}`} media={n} />)}
      </Row>
    </Container>
  );
}

export default Home;