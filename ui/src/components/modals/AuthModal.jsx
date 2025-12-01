import { Alert, Button, Form, Modal, Spinner } from "react-bootstrap";
import { authenticated, unauthenticated } from "../../slices/authSlice.js";
import axios from "axios";
import { useDispatch, useSelector } from "react-redux";
import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

function AuthModal({ show, setShow, action }) {
  const dispatch = useDispatch();
  const [errors, setErrors] = useState({});
  const [formData, setFormData] = useState({ email: "", password: "" });
  const [isLoading, setIsLoading] = useState(false);
  const navigate = useNavigate();
  const { user } = useSelector(state => state.auth);

  function handleSubmit(e) {
    e.preventDefault();
    setIsLoading(true);

    if (action === "login")
      login();
    else
      register();
  }

  function handleHide() {
    resetForm();
    setShow(false);
  }

  function resetForm() {
    setErrors({});
    setFormData({ email: "", password: "" });
  }

  function login() {
    axios.post("/api/auth/login", formData)
    .then(response => {
      dispatch(authenticated(response.data));
      handleHide();
      window.location.reload();
    })
    .catch(error => {
      dispatch(unauthenticated());
      if (error.response?.status === 422)
        setErrors(error.response.data.errors);
      else if (error.response?.status === 401)
        setErrors({ email: "Invalid email or password." });
      else if (error.response?.status === 404)
        setErrors({ email: "User not found." });
      else
        setErrors({ form: "An unexpected error occurred. Please try again later." });
    })
    .finally(() => {
      setIsLoading(false);
    });
  }

  function register() {
    axios.post("/api/auth/register", formData)
    .then(response => {
      dispatch(authenticated(response.data));
      handleHide();
      window.location.reload();
    })
    .catch(error => {
      dispatch(unauthenticated());
      if (error.response?.status === 422)
        setErrors(error.response.data.errors);
      else
        setErrors({ form: "An unexpected error occurred. Please try again later." });
    })
    .finally(() => {
      setIsLoading(false);
    });
  }

  return (
    <Modal show={show} onHide={handleHide} backdrop="static" centered>
      <Modal.Header>
        <Modal.Title>{action === "login" ? "Log In" : action === "register" ? "Register" : "Update"}</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Form onSubmit={handleSubmit}>
          {errors.form && <Alert variant="danger">{errors.form}</Alert>}
          {action !== "change" &&
            <Form.Group className="mb-3" controlId="formBasicEmail">
              <Form.Label>Email address</Form.Label>
              <Form.Control
                type="email"
                value={formData.email}
                isInvalid={!!errors.email}
                onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                placeholder="Enter email"
              />
              <Form.Control.Feedback type="invalid">{errors.email}</Form.Control.Feedback>
            </Form.Group>
          }
          {action !== "change" && 
            <Form.Group className="mb-3" controlId="formBasicPassword">
              <Form.Label>Password</Form.Label>
              <Form.Control
                type="password"
                value={formData.password}
                isInvalid={!!errors.password}
                onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                placeholder="Password"
              />
              <Form.Control.Feedback type="invalid">{errors.password}</Form.Control.Feedback>
            </Form.Group>
          }
          <div className="d-grid gap-2 mt-4">
            <Button variant="success" type="submit" disabled={isLoading}>
              {isLoading 
                ? 
                  <Spinner as="span" animation="border" size="sm" role="status" aria-hidden="true" /> 
                : 
                  (action === "login" 
                    ? 
                      "Log In" 
                    : 
                      action === "register" 
                        ?
                          "Register" 
                        : 
                          "Update"
                  )
              }
            </Button>
            <Button variant="secondary" onClick={handleHide}>Cancel</Button>
          </div>
        </Form>
      </Modal.Body>
    </Modal>
  );
}

export default AuthModal;