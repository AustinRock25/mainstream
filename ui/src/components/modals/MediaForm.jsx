import { Alert, Button, Form, Modal, Spinner, Col, Row, ListGroup, Badge } from "react-bootstrap";
import api from "../../api";
import { useCallback, useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { useSelector } from "react-redux";

function MediaForm({ show, setShow, media }) {
  const [alert, setAlert] = useState({ message: "", variant: "" });
  const [castAndCrew, setCastAndCrew] = useState([]);
  const [errors, setErrors] = useState({});
  const [episodes, setEpisodes] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const navigate = useNavigate();
  const [pillColor, setPillColor] = useState("danger");
  const [pillTextColor, setPillTextColor] = useState("white");
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
    poster: "",
    runtime: "",
    type: "",
    completed: false,
    castAndCrew: [],
    episodes: []
  };

  const [formData, setFormData] = useState(initialFormData);

  const getPrimaryMediaDate = useCallback(() => {
    if (formData.type === "movie") 
      return formData.release_date;

    return formData.release_dates?.[0] || "";
  }, [formData.type, formData.release_date, formData.release_dates]);

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
      const dateA = new Date(a.release_date || (a.episodes.release_date && a.episodes.release_date[0]));
      const dateB = new Date(b.release_date || (b.episodes.release_date && b.episodes.release_date[0]));

      if (isNaN(dateA.getTime())) 
        return 1;

      if (isNaN(dateB.getTime())) 
        return -1;

      return dateA.getTime() - dateB.getTime();
    });

    return allCredits;
  };

  const filterPeopleByDate = useCallback((people) => {
    const mediaDateStr = getPrimaryMediaDate();

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
      const firstCreditDate = new Date(firstCredit.release_date || (firstCredit.episodes.release_date && firstCredit.episodes.release_date[0]));

      if (isNaN(firstCreditDate.getTime())) 
        return true;
        
      if (person.death_date) {
        const deathDate = new Date(person.death_date);
        const limitDate = new Date(deathDate);
        limitDate.setFullYear(limitDate.getUTCFullYear() + 3);

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
        limitDate.setFullYear(limitDate.getUTCFullYear() - 10);

        if (mediaDate <= limitDate) 
          return false;
      }

      return true;
    });
  }, [getPrimaryMediaDate]);

  const loadExistingData = useCallback(() => {
    if (media?.id) {
      let cast = [];
      let ep = [];
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

      if (media.episodes) {
        for (let i = 0; i < media.episodes.length; i++)
          ep[i] = media.episodes[i];
      }

      if (!media.grade && !media.grade_tv) {
        media.grade = 0;
        media.grade_tv = 0;
      }
      else if (!media.grade)
        media.grade = media.grade_tv;

      if (media.grade <= 33.33) {
        setPillColor("danger");
        setPillTextColor("white");
      }
      else if (media.grade <= 66.67) {
        setPillColor("warning");
        setPillTextColor("black");
      }
      else {
        setPillColor("success");
        setPillTextColor("white");
      }

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
      }
      else {
        if (media.grade < 4.17)
          grade = 0;
        else if (media.grade < 12.5)
          grade = 1;
        else if (media.grade < 20.83)
          grade = 2;
        else if (media.grade < 29.17)
          grade = 3;
        else if (media.grade < 37.5)
          grade = 4;
        else if (media.grade < 45.83)
          grade = 5;
        else if (media.grade < 54.17)
          grade = 6;
        else if (media.grade < 62.5)
          grade = 7;
        else if (media.grade < 70.83)
          grade = 8;
        else if (media.grade < 79.17)
          grade = 9;
        else if (media.grade < 87.5)
          grade = 10;
        else if (media.grade < 95.83)
          grade = 11;
        else
          grade = 12;
      }

      if (!media.runtime && !media.runtime_tv) {
        media.runtime = 0;
        media.runtime_tv = 0;
      }
      else if (!media.runtime)
        media.runtime = media.runtime_tv;

      setFormData({
        id: media.id || "",
        title: media.title || "",
        season: media.season || "",
        grade: grade || 0,
        rating: media.rating || "Not Rated",
        release_date: media.release_date ? new Date(media.release_date).toISOString().split("T")[0] : "",
        poster: media.poster || "",
        runtime: media.runtime || "",
        completed: media.completed || false,
        type: media.type || "",
        episodes: media.episodes || []
      });

      setSelected(cast);
      setEpisodes(ep);
    }
    else {
      setFormData(initialFormData);
      setSelected([]);
      setEpisodes([]);
    }
  }, [media]);

  useEffect(() => {
    loadExistingData();

    if (show) {
      api.get("/media/shows")
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

    api.get("/people/select", { params: { searchTerm } })
    .then(response => {
      const selectedIds = new Set(Array.isArray(selected) && selected.map(s => s.id));
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

    if (user.rating_scale == 1 && key === "grade") {
      if (value <= 1) {
        setPillColor("danger");
        setPillTextColor("white");
      }
      else if (value <= 2.5) {
        setPillColor("warning");
        setPillTextColor("black");
      }
      else {
        setPillColor("success");
        setPillTextColor("white");
      }
    }
    else if (user.rating_scale == 2 && key === "grade") {
      if (value <= 1.5) {
        setPillColor("danger");
        setPillTextColor("white");
      }
      else if (value <= 3) {
        setPillColor("warning");
        setPillTextColor("black");
      }
      else {
        setPillColor("success");
        setPillTextColor("white");
      }
    }
    else if (user.rating_scale == 3 && key === "grade") {
      if (value <= 4) {
        setPillColor("danger");
        setPillTextColor("white");
      }
      else if (value <= 8) {
        setPillColor("warning");
        setPillTextColor("black");
      }
      else {
        setPillColor("success");
        setPillTextColor("white");
      }
    }
  };

  const handleAddEpisode = (index) => {
    setEpisodes([...episodes, { title: "", release_date: "" }]);
  };

  const handleEpisode = (e, key, index, episode) => {
    const newInfo = [...episodes, { ...episode, release_date: "", title: "" }];

    if (key === "release_date") {
      newInfo[index].release_date = e.target.value;
      setEpisodes([ ...episodes, { ...episode, release_date: newInfo[index].release_date } ]);
    }
    else {
      newInfo[index].title = e.target.value;
      setEpisodes([ ...episodes, { ...episode, title: newInfo[index].title } ]);
    }
  };

  const handleRemoveEpisode = (index) => {
    setEpisodes((episodes) => episodes.filter((_, i) => i !== index));
  };

  const handleSelectPerson = (person) => {
    setSelected([...selected, { ...person, director: false, writer: false, cast: false }]);
    setCastAndCrew(castAndCrew.filter(p => p.id !== person.id));
  };

  const handleRemovePerson = (person) => {
    setSelected(selected.filter(p => p.id !== person.id));
  };

  const handleRoleChange = (personId, role, isChecked) => {
    setSelected(Array.isArray(selected) && selected.map(p => p.id === personId ? { ...p, [role]: isChecked } : p));
  };

  function handleHide() {
    setShow(false);
    setErrors({});
    setSearchTerm("");
    setCastAndCrew([]);
    setEpisodes([]);
    setAlert({ message: "", variant: "" });
  }

  const getGrade = (grade) => {
    if (user.rating_scale == 1)
      return grade + "/4";
    else if (user.rating_scale == 2)
      return grade + "/5";
    else {
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
  }

  function handleSubmit(e) {
    e.preventDefault();
    setIsSubmitting(true);

    if (user.rating_scale == 1)
      formData.grade = (parseFloat(formData.grade) * 100) / 4;
    else if (user.rating_scale == 2)
      formData.grade = (parseFloat(formData.grade) * 100) / 5;
    else
      formData.grade = (parseFloat(formData.grade) * 100) / 12;

    const payload = { ...formData, castAndCrew: selected, episodes: episodes };
    const apiCall = media?.id ? api.put(`/media/${media.id}`, [payload, media]) : api.post("/media", payload);
  
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
    <Modal show={show} onHide={handleHide} backdrop="static" size="lg" centered style={{overflowY: "auto"}}>
      <Modal.Header>
        <Modal.Title>{media?.id ? `Edit ${media.title} ${(media.type == "show" && media.season != 1) ? `season ${media.season}` : ""}` : "Add Film/Show"}</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        {alert.message && 
          <Alert 
            variant={alert.variant} 
            onClose={() => setAlert({})} 
            dismissible>{alert.message}
          </Alert>
        }
        <Form onSubmit={handleSubmit}>
          {!media && (
            <Form.Group as={Row} className="mb-3">
              <Form.Label column sm={3}>Type</Form.Label>
              <Col sm={9}>
                <Form.Select value={formData.type} onChange={e => handleChange(e, "type")}>
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
                <Form.Select value={formData.id} onChange={(e) => handleChange(e, "id")}>
                  <option value="">Select existing show for new season</option>
                  {Array.isArray(shows) && shows.map(s => <option key={s.id} value={s.id}>{s.title} ({s.start_date ? new Date(s.start_date).getUTCFullYear() : 'N/A'})</option>)}
                  <option value="na">Create a new show</option>
                </Form.Select>
                <Form.Control.Feedback type="invalid">{errors.id}</Form.Control.Feedback>
              </Col>
            </Form.Group>
          )}
          {(formData.type === "movie" || formData.id === "na" || media?.id) && (
            <Form.Group as={Row} className="mb-3">
              <Form.Label column sm={3}>Title</Form.Label>
              <Col sm={9}><Form.Control type="text" value={formData.title} placeholder="Enter title" onChange={e => handleChange(e, "title")} /></Col>
              <Form.Control.Feedback type="invalid">{errors.title}</Form.Control.Feedback>
            </Form.Group>
          )}
          {formData.type === "show" && (
            <>
              <Form.Group as={Row} className="mb-3">
                <Form.Label column sm={3}>Episodes</Form.Label>
                <Col sm={12}>
                  {episodes.map((episode, index) => (
                    <div key={index} className="d-flex mb-2">
                      <span className="me-2 align-self-center">{index + 1}.</span>
                      <Form.Control type="text" value={episode.title} placeholder="Enter title" onChange={e => handleEpisode(e, "title", index, episode)} />
                      <Form.Control 
                        type="date" 
                        value={episode.release_date} 
                        onChange={(e) => handleEpisode(e, "release_date", index, episode)} 
                      />
                      <Button variant="outline-danger" size="sm" onClick={() => handleRemoveEpisode(index)}>X</Button>
                    </div>
                  ))}
                  <Button variant="outline-success" size="sm" onClick={() => handleAddEpisode()}>Add episode</Button>
                </Col>
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
              <Col sm={9}><Form.Control type="date" value={formData.release_date} onChange={e => handleChange(e, "release_date")} /></Col>
              <Form.Control.Feedback type="invalid">{errors.release_date}</Form.Control.Feedback>
            </Form.Group>
          )}
          <Form.Group as={Row} className="mb-3">
            <Form.Label column sm={3}>Runtime (mins)</Form.Label>
            <Col sm={9}><Form.Control type="number" value={formData.runtime} placeholder="e.g., 120" onChange={e => handleChange(e, "runtime")} /></Col>
            <Form.Control.Feedback type="invalid">{errors.runtime}</Form.Control.Feedback>
          </Form.Group>
          {formData.type && (
            <>
              <hr/>
                <Form.Group as={Row} className="mb-3">
                  <Form.Label column sm={3}>Grade: <Badge bg={pillColor} text={pillTextColor}>{getGrade(formData.grade)}</Badge></Form.Label>
                  {user.rating_scale == 1 && <Col sm={9}><Form.Range min="0" max="4" step="0.5" value={formData.grade} onChange={(e) => handleChange(e, "grade")} /></Col>}
                  {user.rating_scale == 2 && <Col sm={9}><Form.Range min="0" max="5" step="0.5" value={formData.grade} onChange={(e) => handleChange(e, "grade")} /></Col>}
                  {user.rating_scale == 3 && <Col sm={9}><Form.Range min="0" max="12" step="1" value={formData.grade} onChange={(e) => handleChange(e, "grade")} /></Col>}
                  <Form.Control.Feedback type="invalid">{errors.grade}</Form.Control.Feedback>
                </Form.Group>
                {(formData.type === "movie" || formData.id == "na" || media?.id) && (
                  <>
                    <Form.Group as={Row} className="mb-3">
                      <Form.Label column sm={3}>Poster File</Form.Label>
                      <Col sm={9}><Form.Control type="text" value={formData.poster} placeholder="e.g., tenet_2020" onChange={e => handleChange(e, "poster")} /></Col>
                      <Form.Control.Feedback type="invalid">{errors.poster}</Form.Control.Feedback>
                    </Form.Group>
                    <Form.Group as={Row} className="mb-3">
                      <Form.Label column sm={3}>Rating</Form.Label>
                      <Col sm={9}>
                        <Form.Select value={formData.rating} onChange={(e) => handleChange(e, "rating")}>
                          {formData.type !== "movie" ? Array.isArray(["Not Rated", "TV-Y", "TV-Y7", "TV-Y7 FV", "TV-G", "TV-PG", "TV-14", "TV-MA"]) && ["Not Rated", "TV-Y", "TV-Y7", "TV-Y7 FV", "TV-G", "TV-PG", "TV-14", "TV-MA"].map(r => <option key={r} value={r}>{r}</option>) : Array.isArray(["Not Rated", "G", "PG", "PG-13", "R", "NC-17", "TV-Y", "TV-Y7", "TV-Y7 FV", "TV-G", "TV-PG", "TV-14", "TV-MA"]) && ["Not Rated", "G", "PG", "PG-13", "R", "NC-17", "TV-Y", "TV-Y7", "TV-Y7 FV", "TV-G", "TV-PG", "TV-14", "TV-MA"].map(r => <option key={r} value={r}>{r}</option>)}
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
                    {isLoading ? <Spinner /> : Array.isArray(castAndCrew) && castAndCrew.map(p => (
                      <ListGroup.Item key={p.id} action onClick={() => handleSelectPerson(p)}>{p.name} <span style={{fontSize: "0.6rem"}}>{!!p.birth_date && `${new Date(p.birth_date).getUTCFullYear()}`}{(!!p.birth_date || !!p.death_date) && `-`}{!!p.death_date && `${new Date(p.death_date).getUTCFullYear()}`}</span></ListGroup.Item>
                    ))}
                  </ListGroup>
                  </Col>
                  <Col md={6}>
                    <h6>Selected</h6>
                      <ListGroup style={{maxHeight: "250px", overflowY: "auto"}}>
                        {Array.isArray(selected) && selected.map(p => (
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
                      <Form.Control.Feedback type="invalid">{errors.castAndCrew}</Form.Control.Feedback>
                  </Col>
              </Row>
            </>
          )}
          <div className="d-flex justify-content-end mt-4">
            <Button variant="secondary" onClick={handleHide} className="me-2">Cancel</Button>
            <Button variant="success" type="submit" disabled={isSubmitting}>
              {isSubmitting 
                ? 
                  <Spinner as="span" size="sm" /> 
                :
                  (media?.id 
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

export default MediaForm;