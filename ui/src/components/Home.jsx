import { Container, Col } from "react-bootstrap";

function Home() {
  return (
    <Container className="py-5 text-center">
      <Col lg={8} className="mx-auto">
        <h1 className="display-5 fw-bold">Welcome to The Mainstream</h1>
        <p className="lead mt-4 text-white-50">
          Hello and welcome to my database, where I keep a list of all of the movies and TV shows that I have watched and give them a rating that shows what I think about it. For shows, I will be rating individual seasons.
        </p>
        <hr className="my-4" />
        <p className="text-white-50 small">
          If you don't see a certain movie or show in this database, that means I haven't seen/finished it yet and I will watch it soon, or that it doesn't fit my criteria, which are the following: a film has to have a runtime of 60 minutes or more, and each episode in a TV show has to have a runtime of 15 minutes or more with no segments.
        </p>
      </Col>
    </Container>
  );
}

export default Home;