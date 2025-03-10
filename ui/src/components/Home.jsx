import { Container } from "react-bootstrap";

function Home() {
  return (
    <Container className="pt-3 text-center text-white bg-dark">
      <div className="m-1">
        Hello and welcome to my database, where I keep a list of all of the movies and TV shows that I have watched and I give them a rating
        that shows what I think about it. The buttons will lead you to that film/series' IMDb page for you learn more about them. If you don't
        see a certain movie or show in this database, that means I haven't seen it yet and I will watch it soon, or that it doesn't fit my
        criteria, which are the following: a film has to have a runtime of 60 minutes or more, and an episode in a TV show has to have a
        runtime of 20 minutes or more. A film/show also can't be pornagraphy, a game show, or a video game.
      </div>
    </Container>
  );
}

export default Home;