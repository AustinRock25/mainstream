import { Alert, Button, Form, Modal, Spinner } from "react-bootstrap";
import axios from "axios";
import { useCallback, useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

function MediaForm({ show, setShow, media }) {
  const [alert, setAlert] = useState({ message: "", variant: "" });
  const [castAndCrew, setCastAndCrew] = useState([]);
  const [errors, setErrors] = useState({ });
  const [isLoading, setIsLoading] = useState(false);
  const [isMovie, setIsMovie] = useState(false);
  const [isShow, setIsShow] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const navigate = useNavigate();
  const [removed, setRemoved] = useState([]);
  const [searchTerm, setSearchTerm] = useState("");
  const [selected, setSelected] = useState([]);
  const [shows, setShows] = useState([]);
  const [formData, setFormData] = useState({
    id: "",
    title: "", 
    season: "",
    score: 0, 
    rating: "",
    release_date: "", 
    start_date: "",
    end_date: "",
    poster: "", 
    runtime: "",
    episodes: "",
    type: "",
    castAndCrew: []
  });

  const loadCastAndCrew = () => {
    let i = 0;
    let temp = new Array();
      if (!!media.cast_members) {
        for (let x = 0; x < media.cast_members.length; x++) {
          let z = 0;
          for (let y = 0; y < temp.length; y++) {
            if (temp[y].id == media.cast_members[x].actor_id) {
              temp[y].cast = true;
              break;
            }
            else
              z++;
          }
          if (z == temp.length) {
            temp[i] = {id: media.cast_members[x].actor_id, name: media.cast_members[x].name, director: false, writer: false, cast: true};
            i++;
          }
        }
      }
      if (!!media.cast_members_tv) {
        for (let x = 0; x < media.cast_members_tv.length; x++) {
          let z = 0;
          for (let y = 0; y < temp.length; y++) {
            if (temp[y].id == media.cast_members_tv[x].actor_id) {
              temp[y].cast = true;
              break;
            }
            else
              z++;
          }
          if (z == temp.length) {
            temp[i] = {id: media.cast_members_tv[x].actor_id, name: media.cast_members_tv[x].name, director: false, writer: false, cast: true};
            i++;
          }
        }
      }
      if (!!media.writers) {
        for (let x = 0; x < media.writers.length; x++) {
          let z = 0;
          for (let y = 0; y < temp.length; y++) {
            if (temp[y].id == media.writers[x].writer_id) {
              temp[y].writer = true;
              break;
            }
            else
              z++;
          }
          if (z == temp.length) {
            temp[i] = {id: media.writers[x].writer_id, name: media.writers[x].name, director: false, writer: true, cast: false};
            i++;
          }
        }
      }
      if (!!media.directors) {
        for (let x = 0; x < media.directors.length; x++) {
          let z = 0;
          for (let y = 0; y < temp.length; y++) {
            if (temp[y].id == media.directors[x].director_id) {
              temp[y].director = true;
              break;
            }
            else
              z++;
          }
          if (z == temp.length) {
            temp[i] = {id: media.directors[x].director_id, name: media.directors[x].name, director: true, writer: false, cast: false};
            i++;
          }
        }
      }
    return temp;
  }

  useEffect(() => {
    if (media?.id) {
      if (media.type == "movie")
        setIsMovie(true);
      else if (media.type == "show")
        setIsShow(true);

      if (isShow)
        media.score = media.score_tv;

      setFormData({
        id: media.id || "",
        title: media.title || "",
        season: media.season || "",
        score: media.score || 0,
        rating: media.rating || "Not Rated",
        release_date: new Date(media.release_date).toISOString().split("T")[0] || "",
        start_date: new Date(media.start_date).toISOString().split("T")[0] || "",
        end_date: new Date(media.end_date).toISOString().split("T")[0] || "",
        poster: media.poster || "",
        runtime: media.runtime || "",
        episodes: media.episodes || "",
        type: media.type || ""
      });
      setSelected(loadCastAndCrew());
    }
    axios.get("/api/media/shows")
    .then(response => {
      setShows(response.data);
    })
    .catch(error => {
      setAlert({ message: "Failed to get shows", variant: "danger" });
    })
  }, [media]);

  const getResults = useCallback(() => {
    setIsLoading(true);
    axios.get("/api/people/select", { params: { searchTerm: searchTerm } })
    .then(response => {
      setCastAndCrew(editResults(response.data));
    })
    .catch(error => {
      setAlert({ message: "Failed to load people", variant: "danger" });
    })
    .finally(() => {
      setIsLoading(false);
    });
  });

  const editResults = (arr) => {
    let temp = new Array();
    let y = 0;
    for (let x = 0; x < arr.length; x++) {
      if (selected.some((item) => item.id === arr[x].id) == false && removed.some((item) => item.id === arr[x].id) == false) {
        if (arr[x].birth_date == null || (isMovie && new Date(arr[x].birth_date) < new Date(formData.release_date)) || (isShow && new Date(arr[x].birth_date) < new Date(formData.start_date))) {
          if (arr[x].death_date == null || (isMovie && new Date(arr[x].death_date).setFullYear(new Date(arr[x].death_date).getFullYear() + 5) > new Date(formData.release_date)) || (isShow && new Date(arr[x].death_date).setFullYear(new Date(arr[x].death_date).getFullYear() + 5) > new Date(formData.start_date))) {
            temp[y] = arr[x];
            y++;
          }
        }
      }
    }

    return temp;
  }

  const handleChange = (e, key) => {
    setErrors({ ...errors, [key]: "" });
    setFormData({ ...formData, [key]: e.target.value });
    
    if (key == "type" && e.target.value == "movie") {
      setIsMovie(true);
      setIsShow(false);
      setFormData({ id: "", title: "", season: "", score: 0, start_date: "", end_date: "", poster: "", episodes: "", type: "movie" });
      setSelected([]);
    }
    else if (key == "type" && e.target.value == "show") {
      setIsShow(true);
      setIsMovie(false);
      setFormData({ title: "", score: 0, release_date: "", poster: "", runtime: "", type: "show" });
      setSelected([]);
    }
    else if (key == "type" && e.target.value == "") {
      setIsMovie(false);
      setIsShow(false);
      setFormData({ id: "", title: "", season: "", score: 0, rating: "Not Rated", release_date: "", start_date: "", end_date: "", poster: "", runtime: "", episodes: "" });
      setSelected([]);
    }
    if (key == "id" && e.target.value != "na")
      setFormData({ title: "", season: "", score: 0, rating: "Not Rated", start_date: "", end_date: "", poster: "", episodes: "", type: "show" });
  }

  function handleHide(e) {
    setShow(false);
    resetForm();
  }

  function resetForm() {
    setErrors({});
    setSearchTerm("");
    setAlert({ message: "", variant: "" });
    setCastAndCrew([]);
    setRemoved([]);
    if (!media?.id) {
      setFormData({ id: "", title: "", season: "", score: 0, rating: "Not Rated", release_date: "", start_date: "", end_date: "", poster: "",  runtime: "", episodes: "", type: "" });
      setSelected([]);
      setIsMovie(false);
      setIsShow(false);
    }
    else {
      setFormData({ id: media.id, title: media.title, episode: media.episodes, score: media.score, rating: media.rating, release_date: new Date(media.release_date).toISOString().split("T")[0], start_date: new Date(media.start_date).toISOString().split("T")[0], end_date: new Date(media.end_date).toISOString().split("T")[0], poster: media.poster, runtime: media.runtime, season: media.season, type: media.type });
      setSelected(loadCastAndCrew());
    }
  }

  const toggle = (member) => {
    const m = { id: member.id, name: member.name, director: false, writer: false, cast: false };
    if (highlight(m))
      remove(m);
    else {
      setSelected([...selected, m]);
      setRemoved(removed.filter((item) => item.id !== m.id));
      setCastAndCrew(castAndCrew.filter((item) => item.id !== m.id));
    }
  };

  const highlight = (member) => {
    let isIncluded = false;
    for (let x = 0; x < selected.length; x++) {
      if (selected[x].id == member.id) {
        isIncluded = true;
        break;
      }
    }
    return isIncluded;
  }

  const remove = (member) => {
    setSelected(selected.filter((item) => item.id !== member.id));
    setRemoved([...removed, member]);
  }
  
  function handleSubmit(e) {
    e.preventDefault();
    setIsSubmitting(true);

    formData.castAndCrew = selected;
    
    const apiCall = (media?.id && formData.id != "na") ? axios.put(`/api/media/${media.id}`, formData) : axios.post("/api/media", formData);
    
    apiCall
      .then(response => {
        handleHide();
        navigate("/media");
        window.location.reload();
      })
      .catch(error => {
        if (error.response?.status === 422)
          setErrors(error.response.data.errors);
        else if (error.response?.status === 401)
          setAlert({ message: `You must be logged in to ${media?.id ? "update" : "create"} a media.`, variant: "danger" });
        else if (error.response?.status === 403)
          setAlert({ message: `You do not have permission to ${media?.id ? "update this media" : "create media"}.`, variant: "danger" });
        else
          setAlert({ message: `Failed to ${media?.id ? "update" : "create" } media.`, variant: "danger" });
      })
      .finally(() => {
        setIsSubmitting(false);
      });
  }

  const meaning = () => {
    if (formData.score == 0)
      return "Awful";
    else if (formData.score == 1)
      return "Bad";
    else if (formData.score == 2)
      return "Mediocre";
    else if (formData.score == 3)
      return "Decent";
    else if (formData.score == 4)
      return "Good";
    else
      return "Great";
  }

  const checkDirector = (member) => {
    for (let x = 0; x < selected.length; x++) {
      if (selected[x].id == member.id) {
        if (selected[x].director == false)
          selected[x].director = true;
        else
          selected[x].director = false;
      }
    }
  }

  const checkWriter = (member) => {
    for (let x = 0; x < selected.length; x++) {
      if (selected[x].id == member.id) {
        if (selected[x].writer == false)
          selected[x].writer = true;
        else
          selected[x].writer = false;
      }
    }
  }

  const checkCast = (member) => {
    for (let x = 0; x < selected.length; x++) {
      if (selected[x].id == member.id) {
        if (selected[x].cast == false)
          selected[x].cast = true;
        else
          selected[x].cast = false;
      }
    }
  }

  return (
    <Modal show={show} onHide={(e) => setShow(false)} backdrop="static">
      <Modal.Header className="bg-dark text-white">
        <Modal.Title>{media?.id ? (media.type == "show" ? `Edit ${media.title} season ${media.season}` : `Edit ${media.title}`) : "Add Film/Season"}</Modal.Title>
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
            {!media &&
              <>
                <Form.Label>Type</Form.Label>
                <Form.Select
                  value={formData.type}
                  isInvalid={errors.type}
                  onChange={(e) => handleChange(e, "type")}
                >
                  <option value="">Select type</option>
                  <option value="movie">Movie</option>
                  <option value="show">TV Show</option>
                </Form.Select>
                <Form.Control.Feedback type="invalid">{errors.type}</Form.Control.Feedback>
              </>
            }
            {(isShow && !media?.id) &&
              <>
                <Form.Label className="mt-3">Show Select</Form.Label>
                <Form.Select
                  value={formData.id}
                  isInvalid={errors.id}
                  onChange={(e) => handleChange(e, "id")}
                >
                  <option value="">Select show</option>
                  {shows.map(show => (
                    <option key={show.id} value={show.id}>{show.title} ({new Date(show.start_date).getFullYear()})</option>
                  ))}
                  <option value="na">New title (use text box below)</option>
                </Form.Select>
                <Form.Control.Feedback type="invalid">{errors.id}</Form.Control.Feedback>
              </>
            }
            {(isMovie || formData.id == "na" || media?.id) && 
              <>
                <Form.Label className="mt-3">Title</Form.Label>
                <Form.Control
                  type="text"
                  value={formData.title}
                  placeholder="Enter title"
                  isInvalid={errors.title}
                  onChange={(e) => handleChange(e, "title")}
                />
                <Form.Control.Feedback type="invalid">{errors.title}</Form.Control.Feedback>
              </>
            }
            {isShow && 
              <>
                <Form.Label className="mt-3">Season</Form.Label>
                <Form.Control
                  type="number"
                  value={formData.season}
                  placeholder="Enter the season number"
                  isInvalid={errors.season}
                  onChange={(e) => handleChange(e, "season")}
                />
                <Form.Control.Feedback type="invalid">{errors.season}</Form.Control.Feedback>
              </>
            }
            {formData.type != "" &&
              <>
                <Form.Label className="mt-3">Score</Form.Label>
                <p className="">{formData.score}/5 - {meaning()}</p>
                <Form.Range
                  min="0"
                  max="5"
                  value={formData.score}
                  onChange={(e) => handleChange(e, "score")}
                />
              </>
            }
            {isMovie && 
              <>
                <Form.Label className="mt-3">Release Date</Form.Label>
                <Form.Control
                type="date"
                value={formData.release_date}
                placeholder="Enter release date"
                isInvalid={errors.release_date}
                onChange={(e) => handleChange(e, "release_date")}
                />
                <Form.Control.Feedback type="invalid">{errors.release_date}</Form.Control.Feedback>
              </>
            }
            {(isMovie || formData.id == "na" || media?.id) && 
              <>
                <Form.Label className="mt-3">Poster</Form.Label>
                <Form.Control
                  type="text"
                  value={formData.poster}
                  placeholder="Enter poster name"
                  isInvalid={errors.poster}
                  onChange={(e) => handleChange(e, "poster")}
                />
                <Form.Control.Feedback type="invalid">{errors.poster}</Form.Control.Feedback>
                <Form.Label className="mt-3">Rating</Form.Label>
                <Form.Select
                  value={formData.rating}
                  isInvalid={errors.rating}
                  onChange={(e) => handleChange(e, "rating")}
                >
                  <option value="Not Rated">Not Rated</option>
                  <option value="TV-Y">TV-Y</option>
                  <option value="TV-Y7">TV-Y7</option>
                  <option value="TV-Y7 FV">TV-Y7 FV</option>
                  <option value="TV-G">TV-G</option>
                  <option value="G">G</option>
                  <option value="TV-PG">TV-PG</option>
                  <option value="PG">PG</option>
                  <option value="TV-14">TV-14</option>
                  <option value="PG-13">PG-13</option>
                  <option value="TV-MA">TV-MA</option>
                  <option value="R">R</option>
                  <option value="NC-17">NC-17</option>
                </Form.Select>
              </>
            }
            {isMovie && 
              <>
                <Form.Label className="mt-3">Runtime</Form.Label>
                <Form.Control
                  type="number"
                  value={formData.runtime}
                  placeholder="Enter runtime (in minutes)"
                  isInvalid={errors.runtime}
                  onChange={(e) => handleChange(e, "runtime")}
                />
                <Form.Control.Feedback type="invalid">{errors.runtime}</Form.Control.Feedback>
              </>
            }
            {isShow &&
              <>
                <Form.Label className="mt-3">Start Date</Form.Label>
                <Form.Control
                  type="date"
                  value={formData.start_date}
                  placeholder="Enter the start date"
                  isInvalid={errors.start_date}
                  onChange={(e) => handleChange(e, "start_date")}
                />
                <Form.Control.Feedback type="invalid">{errors.start_date}</Form.Control.Feedback>
                <Form.Label className="mt-3">End Date</Form.Label>
                <Form.Control
                  type="date"
                  value={formData.end_date}
                  placeholder="Enter the end date"
                  isInvalid={errors.end_date}
                  onChange={(e) => handleChange(e, "end_date")}
                />
                <Form.Control.Feedback type="invalid">{errors.end_date}</Form.Control.Feedback>
                <Form.Label className="mt-3">Episodes</Form.Label>
                <Form.Control
                  type="number"
                  value={formData.episodes}
                  placeholder="Enter the number of episodes"
                  isInvalid={errors.episodes}
                  onChange={(e) => handleChange(e, "episodes")}
                />
                <Form.Control.Feedback type="invalid">{errors.episodes}</Form.Control.Feedback>
              </>
            }
            {formData.type != "" && 
              <>
                {isLoading
                  ?
                  <Spinner />
                  :
                  <>
                    <p className="mt-5">Cast & Crew</p>
                    <ul className="select-menu">
                      {castAndCrew.map(member => (
                        <li key={member.id}><Button variant="transparent" className="text-success" onClick={() => toggle(member)}>✓</Button> {member.name} {member.birth_date && `(b. ` + new Date(member.birth_date).getFullYear() + `)`}</li>
                      ))}
                    </ul>
                  </>
                }
                <input type="text" className="mt-2 w-75" value={searchTerm} onChange={event => setSearchTerm(event.target.value)} placeholder="Enter a name" />
                <Button id="search-button" className="btn btn-warning m-2" onClick={getResults}>Search</Button>
                {(!!selected && selected.length > 0) && 
                  <>
                    <table>
                      <thead>
                        <tr>
                          <th></th>
                          <th>Name</th>
                          {isMovie && <th>Director</th>}
                          {isMovie && <th>Writer</th>}
                          {(isShow && (formData.season == 1 || media?.id)) && <th>Creator</th>}
                          <th>Cast Member</th>
                        </tr>
                      </thead>
                      {selected.map(selected => (
                      <tbody>
                        <tr key={selected.id}>
                          <td><Button variant="transparent" className="text-danger" onClick={() => remove(selected)}>x</Button></td>
                          <td>{selected.name}</td>
                          {isMovie && <td><Form.Check type="checkbox" defaultChecked={selected.director == true} onClick={() => checkDirector(selected)}></Form.Check></td>}
                          {isMovie && <td><Form.Check type="checkbox" defaultChecked={selected.writer == true} onClick={() => checkWriter(selected)}></Form.Check></td>}
                          {(isShow && (formData.season == 1 || media?.id)) && <td><Form.Check type="checkbox" defaultChecked={selected.writer == true} onClick={() => checkWriter(selected)}></Form.Check></td>}
                          <td><Form.Check type="checkbox" defaultChecked={selected.cast == true} onClick={() => checkCast(selected)}></Form.Check></td>
                        </tr>
                      </tbody>
                      ))}
                    </table>
                  </>}
                <ul>
                  {removed.map(removed => (
                    <li key={removed.id}><Button variant="transparent" className="text-success" onClick={() => toggle(removed)}>✓</Button> {removed.name}</li>
                  ))}
                </ul>
                {errors.castAndCrew
                  ? 
                  <p className="text-danger">{errors.castAndCrew}</p>
                  : 
                  ""
                }
              </>
            }
          </Form.Group>
          <Form.Group className="mt-4">
            <Button id="form-submit-button" variant="warning" type="submit" className="me-2">{isSubmitting ? <Spinner /> : (media?.id ? "Update" : "Create")}</Button>
            <Button variant="secondary" type="button" onClick={handleHide}>Cancel</Button>
          </Form.Group>
        </Form>
      </Modal.Body>
    </Modal>
  );
}

export default MediaForm;
