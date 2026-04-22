import { Alert, Button, Form, Modal, Spinner, Col, Row, ListGroup, Badge } from "react-bootstrap";
import api from "../../api";
import { useCallback, useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { useSelector } from "react-redux";

function MediaForm({ show, setShow, media, season }) {
  const [alert, setAlert] = useState({ message: "", variant: "" });
  const [castAndCrew, setCastAndCrew] = useState([]);
  const [castAndCrewEp, setCastAndCrewEp] = useState([]);
  const [errors, setErrors] = useState({});
  const [episodes, setEpisodes] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState("");
  const [searchTermEp, setSearchTermEp] = useState("");
  const [activeEpisodeIndex, setActiveEpisodeIndex] = useState(null); 
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

      if (!!media.directors)
        media.directors.sort((a, b) => (a.ordering > b.ordering ? 1 : -1)).forEach(p => addPerson(p, "director"));

      if (!!media.writers)
        media.writers.sort((a, b) => (a.ordering > b.ordering ? 1 : -1)).forEach(p => addPerson(p, "writer"));

      if (!!media.cast_members)
        media.cast_members.sort((a, b) => (a.ordering > b.ordering ? 1 : -1)).forEach(p => addPerson(p, "cast"));

      if (media.type == "show") {
        media.seasons.sort((a, b) => a.season > b.season ? 1 : -1);

        for (let i = 0; i < media.seasons[season - 1].episodes.length; i++) {
          ep[i] = { ...media.seasons[season - 1].episodes[i] };
          const episodePeopleMap = new Map();

          const episodeAddPerson = (p, role) => {
            if (!p) 
              return;

            const personId = p.writer_id || p.director_id;
            
            if (!episodePeopleMap.has(personId))
              episodePeopleMap.set(personId, { id: personId, name: p.name, director: false, writer: false });
            
            if (role) 
              episodePeopleMap.get(personId)[role] = true;
          };

          if (!!media.seasons[season - 1].episodes[i].directors)
            media.seasons[season - 1].episodes[i].directors.sort((a, b) => (a.ordering > b.ordering ? 1 : -1)).forEach(p => episodeAddPerson(p, "director"));

          if (!!media.seasons[season - 1].episodes[i].writers)
            media.seasons[season - 1].episodes[i].writers.sort((a, b) => (a.ordering > b.ordering ? 1 : -1)).forEach(p => episodeAddPerson(p, "writer"));
          
          ep[i].creatives = Array.from(episodePeopleMap.values());
        }

        media.grade = media.seasons[season - 1].grade;
        media.seasons[season - 1].cast_members.sort((a, b) => (a.ordering > b.ordering ? 1 : -1  )).forEach(p => addPerson(p, "cast"));
      }

      cast = Array.from(peopleMap.values());

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

      setFormData({
        id: media.id || "",
        title: media.title || "",
        season: season || "",
        grade: grade || 0,
        rating: media.rating || "Not Rated",
        release_date: media.release_date ? new Date(media.release_date).toISOString().split("T")[0] : "",
        poster: media.poster || "",
        runtime: media.runtime || "",
        completed: media.completed || false,
        type: media.type || ""
      });

      setSelected(cast);
      setEpisodes(ep);
    }
    else {
      setFormData(initialFormData);
      setSelected([]);
      setEpisodes([]);
    }
  }, [media, season]);

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
    let st = "";

    if (activeEpisodeIndex !== null)
      st = searchTermEp;
    else
      st = searchTerm;
    
    setIsLoading(true);
    api.get("/people/select", { params: { st } })
      .then(response => {
        if (activeEpisodeIndex !== null) {
          episodes[activeEpisodeIndex].creatives.forEach(c => new Set(episodes[activeEpisodeIndex].creatives.map(e => e.id)).add(c.id));
          setCastAndCrewEp(response.data.filter(p => !new Set(episodes[activeEpisodeIndex].creatives.map(e => e.id)).has(p.id)));
        }
        else
          setCastAndCrew(response.data.filter(p => !new Set(selected.map(s => s.id)).has(p.id)));
      })
      .finally(() => {
        setIsLoading(false);
      });
  }, [searchTerm, searchTermEp, selected, episodes, activeEpisodeIndex]);

  const handleChange = (e, key) => {
    const { value, type, checked } = e.target;
    setFormData(prev => ({ ...prev, [key]: type === "checkbox" ? checked : value }));

    if (key === "type") {
      setFormData({ ...initialFormData, type: value });
      setSelected([]);
      setEpisodes([]);
    }
  };

  const handleAddEpisode = () => {
    setEpisodes([...episodes, { title: "", release_date: "", creatives: [] }]);
  };

  const handleEpisode = (e, key, index) => {
    setEpisodes(prev => prev.map((ep, i) => i === index ? { ...ep, [key]: e.target.value } : ep));
  };

  const handleRemoveEpisode = (index) => {
    setEpisodes(prev => prev.filter((_, i) => i !== index));
  };

  const handleSelectPersonEp = (person, index) => {
    setEpisodes(prev => prev.map((ep, i) => i === index ? { ...ep, creatives: [...(ep.creatives || []), { ...person, director: false, writer: false }] } : ep));
    setCastAndCrewEp(castAndCrewEp.filter(p => p.id !== person.id));
  };

  const handleRemovePersonEp = (personId, index) => {
    setEpisodes(prev => prev.map((ep, i) => i === index ? { ...ep, creatives: ep.creatives.filter(p => p.id !== personId) } : ep));
  };

  const handleRoleChangeEp = (personId, role, isChecked, index) => {
    setEpisodes(prev => prev.map((ep, i) => i === index ? { ...ep, creatives: ep.creatives.map(p => p.id === personId ? { ...p, [role]: isChecked } : p) } : ep));
  };

  const handleSelectPerson = (person) => {
    setSelected([...selected, { ...person, director: false, writer: false, cast: false }]);
    setCastAndCrew(castAndCrew.filter(p => p.id !== person.id));
  };

  const handleRemovePerson = (person) => {
    setSelected(selected.filter(p => p.id !== person.id));
  }

  const handleRoleChange = (personId, role, isChecked) => {
    setSelected(prev => prev.map(p => p.id === personId ? { ...p, [role]: isChecked } : p));
  };

  function handleHide() {
    setShow(false);
    setSearchTerm("");
    setActiveEpisodeIndex(null);
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
        <Modal.Title>{media?.id ? `Edit ${media.title} ${(media.type == "show") ? `season ${season}` : ""}` : "Add Film/Show"}</Modal.Title>
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
                <Form.Select value={formData.type} onChange={e => handleChange(e, "type")} isInvalid={errors.type}>
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
                <Form.Select value={formData.id} onChange={(e) => handleChange(e, "id")} isInvalid={errors.id}>
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
              <Col sm={9}><Form.Control type="text" value={formData.title} placeholder="Enter title" onChange={e => handleChange(e, "title")} isInvalid={errors.title}/></Col>
              <Form.Control.Feedback type="invalid">{errors.title}</Form.Control.Feedback>
            </Form.Group>
          )}
          {formData.type === "show" && (
            <>
              <Form.Group as={Row} className="mb-3">
                <Form.Label column sm={12}>Episodes</Form.Label>
                <Col sm={12}>
                  {episodes.map((episode, index) => (
                    <div key={index} className="border p-3 mb-3 bg-dark rounded">
                      <div className="d-flex mb-2">
                        <Badge bg="dark" className="me-2 align-self-center">Ep {index + 1}</Badge>
                        <Form.Control className="me-2" type="text" value={episode.title} placeholder="Title" onChange={e => handleEpisode(e, "title", index)} />
                        <Form.Control type="date" value={episode.release_date || ""} onChange={(e) => handleEpisode(e, "release_date", index)} />
                        <Button variant="outline-danger" className="ms-2" onClick={() => handleRemoveEpisode(index)}>X</Button>
                      </div>
                      <Row className="mt-3">
                        <Col md={6}>
                          <h6>Available</h6>
                          <div className="d-flex mb-2">
                            <Form.Control 
                              type="text" 
                              placeholder="Search..." 
                              onChange={e => { setSearchTermEp(e.target.value); setActiveEpisodeIndex(index); }} 
                            />
                            <Button size="sm" variant="primary" onClick={fetchPeople} className="ms-2">Search</Button>
                          </div>
                          <ListGroup style={{maxHeight: "100px", overflowY: "auto"}}>
                            {activeEpisodeIndex === index && isLoading ? <Spinner size="sm"/> : activeEpisodeIndex === index && castAndCrewEp.map(p => (
                              <ListGroup.Item key={p.id} action onClick={() => handleSelectPersonEp(p, index)}>{p.name}<span style={{fontSize: "0.6rem"}}> {!!p.birth_date && `${new Date(p.birth_date).getUTCFullYear()}`}{(!!p.birth_date || !!p.death_date) && `-`}{!!p.death_date && `${new Date(p.death_date).getUTCFullYear()}`}</span></ListGroup.Item>
                            ))}
                          </ListGroup>
                        </Col>
                        <Col md={6}>
                          <h6>Episode Crew</h6>
                          <ListGroup style={{maxHeight: "150px", overflowY: "auto"}}>
                            {episode.creatives?.map(p => (
                              <ListGroup.Item key={p.id} className="p-2">
                                <div className="d-flex justify-content-between align-items-center">
                                  {p.name}
                                  <Button variant="outline-danger" size="sm" onClick={() => handleRemovePersonEp(p.id, index)}>X</Button>
                                </div>
                                <div className="mt-1">
                                  <Form.Check inline type="checkbox" label="Director" checked={p.director} onChange={e => handleRoleChangeEp(p.id, "director", e.target.checked, index)} />
                                  <Form.Check inline type="checkbox" label="Writer" checked={p.writer} onChange={e => handleRoleChangeEp(p.id, "writer", e.target.checked, index)} />
                                </div>
                              </ListGroup.Item>
                            ))}
                          </ListGroup>
                        </Col>
                      </Row>
                    </div>
                  ))}
                  <Button variant="outline-success" onClick={handleAddEpisode}>+ Add Episode</Button>
                </Col>
              </Form.Group>
              <Form.Group as={Row} className="mb-3">
                <Form.Label column sm={3}>Series Status</Form.Label>
                <Col sm={9}><Form.Check type="switch" label="Series is completed" checked={formData.completed} onChange={e => handleChange(e, "completed")} /></Col>
              </Form.Group>
            </>
          )}
          {formData.type === "movie" && (
            <>
              <Form.Group as={Row} className="mb-3">
                <Form.Label column sm={3}>Release Date</Form.Label>
                <Col sm={9}><Form.Control type="date" value={formData.release_date} onChange={e => handleChange(e, "release_date")} /></Col>
                <Form.Control.Feedback type="invalid">{errors.release_date}</Form.Control.Feedback>
              </Form.Group>
              <Form.Group as={Row} className="mb-3">
                <Form.Label column sm={3}>Runtime (mins)</Form.Label>
                <Col sm={9}><Form.Control type="number" value={formData.runtime} isInvalid={errors.runtime} placeholder="e.g., 120" onChange={e => handleChange(e, "runtime")} /></Col>
                <Form.Control.Feedback type="invalid">{errors.runtime}</Form.Control.Feedback>
              </Form.Group>
            </>
          )}
          {formData.type && (
            <>
              <hr/>
                <Form.Group as={Row} className="mb-3">
                  <Form.Label column sm={3}>Grade: <span className="fw-light fs-3 text-white-50">{getGrade(formData.grade)}</span></Form.Label>
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
                              {formData.type != "show" && <Form.Check inline type="checkbox" label="Director" checked={p.director} onChange={e => handleRoleChange(p.id, "director", e.target.checked)} />}
                              {formData.type != "show" && <Form.Check inline type="checkbox" label="Writer" checked={p.writer} onChange={e => handleRoleChange(p.id, "writer", e.target.checked)} />}
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