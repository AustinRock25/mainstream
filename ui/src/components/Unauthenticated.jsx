import { Container } from "react-bootstrap";

const Unauthenticated = () => {
  return (
    <Container className="d-flex flex-column justify-content-center align-items-center text-center" style={{ minHeight: "60vh" }}>
      <h1 className="display-1 fw-bold text-warning">401</h1>
      <h3 className="fw-bolder text-white-50">Authentication Required</h3>
      <p className="lead text-muted mt-3">You need to log in to access this content.</p>
    </Container>
  );
}

export default Unauthenticated;