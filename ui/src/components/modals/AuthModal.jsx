import { authenticated, unauthenticated } from "../../slices/authSlice.js";
import axios from "axios";
import { Button, Form, Modal, Spinner } from "react-bootstrap";
import { useDispatch } from "react-redux";
import { useState } from "react";

function AuthModal({ show, setShow, action }) {
  const dispatch = useDispatch();
  const [errors, setErrors] = useState({});
  const [formData, setFormData] = useState({ email: "", password: "" });
  const [isLoading, setIsLoading] = useState(false);

  function handleSubmit(e) {
    e.preventDefault();
    setIsLoading(true);

    if(action === "login")
      login();
    else if(action === "register")
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
        resetForm();
        handleHide();
      })
      .catch(error => {
        dispatch(unauthenticated());

        if (error.response.status === 422)
          setErrors(error.response.data.errors);
        else if (error.response.status === 401)
          setErrors({ email: "invalid email or password." });
        else if (error.response.status === 404)
          setErrors({ email: "user not found." });
        else
          setErrors({ email: "an error occurred. Please try again later." });
      })
      .finally(() => {
        setIsLoading(false);
      });
  }

  function register() {
    axios.post("/api/auth/register", formData)
      .then(response => {
        dispatch(authenticated(response.data));
        resetForm();
        handleHide();
      })
      .catch(error => {
        dispatch(unauthenticated());
        setErrors(error.response.data.errors);
      })
      .finally(() => {
        setIsLoading(false);
      });
  }

  return (
    <Modal show={show} onHide={() => setShow(false)} backdrop="static">
      <Modal.Header className="bg-dark text-white">
        <Modal.Title>{action === "login" ? "Log In" : "Register"}</Modal.Title>
      </Modal.Header>
      <Modal.Body className="bg-black text-white">
        <Form onSubmit={handleSubmit}>
          <Form.Label>Email</Form.Label>
          <Form.Control
            type="email"
            value={formData.email}
            isInvalid={errors.email}
            onChange={(e) => setFormData({ ...formData, email: e.target.value })}
          />
          <Form.Control.Feedback type="invalid">{errors.email}</Form.Control.Feedback>
          <Form.Label className="mt-3">Password</Form.Label>
          <Form.Control
            type="password"
            value={formData.password}
            isInvalid={errors.password}
            onChange={(e) => setFormData({ ...formData, password: e.target.value })}
          />
          <Form.Control.Feedback type="invalid">{errors.password}</Form.Control.Feedback>

          <div className="mt-3 text-end">
            <Button type="submit" id="form-submit-button" className="ms-2 me-1 btn btn-warning">{isLoading ? <Spinner /> : (action === "login" ? "Log In" : "Register")}</Button>
            <Button variant="secondary" onClick={handleHide}>Cancel</Button>
          </div>
        </Form>
      </Modal.Body>
    </Modal>
  );
}

export default AuthModal;