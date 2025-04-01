import { Alert, Button, Container, Row, Spinner } from "react-bootstrap";
import axios from "axios";
import { useLocation } from "react-router-dom";
import MediaCard from "./MediaCard";
import { useCallback, useEffect, useState } from "react";

function Media() {
  const [alert, setAlert] = useState({ message: "", variant: "" });
  const [beginRecord, setBeginRecord] = useState(1);
  const [currentPage, setCurrentPage] = useState(1);
  const [endRecord, setEndRecord] = useState(60);
  const [isLoading, setIsLoading] = useState(false);
  const location = useLocation();
  const [media, setMedia] = useState([]);
  const [pages, setPages] = useState(0);
  const [searchTerm, setSearchTerm] = useState("");

  useEffect(() => {
    setIsLoading(true);
    axios.get("/api/media/length", { params: { searchTerm: searchTerm } })
    .then(response => {
      if (response.data[0].count % 60 == 0)
        setPages(parseInt(response.data[0].count / 60));
      else
        setPages(parseInt(response.data[0].count / 60) + parseInt(1));
    })
    .catch(error => {
      setAlert({ message: "Failed to get length", variant: "danger" });
    })
    .finally(() => {
      setIsLoading(false);
    });
  }, []);

  useEffect(() => {
    setIsLoading(true);
    axios.get("/api/media", { params: { searchTerm: searchTerm, beginRecord: beginRecord, endRecord: endRecord } })
    .then(response => {
      setMedia(response.data);
      setAlert({ message: "", variant: "" });
    })
    .catch(error => {
      setAlert({ message: "Failed to load media", variant: "danger" });
    })
    .finally(() => {
      setIsLoading(false);
    });
  }, [beginRecord, endRecord]);

  const getResults = useCallback(() => {
    setIsLoading(true);
    axios.get("/api/media", { params: { searchTerm: searchTerm, beginRecord: beginRecord, endRecord: endRecord } })
    .then(response => {
      setMedia(response.data);
      setAlert({ message: "", variant: "" });
    })
    .catch(error => {
      setAlert({ message: "Failed to load media", variant: "danger" });
    })
    .finally(() => {
      setIsLoading(false);
      getResultsLength();
    });
  });

  const getResultsLength = useCallback(() => {
    setIsLoading(true);
    axios.get("/api/media/length", { params: { searchTerm: searchTerm } })
    .then(response => {
      if (response.data[0].count % 60 == 0)
        setPages(parseInt(response.data[0].count / 60));
      else
        setPages(parseInt(response.data[0].count / 60) + parseInt(1));
    })
    .catch(error => {
      setAlert({ message: "Failed to get length", variant: "danger" });
    })
    .finally(() => {
      setIsLoading(false);
    });
  });

  function getFirstPage() {
    setBeginRecord(1);
    setEndRecord(60);
    setCurrentPage(1);
  }

  function getNext() {
    setBeginRecord(parseInt(beginRecord) + parseInt(60));
    setEndRecord(parseInt(endRecord) + parseInt(60));
    setCurrentPage(parseInt(currentPage) + parseInt(1));
  }

  function getPrev() {
    setBeginRecord(parseInt(beginRecord) - parseInt(60));
    setEndRecord(parseInt(endRecord) - parseInt(60));
    setCurrentPage(parseInt(currentPage) - parseInt(1));
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

    <h3 className="fw-bolder text-white">Films and TV Shows</h3>

    {media.length != 0 && <h6 className="fw-bolder text-white">Page {currentPage} of {pages}</h6>}

    {(beginRecord == 1 && endRecord == 60) &&
      <>
        <input type="text" value={searchTerm} onChange={event => setSearchTerm(event.target.value)} placeholder="Enter the title of a film or TV show..." />
        <Button id="search-button" className="btn btn-warning m-2" onClick={getResults}>Search</Button>
      </>
    }

    {isLoading
      ?
      <center>
        <Spinner />
      </center>
      :
      media.length > 0
        ?
        <>
          <p className="text-white">{media.length} {(media.length == 1) ? <span>result</span> : <span>results</span>} displayed</p>
          {currentPage != 1 && <Button id="first-page-button" className="btn btn-warning me-1 mb-1" onClick={getFirstPage}>Go back to first page</Button>}
          {currentPage != 1 && <Button id="previous-page-button" className="btn btn-warning me-1 mb-1" onClick={getPrev}>Previous</Button>}
          {currentPage != pages && <Button id="next-page-button" className="btn btn-warning me-1 mb-1" onClick={getNext}>Next</Button>}
          <Row className="g-4 justify-content-center" xs={1} sm={1} md={2} lg={3} xl={4} xxl={5}>
              {media.map(media => <MediaCard key={media.id} media={media} />)}
          </Row>
          {currentPage != 1 && <Button id="first-page-button" className="btn btn-warning me-1 mt-1" onClick={getFirstPage}>Go back to first page</Button>}
          {currentPage != 1 && <Button id="previous-page-button" className="btn btn-warning me-1 mt-1" onClick={getPrev}>Previous</Button>}
          {currentPage != pages && <Button id="next-page-button" className="btn btn-warning me-1 mt-1" onClick={getNext}>Next</Button>}
        </>
        :
        <p className="text-white">No results with that title found</p>
    }
    </Container>
  );
}

export default Media;