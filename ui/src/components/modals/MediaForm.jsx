import { Alert, Button, Form, Modal, Spinner, Col, Row, ListGroup, Badge } from "react-bootstrap";
import axios from "axios";
import { useCallback, useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { useSelector } from "react-redux";

function MediaForm({ show, setShow, media }) {
  const [alert, setAlert] = useState({ message: "", variant: "" });
  const [castAndCrew, setCastAndCrew] = useState([]);
  const [errors, setErrors] = useState({});
  const [isLoading, setIsLoading] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const navigate = useNavigate();
  const [pillColor, setPillColor] = useState("danger");
  const [pillText, setPillText] = useState("text-white");
  const [searchTerm, setSearchTerm] = useState("");
  const [selected, setSelected] = useState([]);
  const [shows, setShows] = useState([]);
  const { user } = useSelector(state => state.auth);

  const initialFormData = {
    id: "",
    title: "",
    season: "",
    grade: 0,
    rating: "Not Rated",
    release_date: "",
    start_date: "",
    end_date: "",
    poster: "",
    runtime: "",
    episodes: "",
    type: "",
    completed: false,
    castAndCrew: []
  };
  const [formData, setFormData] = useState(initialFormData);

  const getSortedCredits = (person) => {
    let allCredits = [];
    const creditTypes = [
        "credited_as_director", "credited_as_director_tv",
        "credited_as_writer", "credited_as_writer_tv",
        "credited_as_cast_member", "credited_as_cast_member_tv"
    ];

    creditTypes.forEach(type => {
      if (person[type] && Array.isArray(person[type]))
        allCredits.push(...person[type]);
    });

    allCredits.sort((a, b) => {
      const dateA = new Date(a.release_date || a.start_date);
      const dateB = new Date(b.release_date || b.start_date);

      if (isNaN(dateA.getTime())) 
        return 1;

      if (isNaN(dateB.getTime())) 
        return -1;

      return dateA.getTime() - dateB.getTime();
    });
    return allCredits;
  };

  const filterPeopleByDate = useCallback((people) => {
    const mediaDateStr = formData.release_date || formData.start_date;

    if (!mediaDateStr)
      return people;

    const mediaDate = new Date(mediaDateStr);

    if (isNaN(mediaDate.getTime()))
      return people;

    return people.filter(person => {
      const sortedCredits = getSortedCredits(person);

      if (sortedCredits.length === 0)
        return true;

      const firstCredit = sortedCredits[0];
      const firstCreditDate = new Date(firstCredit.release_date || firstCredit.start_date);

      if (isNaN(firstCreditDate.getTime()))
        return true;
        
      if (person.death_date) {
        const deathDate = new Date(person.death_date);
        const limitDate = new Date(deathDate);
        limitDate.setFullYear(limitDate.getFullYear() + 3);

        if (mediaDate > limitDate)
          return false;
      }

      if (person.birth_date) {
        const birthDate = new Date(person.birth_date);

        if (isNaN(birthDate.getTime())) 
          return true;

        const avgTimestamp = (birthDate.getTime() + firstCreditDate.getTime()) / 2;
        const avgDate = new Date(avgTimestamp);

        if (mediaDate <= avgDate)
          return false;
      } 
      else {
        const limitDate = new Date(firstCreditDate);
        limitDate.setFullYear(limitDate.getFullYear() - 10);

        if (mediaDate <= limitDate)
          return false;
      }

      return true;
    });
  }, [formData.release_date, formData.start_date]);


  const loadExistingData = useCallback(() => {
    if (media?.id) {
      let cast = [];
      let grade = null;
      const peopleMap = new Map();
      const addPerson = (p, role) => {
        if (!p)
          return;

        const personId = p.actor_id || p.writer_id || p.director_id;

        if (!peopleMap.has(personId))
          peopleMap.set(personId, { id: personId, name: p.name, director: false, writer: false, cast: false });
        
        if (role)
          peopleMap.get(personId)[role] = true;
      };
      (media.directors || media.directors_tv || []).forEach(p => addPerson(p, "director"));
      (media.writers || media.writers_tv || []).forEach(p => addPerson(p, "writer"));
      (media.cast_members || media.cast_members_tv || []).forEach(p => addPerson(p, "cast"));
      cast = Array.from(peopleMap.values());

      if (!media.grade && !media.grade_tv) {
        media.grade = 0;
        media.grade_tv = 0;
      }

      if (!media.runtime && !media.runtime_tv) {
        media.runtime = 0;
        media.runtime_tv = 0;
      }

      if (!media.grade)
        media.grade = media.grade_tv;

      if (!media.runtime)
        media.runtime = media.runtime_tv

      if (user.rating_scale == 1) {
        if (media.grade < 6.25)
          grade = 0;
        else if (media.grade < 18.75)
          grade = 0.5;
        else if (media.grade < 31.25)
          grade = 1;
        else if (media.grade < 43.75)
          grade = 1.5;
        else if (media.grade < 56.25)
          grade = 2;
        else if (media.grade < 68.75)
          grade = 2.5;
        else if (media.grade < 81.25)
          grade = 3;
        else if (media.grade < 93.75)
          grade = 3.5;
        else
          grade = 4;

        if (grade <= 1.5) {
          setPillColor("danger");
          setPillText("text-white");
        }
        else if (grade == 2) {
          setPillColor("warning");
          setPillText("text-black");
        }
        else {
          setPillColor("success");
          setPillText("text-white");
        }
      }
      else if (user.rating_scale == 2) {
        if (media.grade < 5)
          grade = 0;
        else if (media.grade < 15)
          grade = 0.5;
        else if (media.grade < 25)
          grade = 1;
        else if (media.grade < 35)
          grade = 1.5;
        else if (media.grade < 45)
          grade = 2;
        else if (media.grade < 55)
          grade = 2.5;
        else if (media.grade < 65)
          grade = 3;
        else if (media.grade < 75)
          grade = 3.5;
        else if (media.grade < 85)
          grade = 4;
        else if (media.grade < 95)
          grade = 4.5;
        else
          grade = 5;

        if (grade <= 1.5) {
          setPillColor("danger");
          setPillText("text-white");
        }
        else if (grade <= 3) {
          setPillColor("warning");
          setPillText("text-black");
        }
        else {
          setPillColor("success");
          setPillText("text-white");
        }
      }
      else if (user.rating_scale == 3) {
        if (media.grade <= ((59 * 2) - 100))
          grade = 0;
        else if (media.grade <= ((62 * 2) - 100))
          grade = 1;
        else if (media.grade <= ((66 * 2) - 100))
          grade = 2;
        else if (media.grade <= ((69 * 2) - 100))
          grade = 3;
        else if (media.grade <= ((72 * 2) - 100))
          grade = 4;
        else if (media.grade <= ((76 * 2) - 100))
          grade = 5;
        else if (media.grade <= ((79 * 2) - 100))
          grade = 6;
        else if (media.grade <= ((82 * 2) - 100))
          grade = 7;
        else if (media.grade <= ((86 * 2) - 100))
          grade = 8;
        else if (media.grade <= ((89 * 2) - 100))
          grade = 9;
        else if (media.grade <= ((92 * 2) - 100))
          grade = 10;
        else if (media.grade <= ((96 * 2) - 100))
          grade = 11;
        else
          grade = 12;

        if (grade <= 3) {
          setPillColor("danger");
          setPillText("text-white");
        }
        else if (grade <= 6) {
          setPillColor("warning");
          setPillText("text-black");
        }
        else {
          setPillColor("success");
          setPillText("text-white");
        }
      }
      else {
        if (media.grade <= 10)
          grade = 0;
        else if (media.grade <= 20)
          grade = 1;
        else if (media.grade <= 30)
          grade = 2;
        else if (media.grade <= 40)
          grade = 3;
        else if (media.grade <= 50)
          grade = 4;
        else if (media.grade <= 60)
          grade = 5;
        else if (media.grade <= 70)
          grade = 6;
        else if (media.grade <= 80)
          grade = 7;
        else if (media.grade <= 90)
          grade = 8;
        else
          grade = 9;

        setPillColor("primary");
        setPillText("text-white");
      }

      setFormData({
        id: media.id || "",
        title: media.title || "",
        season: media.season || "",
        grade: grade || 0,
        rating: media.rating || "Not Rated",
        release_date: media.release_date ? new Date(media.release_date).toISOString().split("T")[0] : "",
        start_date: media.start_date ? new Date(media.start_date).toISOString().split("T")[0] : "",
        end_date: media.end_date ? new Date(media.end_date).toISOString().split("T")[0] : "",
        poster: media.poster || "",
        runtime: media.runtime || "",
        episodes: media.episodes || "",
        completed: media.completed || false,
        type: media.type || ""
      });
      setSelected(cast);
    }
    else {
      setFormData(initialFormData);
      setSelected([]);
    }
  }, [media]);

  useEffect(() => {
    loadExistingData();
    if (show) {
      axios.get("/api/media/shows")
      .then(response =>
        setShows(response.data)
      )
      .catch(error =>
        setAlert({ message: "Failed to get shows", variant: "danger" })
      );
    }
  }, [media, show, loadExistingData]);

  const fetchPeople = useCallback(() => {
    if (!searchTerm) {
      setCastAndCrew([]);
      return;
    }

    setIsLoading(true);
    axios.get("/api/people/select", { params: { searchTerm } })
    .then(response => {
      const selectedIds = new Set(selected.map(s => s.id));
      const initialResults = response.data.filter(p => !selectedIds.has(p.id));
      const filteredResults = filterPeopleByDate(initialResults);
      setCastAndCrew(filteredResults);
    })
    .catch(error =>
      setAlert({ message: "Failed to load people", variant: "danger" })
    )
    .finally(() =>
      setIsLoading(false)
    );
  }, [searchTerm, selected, filterPeopleByDate]);

  const handleChange = (e, key) => {
    const { value, type, checked } = e.target;
    setErrors({ ...errors, [key]: "" });
    let newValue = type === "checkbox" ? checked : value;

    setFormData({ ...formData, [key]: newValue });

    if (key === "type") {
      setFormData({ ...initialFormData, type: value });
      setSelected([]);
    }

    if (key === "grade" && ((user.rating_scale == 1 && newValue <= 1.5) || (user.rating_scale == 2 && newValue <= 1.5) || (user.rating_scale == 3 && newValue <= 3) || (user.rating_scale == 4 && newValue <= 2))) {
      setPillColor("danger");
      setPillText("text-white");
    }
    else if (key === "grade" && ((user.rating_scale == 1 && newValue == 2) || (user.rating_scale == 2 && newValue <= 3) || (user.rating_scale == 3 && newValue <= 6) || (user.rating_scale == 4 && newValue <= 5))) {
      setPillColor("warning");
      setPillText("text-black");
    }
    else if (key === "grade" && user.rating_scale != 4) {
      setPillColor("success");
      setPillText("text-white");
    }
    else if (key === "grade") {
      setPillColor("primary");
      setPillText("text-white");
    }
  };

  const handleSelectPerson = (person) => {
    setSelected([...selected, { ...person, director: false, writer: false, cast: false }]);
    setCastAndCrew(castAndCrew.filter(p => p.id !== person.id));
  };

  const handleRemovePerson = (person) => {
    setSelected(selected.filter(p => p.id !== person.id));
  };

  const handleRoleChange = (personId, role, isChecked) => {
    setSelected(selected.map(p => p.id === personId ? { ...p, [role]: isChecked } : p));
  };

  function handleHide() {
    setShow(false);
    setErrors({});
    setSearchTerm("");
    setCastAndCrew([]);
    setAlert({ message: "", variant: "" });
  }

  const getGrade = (grade) => {
    if (user.rating_scale == 1)
      return grade + "/4";
    else if (user.rating_scale == 2)
      return grade + "/5";
    else if (user.rating_scale == 3) {
      if (grade == 0)
        return "F";
      else if (grade == 1)
        return "D-";
      else if (grade == 2)
        return "D";
      else if (grade == 3)
        return "D+";
      else if (grade == 4)
        return "C-";
      else if (grade == 5)
        return "C";
      else if (grade == 6)
        return "C+";
      else if (grade == 7)
        return "B-";
      else if (grade == 8)
        return "B";
      else if (grade == 9)
        return "B+";
      else if (grade == 10)
        return "A-";
      else if (grade == 11)
        return "A";
      else
        return "A+";
    }
    else {
      return (parseInt(grade) + 1) + "/10"
    }
  }

  function handleSubmit(e) {
    e.preventDefault();
    setIsSubmitting(true);

    if (user.rating_scale == 1)
      formData.grade = (formData.grade / 4) * 100;
    else if (user.rating_scale == 2)
      formData.grade = (formData.grade / 5) * 100;
    else if (user.rating_scale == 3) {
      if (formData.grade == 0)
        formData.grade = 0;
      else if (formData.grade == 1)
        formData.grade = 22.5;
      else if (formData.grade == 2)
        formData.grade = 27.5;
      else if (formData.grade == 3)
        formData.grade = 33.75;
      else if (formData.grade == 4)
        formData.grade = 38.75;
      else if (formData.grade == 5)
        formData.grade = 50;
      else if (formData.grade == 6)
        formData.grade = 55;
      else if (formData.grade == 7)
        formData.grade = 61.25;
      else if (formData.grade == 8)
        formData.grade = 66.25;
      else if (formData.grade == 9)
        formData.grade = 77.5;
      else if (formData.grade == 10)
        formData.grade = 83.75;
      else if (formData.grade == 11)
        formData.grade = 88.75;
      else
        formData.grade = 100;
    }
    else {
      if (formData.grade == 0)
        formData.grade = 0;
      else if (formData.grade == 1)
        formData.grade = 16.25;
      else if (formData.grade == 2)
        formData.grade = 27.5;
      else if (formData.grade == 3)
        formData.grade = 38.75;
      else if (formData.grade == 4)
        formData.grade = 50;
      else if (formData.grade == 5)
        formData.grade = 55;
      else if (formData.grade == 6)
        formData.grade = 66.25;
      else if (formData.grade == 7)
        formData.grade = 77.5;
      else if (formData.grade == 8)
        formData.grade = 88.75;
      else
        formData.grade = 100;
    }

    const payload = { ...formData, castAndCrew: selected };
    const apiCall = media?.id ? axios.put(`/api/media/${media.id}`, [payload, media]) : axios.post("/api/media", payload);

    apiCall
    .then(() => {
      handleHide();
      navigate("/media");
      window.location.reload();
    })
    .catch(error => {
      if (error.response?.status === 422)
        setErrors(error.response.data.errors);
      else
        setAlert({ message: `Failed to ${media?.id ? "update" : "create"} media.`, variant: "danger" });
    })
    .finally(() =>
      setIsSubmitting(false)
    );
  }

  return (
    <Modal show={show} onHide={handleHide} backdrop="static" size="lg" centered>
      <Modal.Header>
        <Modal.Title>{media?.id ? `Edit ${media.title}` : "Add Film/Show"}</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        {alert.message && <Alert variant={alert.variant} onClose={() => setAlert({})} dismissible>{alert.message}</Alert>}

        <Form onSubmit={handleSubmit}>
          {!media && (
            <Form.Group as={Row} className="mb-3">
              <Form.Label column sm={3}>Type</Form.Label>
              <Col sm={9}>
                <Form.Select value={formData.type} isInvalid={!!errors.type} onChange={e => handleChange(e, "type")}>
                  <option value="">Select type</option>
                  <option value="movie">Movie</option>
                  <option value="show">TV Show</option>
                </Form.Select>
                <Form.Control.Feedback type="invalid">{errors.type}</Form.Control.Feedback>
              </Col>
            </Form.Group>
          )}

          {formData.type === "show" && !media?.id && (
            <Form.Group as={Row} className="mb-3">
              <Form.Label column sm={3}>Show</Form.Label>
              <Col sm={9}>
                <Form.Select value={formData.id} isInvalid={!!errors.id} onChange={(e) => handleChange(e, "id")}>
                  <option value="">Select existing show for new season</option>
                  {shows.map(s => <option key={s.id} value={s.id}>{s.title} ({new Date(s.start_date).getFullYear()})</option>)}
                  <option value="na">Create a new show</option>
                </Form.Select>
              </Col>
            </Form.Group>
          )}

          {(formData.type === "movie" || formData.id === "na" || media?.id) && (
            <Form.Group as={Row} className="mb-3">
              <Form.Label column sm={3}>Title</Form.Label>
              <Col sm={9}><Form.Control type="text" value={formData.title} placeholder="Enter title" isInvalid={!!errors.title} onChange={e => handleChange(e, "title")} /></Col>
            </Form.Group>
          )}

          {formData.type === "show" && (
            <>
              <Form.Group as={Row} className="mb-3">
                <Form.Label column sm={3}>Episodes</Form.Label>
                <Col sm={9}><Form.Control type="number" value={formData.episodes} placeholder="Number of episodes" isInvalid={!!errors.episodes} onChange={e => handleChange(e, "episodes")} /></Col>
              </Form.Group>
              <Form.Group as={Row} className="mb-3">
                <Form.Label column sm={3}>Date Range</Form.Label>
                <Col sm={4}><Form.Control type="date" value={formData.start_date} isInvalid={!!errors.start_date} onChange={e => handleChange(e, "start_date")} /></Col>
                <Col sm={1} className="text-center align-self-center">-</Col>
                <Col sm={4}><Form.Control type="date" value={formData.end_date} isInvalid={!!errors.end_date} onChange={e => handleChange(e, "end_date")} /></Col>
              </Form.Group>
              <Form.Group as={Row} className="mb-3">
                <Form.Label column sm={3}>Series Status</Form.Label>
                <Col sm={9}><Form.Check type="switch" label="Series is completed" checked={formData.completed} onChange={e => handleChange(e, "completed")} /></Col>
              </Form.Group>
            </>
          )}

          {formData.type === "movie" && (
            <Form.Group as={Row} className="mb-3">
              <Form.Label column sm={3}>Release Date</Form.Label>
              <Col sm={9}><Form.Control type="date" value={formData.release_date} isInvalid={!!errors.release_date} onChange={e => handleChange(e, "release_date")} /></Col>
            </Form.Group>
          )}

          <Form.Group as={Row} className="mb-3">
            <Form.Label column sm={3}>Runtime (mins)</Form.Label>
            <Col sm={9}><Form.Control type="number" value={formData.runtime} placeholder="e.g., 120" isInvalid={!!errors.runtime} onChange={e => handleChange(e, "runtime")} /></Col>
          </Form.Group>

          {formData.type && (
            <>
              <hr/>
                <Form.Group as={Row} className="mb-3">
                  <Form.Label column sm={3}>Grade: <Badge bg={pillColor} className={pillText}>{getGrade(formData.grade)}</Badge></Form.Label>
                  {user.rating_scale == 1 && <Col sm={9}><Form.Range min="0" max="4" step="0.5" value={formData.grade} onChange={(e) => handleChange(e, "grade")} /></Col>}
                  {user.rating_scale == 2 && <Col sm={9}><Form.Range min="0" max="5" step="0.5" value={formData.grade} onChange={(e) => handleChange(e, "grade")} /></Col>}
                  {user.rating_scale == 3 && <Col sm={9}><Form.Range min="0" max="12" step="1" value={formData.grade} onChange={(e) => handleChange(e, "grade")} /></Col>}
                  {user.rating_scale == 4 && <Col sm={9}><Form.Range min="0" max="9" step="1" value={formData.grade} onChange={(e) => handleChange(e, "grade")} /></Col>}
                </Form.Group>
                {(formData.type === "movie" || formData.id == "na" || media?.id) && (
                  <>
                    <Form.Group as={Row} className="mb-3">
                      <Form.Label column sm={3}>Poster File</Form.Label>
                      <Col sm={9}><Form.Control type="text" value={formData.poster} placeholder="e.g., tenet_2020" isInvalid={!!errors.poster} onChange={e => handleChange(e, "poster")} /></Col>
                    </Form.Group>
                    <Form.Group as={Row} className="mb-3">
                      <Form.Label column sm={3}>Rating</Form.Label>
                      <Col sm={9}>
                        <Form.Select value={formData.rating} isInvalid={!!errors.rating} onChange={(e) => handleChange(e, "rating")}>
                          {formData.type !== "movie" ? ["Not Rated", "TV-Y", "TV-Y7", "TV-Y7 FV", "TV-G", "TV-PG", "TV-14", "TV-MA"].map(r => <option key={r} value={r}>{r}</option>) : ["Not Rated", "G", "PG", "PG-13", "R", "NC-17", "TV-Y", "TV-Y7", "TV-Y7 FV", "TV-G", "TV-PG", "TV-14", "TV-MA"].map(r => <option key={r} value={r}>{r}</option>)}
                        </Form.Select>
                      </Col>
                    </Form.Group>
                  </>
                )}

              <hr />
              <h5 className="mb-3">Cast & Crew</h5>
              <Row>
                <Col md={6}>
                  <h6>Available</h6>
                  <Form.Group className="mb-2 d-flex">
                    <Form.Control type="text" value={searchTerm} onChange={e => setSearchTerm(e.target.value)} placeholder="Search for person..." />
                    <Button variant="primary" onClick={fetchPeople} className="ms-2">Search</Button>
                  </Form.Group>
                  <ListGroup style={{maxHeight: "200px", overflowY: "auto"}}>
                    {isLoading ? <Spinner /> : castAndCrew.map(p => (
                      <ListGroup.Item key={p.id} action onClick={() => handleSelectPerson(p)}>{p.name} <span style={{fontSize: "0.6rem"}}>{!!p.birth_date && `${new Date(p.birth_date).getFullYear()}`}{(!!p.birth_date || !!p.death_date) && `-`}{!!p.death_date && `${new Date(p.death_date).getFullYear()}`}</span></ListGroup.Item>
                    ))}
                  </ListGroup>
                  </Col>
                  <Col md={6}>
                    <h6>Selected</h6>
                      <ListGroup style={{maxHeight: "250px", overflowY: "auto"}}>
                        {selected.map(p => (
                          <ListGroup.Item key={p.id}>
                            <div className="d-flex justify-content-between align-items-center">
                              {p.name}
                              <Button variant="outline-danger" size="sm" onClick={() => handleRemovePerson(p)}>X</Button>
                            </div>
                            <div className="mt-2">
                              <Form.Check inline type="checkbox" label="Director" checked={p.director} onChange={e => handleRoleChange(p.id, "director", e.target.checked)} />
                              <Form.Check inline type="checkbox" label="Writer" checked={p.writer} onChange={e => handleRoleChange(p.id, "writer", e.target.checked)} />
                              <Form.Check inline type="checkbox" label="Cast" checked={p.cast} onChange={e => handleRoleChange(p.id, "cast", e.target.checked)} />
                            </div>
                          </ListGroup.Item>
                        ))}
                      </ListGroup>
                  </Col>
              </Row>
            </>
          )}

          <div className="d-flex justify-content-end mt-4">
            <Button variant="secondary" onClick={handleHide} className="me-2">Cancel</Button>
            <Button variant="success" type="submit" disabled={isSubmitting}>
              {isSubmitting ? <Spinner as="span" size="sm" /> : (media?.id ? "Update" : "Create")}
            </Button>
          </div>
        </Form>
      </Modal.Body>
    </Modal>
  );
}

export default MediaForm;