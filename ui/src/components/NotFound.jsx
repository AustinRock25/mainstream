import { Container } from "react-bootstrap";

function NotFound() {
  return (
    <Container className="pt-3 text-center text-white bg-dark">
      <h3 className="fw-bolder">Oops!</h3>
      <p className="fw-bold">It looks like the page you are looking for doesn't exist.</p>
    </Container>
  );
}

export default NotFound;