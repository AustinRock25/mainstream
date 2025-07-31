import { Container } from "react-bootstrap";

function NotFound() {
  return (
    <Container className="d-flex flex-column justify-content-center align-items-center text-center" style={{ minHeight: "60vh" }}>
      <h1 className="display-1 fw-bold">404</h1>
      <h3 className="fw-bolder text-white-50">Oops! Page Not Found</h3>
      <p className="lead text-white-50 mt-3">
        It looks like the page you are looking for doesn't exist.
      </p>
    </Container>
  );
}

export default NotFound;