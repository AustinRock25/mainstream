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
    birth_date: "",
    death_date: ""
  });

  useEffect(() => {
    if (person?.id) {
      let formattedBirthDate = "";
      let formattedDeathDate = "";
      if (person.birth_date != null) {
        const birthDateObject = new Date(person.birth_date);
        formattedBirthDate = birthDateObject.toISOString().split("T")[0];
      }
      if (person.death_date != null) {
        const deathDateObject = new Date(person.death_date);
        formattedDeathDate = deathDateObject.toISOString().split("T")[0];
      }
      setFormData({
        id: person.id || "",
        name: person.name || "",
        birth_date: formattedBirthDate || "",
        death_date: formattedDeathDate || "",
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
    setFormData({ id: "", name: "", birth_date: "", death_date: "" });
    setAlert({ message: "", variant: "" });
  }

  function handleSubmit(e) {
    e.preventDefault();
    setIsSubmitting(true);
    
    const apiCall = person?.id ? axios.put(`/api/people/${person.id}`, formData) : axios.post("/api/people", formData);
    
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
            <Form.Label className="mt-3">Date of Birth</Form.Label>
            <Form.Control
              type="date"
              value={formData.birth_date}
              placeholder="Enter date of birth"
              isInvalid={errors.birth_date}
              onChange={(e) => handleChange(e, "birth_date")}
            />
            <Form.Control.Feedback type="invalid">{errors.birth_date}</Form.Control.Feedback>
            <Form.Label className="mt-3">Date of Death</Form.Label>
            <Form.Control
              type="date"
              value={formData.death_date}
              placeholder="Enter date of death"
              isInvalid={errors.death_date}
              onChange={(e) => handleChange(e, "death_date")}
            />
            <Form.Control.Feedback type="invalid">{errors.death_date}</Form.Control.Feedback>
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