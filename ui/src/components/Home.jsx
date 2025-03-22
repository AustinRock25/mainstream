import { Container } from "react-bootstrap";

function Home() {
  return (
    <Container className="pt-3 text-center text-white bg-dark">
      <div className="m-1">
        Hello and welcome to my database, where I keep a list of all of the movies and TV shows that I have watched and I give them a rating that shows what I think about it. For shows, I won't be rating the individual seasons, but the entire series as a whole. It will be noted how many full seasons of the show I have watched. If you don't see a certain movie or show in this database, that means I haven't seen it yet and I will watch it soon, or that it doesn't fit my criteria, which are the following: a film has to have a runtime of 60 minutes or more, and an episode in a TV show has to have a runtime of 20 minutes or more. A film/show also can't be pornagraphy, a game show, or a video game.
      </div>
    </Container>
  );
}

export default Home;