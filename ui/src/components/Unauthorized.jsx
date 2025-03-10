import { Container } from "react-bootstrap";

const Unauthorized = () => {
  return (
    <Container className="pt-3 text-center text-white bg-dark">
      <h3 className="fw-bolder">Error</h3>
      <p className="fw-bold">You do not have permission to access this content.</p>
    </Container>
  );
}

export default Unauthorized;