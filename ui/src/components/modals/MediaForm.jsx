import { Alert, Button, Form, Modal, Spinner } from "react-bootstrap";
import axios from "axios";
import { useCallback, useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

function MediaForm({ show, setShow, media }) {
  const [alert, setAlert] = useState({ message: "", variant: "" });
  const [castMembers, setCastMembers] = useState([]);
  const [directors, setDirectors] = useState([]);
  const [errors, setErrors] = useState({ });
  const [isLoadingCast, setIsLoadingCast] = useState(false);
  const [isLoadingDir, setIsLoadingDir] = useState(false);
  const [isMovie, setIsMovie] = useState(false);
  const [isShow, setIsShow] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const navigate = useNavigate();
  const [removedCastMembers, setRemovedCastMembers] = useState([]);
  const [removedDirectors, setRemovedDirectors] = useState([]);
  const [searchTermCast, setSearchTermCast] = useState("");
  const [searchTermDirector, setSearchTermDirector] = useState("");
  const [selectedCastMembers, setSelectedCastMembers] = useState([]);
  const [selectedDirectors, setSelectedDirectors] = useState([]);
  const [formData, setFormData] = useState({
    id: "",
    title: "", 
    score: 0, 
    release_date: "", 
    year: "",
    poster: "", 
    runtime: "",
    min_episode_runtime: "",
    max_episode_runtime: "",
    end_date: "",
    seasons: "",
    episodes: "",
    watched: "",
    type: "",
    directors: [],
    cast_members: []
  });
  let tempSelectedDirectors = new Array();
  let tempSelectedCastMembers = new Array();

  useEffect(() => {
    if (media?.id) {
      const dateObject1 = new Date(media.release_date);
      const formattedDate1 = dateObject1.toISOString().split("T")[0];
      let dateObject2;
      let formattedDate2;
      if (!!media.end_date) {
        dateObject2 = new Date(media.end_date);
        formattedDate2 = dateObject2.toISOString().split("T")[0];
      }
      if (media.type == "movie") {
        for (let x = 0; x < media.directors.length; x++)
          tempSelectedDirectors[x] = {id: media.directors[x].director_id, name: media.directors[x].name};
      }
      for (let x = 0; x < media.cast_members.length; x++)
        tempSelectedCastMembers[x] = {id: media.cast_members[x].actor_id, name: media.cast_members[x].name};
      setFormData({
        id: media.id || "",
        title: media.title || "",
        score: media.score || 1,
        rating: media.rating || "Not Rated",
        release_date: formattedDate1 || "",
        poster: media.poster || "",
        runtime: media.runtime || "",
        min_episode_runtime: media.min_episode_runtime || "",
        max_episode_runtime: media.max_episode_runtime || "",
        end_date: formattedDate2 || "",
        seasons: media.seasons || "",
        episodes: media.episodes || "",
        watched: media.watched || "",
        type: media.type || ""
      });
      setSelectedDirectors(tempSelectedDirectors);
      setSelectedCastMembers(tempSelectedCastMembers);
      if (media.type == "movie")
        setIsMovie(true);
      else if (media.type == "show")
        setIsShow(true);
    }
  }, [media]);

  useEffect(() => {
    axios.get("/api/people/select")
      .then(response => {
        setDirectors(response.data);
        setCastMembers(response.data);
      })
      .catch(error => {
        setAlert({ message: "Failed to load people", variant: "danger" });
      })
  }, []);

  const getResultsCast = useCallback(() => {
    setIsLoadingCast(true);
    axios.get("/api/people/select", { params: { searchTerm: searchTermCast } })
    .then(response => {
      setCastMembers(response.data);
    })
    .catch(error => {
      setAlert({ message: "Failed to load people", variant: "danger" });
    })
    .finally(() => {
      setIsLoadingCast(false);
    });
  });

  const getResultsDirector = useCallback(() => {
    setIsLoadingDir(true);
    axios.get("/api/people/select", { params: { searchTerm: searchTermDirector } })
    .then(response => {
      setDirectors(response.data);
    })
    .catch(error => {
      setAlert({ message: "Failed to load people", variant: "danger" });
    })
    .finally(() => {
      setIsLoadingDir(false);
    });
  });

  const handleChange = (e, key) => {
    setErrors({ ...errors, [key]: "" });
    setFormData({ ...formData, [key]: e.target.value });
    if (key == "type" && e.target.value == "movie") {
      setIsMovie(true);
      setIsShow(false);
    }
    else if (key == "type" && e.target.value == "show") {
      setIsShow(true);
      setIsMovie(false);
    }
    else if (key == "type" && e.target.value == "") {
      setIsMovie(false);
      setIsShow(false);
    }
  }

  function handleHide(e) {
    setShow(false);
    resetForm();
  }

  function resetForm() {
    setErrors({});
    setSearchTermDirector("");
    setSearchTermCast("");
    setAlert({ message: "", variant: "" });
    setDirectors([]);
    setCastMembers([]);
    setRemovedCastMembers([]);
    setRemovedDirectors([]);
    if (!media?.id) {
      setFormData({ id: "", title: "", score: 0, rating: "Not Rated", year: "", poster: "",  runtime: "", type: "", min_episode_runtime: "", max_episode_runtime: "", end_date: "", seasons: "", episodes: "", watched: "" });
      setSelectedDirectors([]);
      setSelectedCastMembers([]);
    }
    else {
      setFormData({ id: media.id, title: media.title, score: media.score, rating: media.rating, year: media.year, poster: media.poster, runtime: media.runtime, type: media.type, min_episode_runtime: media.min_episode_runtime, max_episode_runtime: media.max_episode_runtime, end_date: media.end_date, seasons: media.seasons, episodes: media.episodes, watched: media.watched });
      setSelectedDirectors(media.directors);
      setSelectedCastMembers(media.cast_members);
    }
  }

  const toggleDirector = (director) => {
    if (highlightDirector(director))
      removeDirector(director);
    else {
      setSelectedDirectors([...selectedDirectors, director]);
      setRemovedDirectors(removedDirectors.filter((item) => item.id !== director.id));
      setDirectors(directors.filter((item) => item.id !== director.id)); 
    }
  };

  const highlightDirector = (director) => {
    let isIncluded = false;
    for (let x = 0; x < selectedDirectors.length; x++) {
      if (selectedDirectors[x].id == director.id) {
        isIncluded = true;
        break;
      }
    }
    return isIncluded;
  }

  const removeDirector = (director) => {
    setSelectedDirectors(selectedDirectors.filter((item) => item.id !== director.id));
    setRemovedDirectors([...removedDirectors, director]);
  }

  const toggleCastMember = (castMember) => {
    if (highlightCastMember(castMember))
      removeCastMember(castMember);
    else {
      setSelectedCastMembers([...selectedCastMembers, castMember]);
      setRemovedCastMembers(removedCastMembers.filter((item) => item.id !== castMember.id));
      setCastMembers(castMembers.filter((item) => item.id !== castMember.id)); 
    }
  };

  const highlightCastMember = (castMember) => {
    let isIncluded = false;
    for (let x = 0; x < selectedCastMembers.length; x++) {
      if (selectedCastMembers[x].id == castMember.id) {
        isIncluded = true;
        break;
      }
    }
    return isIncluded;
  }

  const removeCastMember = (castMember) => {
    setSelectedCastMembers(selectedCastMembers.filter((item) => item.id !== castMember.id));
    setRemovedCastMembers([...removedCastMembers, castMember]);
  }

  function handleSubmit(e) {
    e.preventDefault();
    setIsSubmitting(true);

    formData.directors = selectedDirectors;
    formData.cast_members = selectedCastMembers;
    
    const apiCall = media?.id ? axios.put(`/api/media/${media.id}`, formData) : axios.post("/api/media", formData);
    
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

  return (
    <Modal show={show} onHide={(e) => setShow(false)} backdrop="static">
      <Modal.Header className="bg-dark text-white">
        <Modal.Title>{media?.id ? `Edit ${media.title}` : "Add Film/TV Show"}</Modal.Title>
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
            <Form.Label className="mt-3">Title</Form.Label>
            <Form.Control
              type="text"
              value={formData.title}
              placeholder="Enter title"
              isInvalid={errors.title}
              onChange={(e) => handleChange(e, "title")}
            />
            <Form.Control.Feedback type="invalid">{errors.title}</Form.Control.Feedback>
            <Form.Label className="mt-3">Score</Form.Label>
            <p className="">{formData.score}/5 - {meaning()}</p>
            <Form.Range
              min="0"
              max="5"
              value={formData.score}
              onChange={(e) => handleChange(e, "score")}
            />
            <Form.Label className="mt-3">Release Date</Form.Label>
            <Form.Control
              type="date"
              value={formData.release_date}
              placeholder="Enter release date"
              isInvalid={errors.release_date}
              onChange={(e) => handleChange(e, "release_date")}
            />
            <Form.Control.Feedback type="invalid">{errors.release_date}</Form.Control.Feedback>
            <Form.Label className="mt-3">Poster</Form.Label>
            <Form.Control
              type="text"
              value={formData.poster}
              placeholder="Enter poster name"
              isInvalid={errors.poster}
              onChange={(e) => handleChange(e, "poster")}
            />
            <Form.Control.Feedback type="invalid">{errors.poster}</Form.Control.Feedback>
            {!media &&
              <>
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
              </>
            }
            {isShow &&
              <>
                <Form.Label className="mt-3">Minimum Episode Runtime</Form.Label>
                <Form.Control
                  type="number"
                  value={formData.min_episode_runtime}
                  placeholder="Enter the minimum episode runtime (in minutes)"
                  isInvalid={errors.min_episode_runtime}
                  onChange={(e) => handleChange(e, "min_episode_runtime")}
                />
                <Form.Control.Feedback type="invalid">{errors.min_episode_runtime}</Form.Control.Feedback>
                <Form.Label className="mt-3">Maximum Episode Runtime</Form.Label>
                <Form.Control
                  type="number"
                  value={formData.max_episode_runtime}
                  placeholder="Enter the maximum episode runtime (in minutes)"
                  isInvalid={errors.max_episode_runtime}
                  onChange={(e) => handleChange(e, "max_episode_runtime")}
                />
                <Form.Control.Feedback type="invalid">{errors.max_episode_runtime}</Form.Control.Feedback>
                <Form.Label className="mt-3">End Date</Form.Label>
                <Form.Control
                  type="date"
                  value={formData.end_date}
                  placeholder="Enter the end date"
                  isInvalid={errors.end_date}
                  onChange={(e) => handleChange(e, "end_date")}
                />
                <Form.Control.Feedback type="invalid">{errors.end_date}</Form.Control.Feedback>
                <Form.Label className="mt-3">Seasons</Form.Label>
                <Form.Control
                  type="number"
                  value={formData.seasons}
                  placeholder="Enter the number of seasons"
                  isInvalid={errors.seasons}
                  onChange={(e) => handleChange(e, "seasons")}
                />
                <Form.Control.Feedback type="invalid">{errors.seasons}</Form.Control.Feedback>
                <Form.Label className="mt-3">Episodes</Form.Label>
                <Form.Control
                  type="number"
                  value={formData.episodes}
                  placeholder="Enter the number of episodes"
                  isInvalid={errors.episodes}
                  onChange={(e) => handleChange(e, "episodes")}
                />
                <Form.Control.Feedback type="invalid">{errors.episodes}</Form.Control.Feedback>
                <Form.Label className="mt-3">Watched</Form.Label>
                <Form.Control
                  type="number"
                  value={formData.watched}
                  placeholder="Enter the number of seasons you watched"
                  isInvalid={errors.watched}
                  onChange={(e) => handleChange(e, "watched")}
                />
                <Form.Control.Feedback type="invalid">{errors.watched}</Form.Control.Feedback>
              </>
            }
            {isMovie && 
              <>
                {isLoadingDir
                  ?
                  <Spinner />
                  :
                  <>
                    <p className="mt-5">Directors</p>
                    <ul className="select-menu">
                      {directors.map(director => (
                        <li key={director.id}><Button variant="transparent" className="text-success" onClick={() => toggleDirector(director)}>✓</Button> {director.name} {director.birth_date && `(b. ` + new Date(director.birth_date).getFullYear() + `)`}</li>
                      ))}
                    </ul>
                  </>
                }
                <input type="text" className="mt-2 w-75" value={searchTermDirector} onChange={event => setSearchTermDirector(event.target.value)} placeholder="Enter the director's name" />
                <Button id="search-button" className="btn btn-warning m-2" onClick={getResultsDirector}>Search</Button>
                <ul>
                  {selectedDirectors.map(selectedDirector => (
                    <li key={selectedDirector.director_id}><Button variant="transparent" className="text-danger" onClick={() => removeDirector(selectedDirector)}>x</Button> {selectedDirector.name}</li>
                  ))}
                </ul>
                <ul>
                  {removedDirectors.map(removedDirector => (
                    <li key={removedDirector.director_id}><Button variant="transparent" className="text-success" onClick={() => toggleDirector(removedDirector)}>✓</Button> {removedDirector.name}</li>
                  ))}
                </ul>
                {errors.directors
                  ? 
                  <p className="text-danger">{errors.directors}</p>
                  : 
                  ""
                }
              </>
            }
            {isLoadingCast
              ?
              <Spinner />
              :
              <>
                <p className="mt-5">Cast</p>
                <ul className="select-menu">
                  {castMembers.map(castMember => (
                    <li key={castMember.id}><Button variant="transparent" className="text-success" onClick={() => toggleCastMember(castMember)}>✓</Button> {castMember.name} {castMember.birth_date && `(b. ` + new Date(castMember.birth_date).getFullYear() + `)`}</li>
                  ))}
                </ul>
              </>
            }
            <input type="text" className="mt-2 w-75" value={searchTermCast} onChange={event => setSearchTermCast(event.target.value)} placeholder="Enter the cast member's name" />
            <Button id="search-button" className="btn btn-warning m-2" onClick={getResultsCast}>Search</Button>
            <ul>
              {selectedCastMembers.map(selectedCastMember => (
                <li key={selectedCastMember.actor_id}><Button variant="transparent" className="text-danger" onClick={() => removeCastMember(selectedCastMember)}>x</Button> {selectedCastMember.name}</li>
              ))}
            </ul>
            <ul>
              {removedCastMembers.map(removedCastMember => (
                <li key={removedCastMember.actor_id}><Button variant="transparent" className="text-success" onClick={() => toggleCastMember(removedCastMember)}>✓</Button> {removedCastMember.name}</li>
              ))}
            </ul>
            {errors.cast_members
              ? 
              <p className="text-danger">{errors.cast_members}</p>
              : 
              ""
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
