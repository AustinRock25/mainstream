import { Alert, Button, Form, Modal, Spinner } from "react-bootstrap";
import axios from "axios";
import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

function PersonForm({ show, setShow, person }) {
  const [alert, setAlert] = useState({ message: "", variant: "" });
  const [errors, setErrors] = useState({ });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    id: "",
    name: "",
    birth_year: "",
    death_year: ""
  });

  useEffect(() => {
    if (person?.id) {
      setFormData({
        id: person.id || "",
        name: person.name || "",
        birth_year: person.birth_year || "",
        death_year: person.death_year || "",
      });
    }
  }, [person]);

  const handleChange = (e, key) => {
    setErrors({ ...errors, [key]: "" });
    setFormData({ ...formData, [key]: e.target.value });
  }

  function handleHide(e) {
    setShow(false);
    if (!person?.id)
      resetForm();
  }

  function resetForm() {
    setErrors({});
    setFormData({ id: "", name: "" });
    setAlert({ message: "", variant: "" });
  }

  function handleSubmit(e) {
    e.preventDefault();
    setIsSubmitting(true);
    
    const apiCall = person?.id ? axios.put(`/api/people/${person.id}`, formData) : axios.post("/api/people", formData);
    
    apiCall
      .then(response => {
        handleHide();
        navigate("/people", { state: { alert: { message: `Person successfully ${person?.id ? "updated" : "created"}.`, variant: "success" } } });
      })
      .catch(error => {
        if (error.response?.status === 422)
          setErrors(error.response.data.errors);

        if (error.response?.status === 401)
          setAlert({ message: `You must be logged in to ${person?.id ? "update" : "create"} a person.`, variant: "danger" });
        else if (error.response?.status === 403)
          setAlert({ message: `You do not have permission to ${person?.id ? "update this person" : "create person"}.`, variant: "danger" });
        else
          setAlert({ message: `Failed to ${person?.id ? "update" : "create" } person.`, variant: "danger" });
      })
      .finally(() => {
        setIsSubmitting(false);
      });
  }

  return (
    <Modal show={show} onHide={(e) => setShow(false)} backdrop="static">
      <Modal.Header className="bg-dark text-white">
        <Modal.Title>{person?.id ? `Edit ${person.name}` : "Add Person"}</Modal.Title>
      </Modal.Header>
      <Modal.Body className="bg-black text-white">
        {alert.message &&
          <Alert
            className="text-center"
            variant={alert.variant}
            onClose={() => setAlert({ message: "", variant: "" })}
            dismissible
          >
            {alert.message}
          </Alert>
        }

        <Form onSubmit={isSubmitting ? null : handleSubmit}>
          <Form.Group>
            <Form.Label className="mt-3">Name</Form.Label>
            <Form.Control
              type="text"
              value={formData.name}
              placeholder="Enter name"
              isInvalid={errors.name}
              onChange={(e) => handleChange(e, "name")}
            />
            <Form.Control.Feedback type="invalid">{errors.name}</Form.Control.Feedback>
            <Form.Label className="mt-3">Birth Year</Form.Label>
            <Form.Control
              type="number"
              value={formData.birth_year}
              placeholder="Enter Birth Year"
              isInvalid={errors.birth_year}
              onChange={(e) => handleChange(e, "birth_year")}
            />
            <Form.Control.Feedback type="invalid">{errors.birth_year}</Form.Control.Feedback>
            <Form.Label className="mt-3">Death Year</Form.Label>
            <Form.Control
              type="number"
              value={formData.death_year}
              placeholder="Enter Death Year"
              isInvalid={errors.death_year}
              onChange={(e) => handleChange(e, "death_year")}
            />
            <Form.Control.Feedback type="invalid">{errors.death_year}</Form.Control.Feedback>
          </Form.Group>
          <Form.Group className="mt-4">
            <Button id="form-submit-button" variant="warning" type="submit" className="me-2">{isSubmitting ? <Spinner /> : (person?.id ? "Update" : "Create")}</Button>
            <Button variant="secondary" type="button" onClick={handleHide}>Cancel</Button>
          </Form.Group>
        </Form>
      </Modal.Body>
    </Modal>
  );
}

export default PersonForm;