import { Container } from "react-bootstrap";

const Unauthorized = () => {
  return (
    <Container className="d-flex flex-column justify-content-center align-items-center text-center" style={{ minHeight: "60vh" }}>
      <h1 className="display-1 fw-bold text-danger">403</h1>
      <h3 className="fw-bolder text-white-50">Access Denied</h3>
      <p className="lead text-white-50 mt-3">You do not have permission to access this content.</p>
    </Container>
  );
}

export default Unauthorized;