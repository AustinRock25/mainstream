import { Alert, Button, Form, Modal, Spinner } from "react-bootstrap";
import api from "../../api";
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
    birth_date: "",
    death_date: ""
  });

  useEffect(() => {
    if (person?.id) {
      const birthDate = person.birth_date ? new Date(person.birth_date).toISOString().split("T")[0] : "";
      const deathDate = person.death_date ? new Date(person.death_date).toISOString().split("T")[0] : "";
      
      setFormData({
        id: person.id,
        name: person.name || "",
        birth_date: birthDate,
        death_date: deathDate,
      });
    } 
    else
      resetForm();
  }, [person, show]);

  const handleChange = (e, key) => {
    setErrors({ ...errors, [key]: "" });
    setFormData({ ...formData, [key]: e.target.value });
  }

  function handleHide() {
    setShow(false);
    resetForm();
  }

  function resetForm() {
    setErrors({});
    setAlert({ message: "", variant: "" });
    setFormData({ id: "", name: "", birth_date: "", death_date: "" });
  }

  function handleSubmit(e) {
    e.preventDefault();
    setIsSubmitting(true);
    const apiCall = person?.id ? api.put(`/people/${person.id}`, formData) : api.post("/people", formData);
    
    apiCall
    .then(response => {
      handleHide();
      navigate("/people");
      window.location.reload();
    })
    .catch(error => {
      if (error.response?.status === 422)
        setErrors(error.response.data.errors);
      else if (error.response?.status === 401)
        setAlert({ message: `You must be logged in to ${person?.id ? "update" : "create"} a person.`, variant: "danger" });
      else if (error.response?.status === 403)
        setAlert({ message: `You do not have permission to ${person?.id ? "update this person" : "create a person"}.`, variant: "danger" });
      else
        setAlert({ message: `Failed to ${person?.id ? "update" : "create" } person.`, variant: "danger" });
    })
    .finally(() => {
      setIsSubmitting(false);
    });
  }

  return (
    <Modal show={show} onHide={handleHide} backdrop="static" centered>
      <Modal.Header>
        <Modal.Title>{person?.id ? `Edit ${person.name}` : "Add Cast/Crew Member"}</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        {alert.message &&
          <Alert
            variant={alert.variant}
            onClose={() => setAlert({ message: "", variant: "" })}
            dismissible
          >
            {alert.message}
          </Alert>
        }
        <Form onSubmit={handleSubmit}>
          <Form.Group className="mb-3">
            <Form.Label>Name</Form.Label>
            <Form.Control
              type="text"
              value={formData.name}
              placeholder="Enter full name"
              isInvalid={!!errors.name}
              onChange={(e) => handleChange(e, "name")}
            />
            <Form.Control.Feedback type="invalid">{errors.name}</Form.Control.Feedback>
          </Form.Group>
          <Form.Group className="mb-3">
            <Form.Label>Date of Birth</Form.Label>
            <Form.Control
              type="date"
              value={formData.birth_date}
              isInvalid={!!errors.birth_date}
              onChange={(e) => handleChange(e, "birth_date")}
            />
            <Form.Control.Feedback type="invalid">{errors.birth_date}</Form.Control.Feedback>
          </Form.Group>
          <Form.Group className="mb-3">
            <Form.Label>Date of Death</Form.Label>
            <Form.Control
              type="date"
              value={formData.death_date}
              isInvalid={!!errors.death_date}
              onChange={(e) => handleChange(e, "death_date")}
            />
            <Form.Control.Feedback type="invalid">{errors.death_date}</Form.Control.Feedback>
          </Form.Group>
          <div className="d-flex justify-content-end mt-4">
            <Button variant="secondary" type="button" onClick={handleHide} className="me-2">Cancel</Button>
            <Button variant="success" type="submit" disabled={isSubmitting}>
              {isSubmitting 
                ?
                  <Spinner as="span" size="sm" /> 
                : 
                  (person?.id 
                    ? 
                      "Update" 
                    : 
                      "Create"
                  )
              }
            </Button>
          </div>
        </Form>
      </Modal.Body>
    </Modal>
  );
}

export default PersonForm;