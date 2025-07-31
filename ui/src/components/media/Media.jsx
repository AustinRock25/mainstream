import { Alert, Button, Container, Row, Spinner, Form } from "react-bootstrap";
import axios from "axios";
import MediaCard from "./MediaCard";
import { useCallback, useEffect, useState } from "react";

function Media() {
  const [alert, setAlert] = useState({ message: "", variant: "" });
  const [currentPage, setCurrentPage] = useState(1);
  const [isLoading, setIsLoading] = useState(false);
  const [media, setMedia] = useState([]);
  const [pages, setPages] = useState(0);
  const [searchTerm, setSearchTerm] = useState("");

  const fetchMediaLength = useCallback((currentSearchTerm) => {
    setIsLoading(true);
    axios.get("/api/media/length", { params: { searchTerm: currentSearchTerm } })
    .then(response => {
      const count = response.data[0].count;
      setPages(Math.ceil(count / 60));
    })
    .catch(error => {
      setAlert({ message: "Failed to get total media count.", variant: "danger" });
    })
    .finally(() => {
      setIsLoading(false);
    });
  }, []);

  const fetchMedia = useCallback((currentSearchTerm, begin, end) => {
    axios.get("/api/media", { params: { searchTerm: currentSearchTerm, beginRecord: begin, endRecord: end } })
    .then(response => {
      setMedia(response.data);
      setAlert({ message: "", variant: "" });
    })
    .catch(error => {
      setAlert({ message: "Failed to load media.", variant: "danger" });
    })
    .finally(() => {
      setIsLoading(false);
    });
  }, []);

  useEffect(() => {
    fetchMediaLength("");
    fetchMedia("", 1, 60);
  }, [fetchMedia, fetchMediaLength]);


  const handleSearch = (e) => {
    setMedia([]);
    e.preventDefault();
    setCurrentPage(1);
    fetchMediaLength(searchTerm);
    fetchMedia(searchTerm, 1, 60);
  };
  
  const changePage = (pageNumber) => {
    setMedia([]);
    const newBeginRecord = (pageNumber - 1) * 60 + 1;
    const newEndRecord = pageNumber * 60;
    setCurrentPage(pageNumber);
    fetchMedia(searchTerm, newBeginRecord, newEndRecord);
  }

  function getFirstPage() {
    changePage(1);
  }

  function getNext() {
    if (currentPage < pages)
      changePage(currentPage + 1);
  }

  function getPrev() {
    if (currentPage > 1)
      changePage(currentPage - 1);
  }

  return (
    <Container className="pt-3 text-center">
      {alert?.message &&
        <Alert
          variant={alert.variant}
          onClose={() => setAlert({ message: "", variant: "" })}
          dismissible
        >
          {alert.message}
        </Alert>
      }

    <h2 className="fw-bolder text-white mb-4">Films and TV Shows</h2>
    
    <Form onSubmit={handleSearch} className="mb-4 d-flex justify-content-center">
      <Form.Control
        type="text"
        value={searchTerm}
        onChange={event => setSearchTerm(event.target.value)}
        placeholder="Enter the title of a film or TV show..."
        className="w-50 me-2"
      />
      <Button type="submit" variant="primary">Search</Button>
    </Form>

    {isLoading
      ?
      <div className="d-flex justify-content-center align-items-center" style={{minHeight: '40vh'}}>
        <Spinner animation="border" role="status">
          <span className="visually-hidden">Loading...</span>
        </Spinner>
      </div>
      :
      media.length > 0
        ?
        <>
          <div className="d-flex justify-content-between align-items-center mb-3">
            <p className="text-white-50 mb-0">{media.length} result{media.length > 1 && `s`} displayed</p>
            <h6 className="fw-bolder text-white mb-0">Page {currentPage} of {pages}</h6>
          </div>
          
          <Row className="g-4 justify-content-center" xs={1} sm={2} md={3} lg={4} xl={5}>
            {media.map(m => <MediaCard key={`${m.id}-${m.type}`} media={m} />)}
          </Row>

          <div className="d-flex justify-content-center mt-4">
            {currentPage > 1 && <Button variant="primary" className="me-2" onClick={getFirstPage}>First Page</Button>}
            {currentPage > 1 && <Button variant="primary" className="me-2" onClick={getPrev}>Previous</Button>}
            {currentPage < pages && <Button variant="primary" onClick={getNext}>Next</Button>}
          </div>
        </>
        :
        <p className="text-white-50 mt-5">No results with that title found.</p>
    }
    </Container>
  );
}

export default Media;