import { Container } from "react-bootstrap";

const Unauthenticated = () => {
  return (
    <Container className="pt-3 text-center text-white bg-dark">
      <h3 className="fw-bolder">Error</h3>
      <p className="fw-bold">You need to log in to access this conent.</p>
    </Container>
  );
}

export default Unauthenticated;