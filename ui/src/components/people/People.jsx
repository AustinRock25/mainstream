import { Alert, Button, Container, Spinner, Table, Form } from "react-bootstrap";
import axios from "axios";
import Person from "./Person";
import { useCallback, useEffect, useState } from "react";

const People = () => {
  const [alert, setAlert] = useState({ message: "", variant: "" });
  const [currentPage, setCurrentPage] = useState(1);
  const [isLoading, setIsLoading] = useState(true);
  const [pages, setPages] = useState(0);
  const [people, setPeople] = useState([]);
  const [searchTerm, setSearchTerm] = useState("");

  const fetchPeopleLength = useCallback((currentSearchTerm) => {
    setIsLoading(true);
    axios.get("/api/people/length", { params: { searchTerm: currentSearchTerm } })
    .then(response => {
      const count = response.data[0].count;
      setPages(Math.ceil(count / 100));
    })
    .catch(error => {
      setAlert({ message: "Failed to get total people count.", variant: "danger" });
    })
    .finally(() => {
      setIsLoading(false);
    });
  }, []);

  const fetchPeople = useCallback((currentSearchTerm, begin, end) => {
    setIsLoading(true);
    axios.get("/api/people", { params: { searchTerm: currentSearchTerm, beginRecord: begin, endRecord: end } })
    .then(response => {
      setPeople(response.data);
      setAlert({ message: "", variant: "" });
    })
    .catch(error => {
      setAlert({ message: "Failed to load people.", variant: "danger" });
    })
    .finally(() => {
      setIsLoading(false);
    });
  }, []);

  useEffect(() => {
    fetchPeopleLength("");
    fetchPeople("", 1, 100);
  }, [fetchPeople, fetchPeopleLength]);

  const handleSearch = (e) => {
    e.preventDefault();
    setCurrentPage(1);
    fetchPeopleLength(searchTerm);
    fetchPeople(searchTerm, 1, 100);
  };
  
  const changePage = (pageNumber) => {
    const newBeginRecord = (pageNumber - 1) * 100 + 1;
    const newEndRecord = pageNumber * 100;
    setCurrentPage(pageNumber);
    fetchPeople(searchTerm, newBeginRecord, newEndRecord);
  }

  function getFirstPage() {
    changePage(1);
  }

  function getNext() {
    if (currentPage < pages) {
      changePage(currentPage + 1);
    }
  }

  function getPrev() {
    if (currentPage > 1) {
      changePage(currentPage - 1);
    }
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

      <h2 className="fw-bolder text-white mb-4">Actors & Directors</h2>
      
      <Form onSubmit={handleSearch} className="mb-4 d-flex justify-content-center">
        <Form.Control
          type="text"
          value={searchTerm}
          onChange={event => setSearchTerm(event.target.value)}
          placeholder="Enter the name of an actor or director..."
          className="w-50 me-2"
        />
        <Button type="submit" variant="primary">Search</Button>
      </Form>

      {isLoading ?
        <div className="d-flex justify-content-center align-items-center" style={{minHeight: "40vh"}}>
          <Spinner animation="border" role="status">
            <span className="visually-hidden">Loading...</span>
          </Spinner>
        </div>
        :
        <>
          {people.length > 0
            ?
            <>
              <div className="d-flex justify-content-between align-items-center mb-3">
                <p className="text-white-50 mb-0">{people.length} results displayed</p>
                <h6 className="fw-bolder text-white mb-0">Page {currentPage} of {pages}</h6>
              </div>
              
              <Table striped hover responsive variant="dark" className="align-middle">
                <thead>
                  <tr>
                    <th>Name</th>
                    <th>Date of Birth</th>
                    <th>Date of Death</th>
                    <th>Age</th>
                    <th style={{width: "30%"}}>Known For</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {people.map((person) => (
                    <Person key={person.id} person={person} />
                  ))}
                </tbody>
              </Table>

              <div className="d-flex justify-content-center mt-4">
                {currentPage > 1 && <Button variant="primary" className="me-2" onClick={getFirstPage}>First Page</Button>}
                {currentPage > 1 && <Button variant="primary" className="me-2" onClick={getPrev}>Previous</Button>}
                {currentPage < pages && <Button variant="primary" onClick={getNext}>Next</Button>}
              </div>
            </>
            :
            <p className="text-white-50 mt-5">No people available.</p>
          }
        </>
      }
    </Container>
  );
}

export default People;