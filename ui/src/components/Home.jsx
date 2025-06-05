import { Container } from "react-bootstrap";

function Home() {
  return (
    <Container className="pt-3 text-center text-white bg-dark">
      <div className="m-1">
        Hello and welcome to my database, where I keep a list of all of the movies and TV shows that I have watched and I give them a rating that shows what I think about it. For shows, I will be rating individual seasons. If you don't see a certain movie or show in this database, that means I haven't seen/finished it yet and I will watch it soon, or that it doesn't fit my criteria, which are the following: a film has to have a runtime of 60 minutes or more, and each episode in a TV show has to have a runtime of 15 minutes or more with no segments.
      </div>
    </Container>
  );
}

export default Home;