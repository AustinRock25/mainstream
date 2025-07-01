import { Alert, Button, Container, Spinner, Table } from "react-bootstrap";
import axios from "axios";
import Person from "./Person";
import { useCallback, useEffect, useState } from "react";

const People = () => {
  const [alert, setAlert] = useState({ message: "", variant: "" });
  const [beginRecord, setBeginRecord] = useState(1);
  const [currentPage, setCurrentPage] = useState(1);
  const [endRecord, setEndRecord] = useState(100);
  const [isLoading, setIsLoading] = useState(true);
  const [pages, setPages] = useState(0);
  const [people, setPeople] = useState([]);
  const [searchTerm, setSearchTerm] = useState("");

  useEffect(() => {
    setIsLoading(true);
    axios.get("/api/people/length", { params: { searchTerm: searchTerm } })
    .then(response => {
      if (response.data[0].count % 100 == 0)
        setPages(parseInt(response.data[0].count / 100));
      else
        setPages(parseInt(response.data[0].count / 100) + parseInt(1));
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
    axios.get("/api/people", { params: { searchTerm: searchTerm, beginRecord: beginRecord, endRecord: endRecord } })
    .then(response => {
      setPeople(response.data);
      setAlert({ message: "", variant: "" });
    })
    .catch(error => {
      setAlert({ message: "Failed to load people", variant: "danger" });
    })
    .finally(() => {
      setIsLoading(false);
    });
  }, [beginRecord, endRecord]);

  const getResults = useCallback(() => {
    setIsLoading(true);
    axios.get("/api/people", { params: { searchTerm: searchTerm, beginRecord: beginRecord, endRecord: endRecord } })
    .then(response => {
      setPeople(response.data);
      setAlert({ message: "", variant: "" });
    })
    .catch(error => {
      setAlert({ message: "Failed to load people", variant: "danger" });
    })
    .finally(() => {
      setIsLoading(false);
      getResultsLength();
    });
  });

  const getResultsLength = useCallback(() => {
    setIsLoading(true);
    axios.get("/api/people/length", { params: { searchTerm: searchTerm } })
    .then(response => {
      if (response.data[0].count % 100 == 0)
        setPages(parseInt(response.data[0].count / 100));
      else
        setPages(parseInt(response.data[0].count / 100) + parseInt(1));
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
    setEndRecord(100);
    setCurrentPage(1);
  }

  function getNext() {
    setBeginRecord(parseInt(beginRecord) + parseInt(100));
    setEndRecord(parseInt(endRecord) + parseInt(100));
    setCurrentPage(parseInt(currentPage) + parseInt(1));
  }

  function getPrev() {
    setBeginRecord(parseInt(beginRecord) - parseInt(100));
    setEndRecord(parseInt(endRecord) - parseInt(100));
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

      <h3 className="fw-bolder text-white">Actors & Directors</h3>

      {people.length != 0 && <h6 className="fw-bolder text-white">Page {currentPage} of {pages}</h6>}

      {(beginRecord == 1 && endRecord == 100) &&
        <>
          <input type="text" value={searchTerm} onChange={event => setSearchTerm(event.target.value)} placeholder="Enter the name of an actor or director..." />
          <Button id="search-button" className="btn btn-warning m-2" onClick={getResults}>Search</Button>
        </>
      }

      {isLoading ?
        <center>
          <Spinner />
        </center>
        :
        <>
          {people.length > 0 
            ?
            <>
              <p className="text-white">{people.length} {(people.length == 1) ? <span>result</span> : <span>results</span>} displayed</p>
              {currentPage != 1 && <Button id="first-page-button" className="btn btn-warning me-1 mb-1" onClick={getFirstPage}>Go back to first page</Button>}
              {currentPage != 1 && <Button id="previous-page-button" className="btn btn-warning me-1 mb-1" onClick={getPrev}>Previous</Button>}
              {currentPage != pages && <Button id="next-page-button" className="btn btn-warning me-1 mb-1" onClick={getNext}>Next</Button>}
              <Table striped variant="dark">
                <thead>
                  <tr>
                    <th>Name</th>
                    <th>Date of Birth</th>
                    <th>Date of Death</th>
                    <th style={{ width: "110px" }}>Known For</th>
                  </tr>
                </thead>
                <tbody>
                  {people.map((person) => (
                    <Person key={person.id} person={person} />
                  ))}
                </tbody>
              </Table>
              {currentPage != 1 && <Button id="first-page-button" className="btn btn-warning me-1 mt-1" onClick={getFirstPage}>Go back to first page</Button>}
              {currentPage != 1 && <Button id="previous-page-button" className="btn btn-warning me-1 mt-1" onClick={getPrev}>Previous</Button>}
              {currentPage != pages && <Button id="next-page-button" className="btn btn-warning me-1 mt-1" onClick={getNext}>Next</Button>}
            </>
            :
            <p className="text-white">No people available</p>
          }
        </>
      }
    </Container>
  );
}

export default People;