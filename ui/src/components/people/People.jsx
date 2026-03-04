import { Alert, Button, Container, Spinner, Table, Form, Row, Col, Collapse } from "react-bootstrap";
import api from "../../api";
import Person from "./Person";
import { useCallback, useEffect, useState } from "react";

const getInitialState = () => {
  const savedState = localStorage.getItem("peopleFilters");

  const defaults = {
    searchTerm: "",
    sortBy: "birth_date",
    sortOrder: "ASC",
    birthDateRange: { start: "", end: "" },
    deathDateRange: { start: "", end: "" },
    noBirthDate: false,
    noDeathDate: false,
  };

  return savedState ? JSON.parse(savedState) : defaults;
};

const getDefaultState = () => ({
  searchTerm: "",
  sortBy: "birth_date",
  sortOrder: "ASC",
  birthDateRange: { start: "", end: "" },
  deathDateRange: { start: "", end: "" },
  noBirthDate: false,
  noDeathDate: false,
});

const People = () => {
  const [alert, setAlert] = useState({ message: "", variant: "" });
  const [currentPage, setCurrentPage] = useState(1);
  const [isLoading, setIsLoading] = useState(true);
  const [pages, setPages] = useState(0);
  const [people, setPeople] = useState([]);
  const [filters, setFilters] = useState(getInitialState);
  const [open, setOpen] = useState(false);

  useEffect(() => {
    localStorage.setItem("peopleFilters", JSON.stringify(filters));
  }, [filters]);

  const fetchPeopleData = useCallback((page, currentFilters) => {
    setIsLoading(true);
    const beginRecord = (page - 1) * 100 + 1;
    const endRecord = page * 100;

    const params = {
      beginRecord,
      endRecord,
      searchTerm: currentFilters.searchTerm,
      sortBy: currentFilters.sortBy,
      sortOrder: currentFilters.sortOrder,
      minBirthDate: currentFilters.birthDateRange.start,
      maxBirthDate: currentFilters.birthDateRange.end,
      noBirthDate: currentFilters.noBirthDate ? "true" : "",
      minDeathDate: currentFilters.deathDateRange.start,
      maxDeathDate: currentFilters.deathDateRange.end,
      noDeathDate: currentFilters.noDeathDate ? "true" : "",
    };

    Object.keys(params).forEach(key => (params[key] === "" || params[key] === false) && delete params[key]);
    
    Promise.all([
      api.get("/people/length", { params }),
      api.get("/people", { params })
    ])
    .then(([lengthResponse, mediaResponse]) => {
      const count = lengthResponse.data[0].count;
      setPages(Math.ceil(count / 100));
      setPeople(mediaResponse.data);
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
    fetchPeopleData(1, filters);
  }, [fetchPeopleData, filters]);

  const handleFilterChange = (e) => {
    setCurrentPage(1);
    const { name, value, type, checked } = e.target;

    if (name.includes(".")) {
      const [parent, child] = name.split(".");

      setFilters(prev => ({
        ...prev,
        [parent]: { ...prev[parent], [child]: value }
      }));
      
      return;
    }

    if (type === "checkbox") {
      setFilters(prev => ({ ...prev, [name]: checked }));
      return;
    }

    setFilters(prev => ({ ...prev, [name]: value }));
  };

  const handleApplyFilters = (e) => {
    e.preventDefault();
    setCurrentPage(1);
    fetchPeopleData(1, filters);
  };
  
  const handleClearFilters = (e) => {
    e.preventDefault();
    const defaultState = getDefaultState();
    setFilters(defaultState);
    setCurrentPage(1);
    fetchPeopleData(1, defaultState);
  };
  
  const changePage = (pageNumber) => {
    setPeople([]);
    setCurrentPage(pageNumber);
    fetchPeopleData(pageNumber, filters);
  }

  return (
    <Container className="pt-3 text-center">
      {alert?.message && 
        <Alert 
          variant={alert.variant} 
          onClose={() => setAlert({ message: "", variant: "" })} 
          dismissible>{alert.message}
        </Alert>
      }
      <h2 className="fw-bolder text-white mb-4">People</h2>
      <Form onSubmit={handleApplyFilters} className="mb-4">
        <Row className="justify-content-center">
          <Col md={8} lg={6} className="d-flex">
            <Form.Control
              type="text"
              name="searchTerm"
              value={filters.searchTerm}
              onChange={handleFilterChange}
              placeholder="Enter name..."
              className="me-2"
            />
            <Button onClick={() => setOpen(!open)} aria-controls="filters-collapse" aria-expanded={open} variant="secondary" className="me-2 flex-shrink-0">Filters & Sort</Button>
          </Col>
        </Row>
        <Collapse in={open}>
          <div id="filters-collapse" className="mt-4 p-4 bg-dark text-white rounded">
            <Row className="g-3">
              <Col md={6}>
                <Form.Group>
                  <Form.Label>Sort By</Form.Label>
                  <Form.Select name="sortBy" value={filters.sortBy} onChange={handleFilterChange}>
                    <option value="name">Name</option>
                    <option value="birth_date">Birth Date</option>
                    <option value="death_date">Death Date</option>
                  </Form.Select>
                </Form.Group>
              </Col>
              <Col md={6}>
                <Form.Group>
                  <Form.Label>Order</Form.Label>
                  <Form.Select name="sortOrder" value={filters.sortOrder} onChange={handleFilterChange}>
                    <option value="ASC">Ascending</option>
                    <option value="DESC">Descending</option>
                  </Form.Select>
                </Form.Group>
              </Col>
              <Col md={12}><hr /></Col>
              <Col md={6}>
                <Form.Group className="mb-2">
                  <Form.Label>Birth Date Range</Form.Label>
                  <Row>
                    <Col><Form.Control type="date" name="birthDateRange.start" value={filters.birthDateRange.start} placeholder="Start" onChange={handleFilterChange} /></Col>
                    <Col><Form.Control type="date" name="birthDateRange.end" value={filters.birthDateRange.end} placeholder="End" onChange={handleFilterChange} /></Col>
                  </Row>
                </Form.Group>
                <Form.Check 
                  type="checkbox" 
                  id="noBirthDateCheck"
                  name="noBirthDate" 
                  label="Only show people with no birth date" 
                  checked={filters.noBirthDate}
                  onChange={handleFilterChange}
                />
              </Col>
              <Col md={6}>
                <Form.Group className="mb-2">
                  <Form.Label>Death Date Range</Form.Label>
                  <Row>
                    <Col><Form.Control type="date" name="deathDateRange.start" value={filters.deathDateRange.start} placeholder="Start" onChange={handleFilterChange} /></Col>
                    <Col><Form.Control type="date" name="deathDateRange.end" value={filters.deathDateRange.end} placeholder="End" onChange={handleFilterChange} /></Col>
                  </Row>
                </Form.Group>
                <Form.Check 
                  type="checkbox" 
                  id="noDeathDateCheck"
                  name="noDeathDate" 
                  label="Only show people with no death date (i.e., living)" 
                  checked={filters.noDeathDate}
                  onChange={handleFilterChange}
                />
              </Col>
              <Col md={12} className="text-end mt-3">
                <Button variant="outline-danger" onClick={handleClearFilters}>Clear Filters and Sort</Button>
              </Col>
            </Row>
          </div>
        </Collapse>
      </Form>
      {isLoading 
        ? 
          <div className="d-flex justify-content-center align-items-center" style={{minHeight: "40vh"}}>
            <Spinner animation="border" role="status"><span className="visually-hidden">Loading...</span></Spinner>
          </div>
        : 
          people.length > 0 
            ?
              <>
                <div className="d-flex justify-content-between align-items-center mb-3">
                  <p className="text-white-50 mb-0">{people.length} result{people.length > 1 && `s`} displayed</p>
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
                    {Array.isArray(people) && people.map((person) => (
                      <Person key={person.id} person={person} />
                    ))}
                  </tbody>
                </Table>
                <div className="d-flex justify-content-center mt-4">
                  {currentPage > 1 && <Button variant="primary" className="me-2" onClick={() => changePage(1)}>First Page</Button>}
                  {currentPage > 1 && <Button variant="primary" className="me-2" onClick={() => changePage(currentPage - 1)}>Previous</Button>}
                  {currentPage < pages && <Button variant="primary" onClick={() => changePage(currentPage + 1)}>Next</Button>}
                </div>
              </>
            :
              <p className="text-white-50 mt-5">No people available.</p>
      }
    </Container>
  );
}

export default People;