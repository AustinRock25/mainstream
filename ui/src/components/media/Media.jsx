import { Alert, Button, Container, Row, Spinner, Form, Col, Collapse } from "react-bootstrap";
import axios from "axios";
import MediaCard from "./MediaCard";
import { useCallback, useEffect, useState } from "react";
import { useSelector } from "react-redux";

const safeEncode = (value) => value.replace(/[./-]+/g, "__");
const RATINGS = ["Not Rated", "G", "PG", "PG-13", "R", "NC-17", "TV-Y", "TV-Y7", "TV-Y7 FV", "TV-G", "TV-PG", "TV-14", "TV-MA"];
const RATINGSTV = ["Not Rated", "TV-Y", "TV-Y7", "TV-Y7 FV", "TV-G", "TV-PG", "TV-14", "TV-MA"];
const GRADES1 = ["0/4", "0.5/4", "1/4", "1.5/4", "2/4", "2.5/4", "3/4", "3.5/4", "4/4"];
const GRADES2 = ["0/5", "0.5/5", "1/5", "1.5/5", "2/5", "2.5/5", "3/5", "3.5/5", "4/5", "4.5/5", "5/5"];
const GRADES3 = ["F", "D-", "D", "D+", "C-", "C", "C+", "B-", "B", "B+", "A-", "A", "A+"];

const getInitialState = () => {
  const savedState = localStorage.getItem("mediaFilters");

  const defaults = {
    searchTerm: "",
    sortBy: "release_date",
    sortOrder: "DESC",
    filterType: "all",
    runtime: { min: "", max: "" },
    episodes: { min: "", max: "" },
    selectedRatings: [],
    selectedGrade: "",
    dateRange: { start: "", end: "" },
  };

  return savedState ? JSON.parse(savedState) : defaults;
};

const getDefaultState = () => ({
  searchTerm: "",
  sortBy: "release_date",
  sortOrder: "DESC",
  filterType: "all",
  runtime: { min: "", max: "" },
  episodes: { min: "", max: "" },
  selectedRatings: [],
  selectedGrade: "",
  dateRange: { start: "", end: "" },
});

function Media() {
  const [alert, setAlert] = useState({ message: "", variant: "" });
  const [currentPage, setCurrentPage] = useState(1);
  const [isLoading, setIsLoading] = useState(false);
  const [media, setMedia] = useState([]);
  const [pages, setPages] = useState(0);
  const [filters, setFilters] = useState(getInitialState);
  const [open, setOpen] = useState(false);
  const { user } = useSelector(state => state.auth);

  useEffect(() => {
    localStorage.setItem("mediaFilters", JSON.stringify(filters));
  }, [filters]);

  const fetchMediaData = useCallback((page, currentFilters) => {
    setIsLoading(true);
    const beginRecord = (page - 1) * 60 + 1;
    const endRecord = page * 60;

    const params = {
      beginRecord,
      endRecord,
      searchTerm: currentFilters.searchTerm,
      sortBy: currentFilters.sortBy,
      sortOrder: currentFilters.sortOrder,
      filterType: currentFilters.filterType,
      minRuntime: currentFilters.runtime.min,
      maxRuntime: currentFilters.runtime.max,
      minEpisodes: currentFilters.episodes.min,
      maxEpisodes: currentFilters.episodes.max,
      ratings: currentFilters.selectedRatings.join(","),
      grade: currentFilters.selectedGrade,
      startDate: currentFilters.dateRange.start,
      endDate: currentFilters.dateRange.end,
    };

    Object.keys(params).forEach(key => (params[key] === "" || params[key] === null || params[key] === undefined) && delete params[key]);

    Promise.all([
      axios.get("/api/media/length", { params }),
      axios.get("/api/media", { params })
    ])
    .then(([lengthResponse, mediaResponse]) => {
      const count = lengthResponse.data[0].count;
      setPages(Math.ceil(count / 60));
      setMedia(mediaResponse.data);
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
    fetchMediaData(1, filters);
  }, [fetchMediaData, filters]);

  const handleFilterChange = (e) => {
    setCurrentPage(1);
    const { name, value, type, checked } = e.target;
    
    if (name === "filterType") {
      setFilters(prev => ({
        ...prev,
        filterType: value,
        runtime: { min: "", max: "" },
        episodes: { min: "", max: "" },
      }));

      return;
    }
    
    if (name.includes(".")) {
      const [parent, child] = name.split(".");

      setFilters(prev => ({
        ...prev,
        [parent]: { ...prev[parent], [child]: value }
      }));

      return;
    }
    
    if (type === "checkbox") {
      const delimiterIndex = name.indexOf("__");

      if (delimiterIndex !== -1) {
        const key = name.substring(0, delimiterIndex);
        const encodedValue = name.substring(delimiterIndex + 2);
        let originalValue;

        if (key === "selectedRatings")
          originalValue = RATINGS.find(r => safeEncode(r) === encodedValue);
        
        if (originalValue) {
          setFilters(prev => ({
            ...prev,
            [key]: checked ? [...prev[key], originalValue] : prev[key].filter(v => v !== originalValue)
          }));
        }
      }
      return;
    }

    setFilters(prev => ({ ...prev, [name]: value }));
  };

  const handleApplyFilters = (e) => {
    e.preventDefault();
    setCurrentPage(1);
    fetchMediaData(1, filters);
  };
  
  const handleClearFilters = (e) => {
    e.preventDefault();
    const defaultState = getDefaultState();
    setFilters(defaultState);
    setCurrentPage(1);
    fetchMediaData(1, defaultState);
  };
  
  const changePage = (pageNumber) => {
    setMedia([]);
    setCurrentPage(pageNumber);
    fetchMediaData(pageNumber, filters);
  }

  return (
    <Container className="pt-3 text-center">
      {alert?.message && <Alert variant={alert.variant} onClose={() => setAlert({ message: "", variant: "" })} dismissible>{alert.message}</Alert>}
      <h2 className="fw-bolder text-white mb-4">Films and TV Shows</h2>
      <Form onSubmit={handleApplyFilters} className="mb-4">
        <Row className="justify-content-center">
          <Col md={8} lg={6} className="d-flex">
            <Form.Control
              type="text"
              name="searchTerm"
              value={filters.searchTerm}
              onChange={handleFilterChange}
              placeholder="Enter title..."
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
                    <option value="release_date">Release Date</option>
                    <option value="title">Title</option>
                    <option value="grade">Grade</option>
                    <option value="runtime">Runtime</option>
                    {filters.filterType === "show" && <option value="episodes">Episode Count</option>}
                  </Form.Select>
                </Form.Group>
              </Col>
              <Col md={6}>
                <Form.Group>
                  <Form.Label>Order</Form.Label>
                  <Form.Select name="sortOrder" value={filters.sortOrder} onChange={handleFilterChange}>
                    <option value="DESC">Descending</option>
                    <option value="ASC">Ascending</option>
                  </Form.Select>
                </Form.Group>
              </Col>
              <Col md={12}><hr /></Col>
              <Col md={4}>
                <Form.Group>
                  <Form.Label>Media Type</Form.Label>
                  <Form.Select name="filterType" value={filters.filterType} onChange={handleFilterChange}>
                    <option value="all">All</option>
                    <option value="movie">Movies</option>
                    <option value="show">TV Shows</option>
                  </Form.Select>
                </Form.Group>
              </Col>
              <Col md={4}>
                <Form.Group>
                  <Form.Label>Release Date Start</Form.Label>
                  <Form.Control type="date" name="dateRange.start" value={filters.dateRange.start} onChange={handleFilterChange} />
                </Form.Group>
              </Col>
              <Col md={4}>
                <Form.Group>
                  <Form.Label>Release Date End</Form.Label>
                  <Form.Control type="date" name="dateRange.end" value={filters.dateRange.end} onChange={handleFilterChange} />
                </Form.Group>
              </Col>
              <Col md={12}>
                <Form.Label>Runtime (minutes)</Form.Label>
                <Row>
                  <Col>
                    <Form.Control type="number" name="runtime.min" value={filters.runtime.min} placeholder="Min" onChange={handleFilterChange} />
                  </Col>
                  <Col>
                    <Form.Control type="number" name="runtime.max" value={filters.runtime.max} placeholder="Max" onChange={handleFilterChange} />
                  </Col>
                </Row>
              </Col>
              {filters.filterType === "show" && (
                <Col md={12}>
                  <Form.Label>Episode Count</Form.Label>
                  <Row>
                    <Col>
                      <Form.Control type="number" name="episodes.min" value={filters.episodes.min} placeholder="Min" onChange={handleFilterChange} />
                    </Col>
                    <Col>
                      <Form.Control type="number" name="episodes.max" value={filters.episodes.max} placeholder="Max" onChange={handleFilterChange} />
                    </Col>
                  </Row>
                </Col>
              )}
              <Col md={12}>
                <Form.Label>Ratings</Form.Label>
                <div className="d-flex flex-wrap" style={{ maxHeight: "150px", overflowY: "auto" }}>
                  {filters.filterType === "show" 
                    ? 
                      RATINGSTV.map(rating => (
                        <Form.Check 
                          key={rating} 
                          type="checkbox" 
                          name={`selectedRatings__${safeEncode(rating)}`} 
                          label={rating} 
                          checked={filters.selectedRatings.includes(rating)} 
                          onChange={handleFilterChange} 
                          className="me-3"
                        />
                      )) 
                    : 
                      RATINGS.map(rating => (
                        <Form.Check 
                          key={rating} 
                          type="checkbox" 
                          name={`selectedRatings__${safeEncode(rating)}`} 
                          label={rating} 
                          checked={filters.selectedRatings.includes(rating)} 
                          onChange={handleFilterChange} 
                          className="me-3"
                        />
                      ))
                  }
                </div>
              </Col>
              <Col md={12}>
                <Form.Label>Grades</Form.Label>
                <div className="d-flex flex-wrap" style={{ maxHeight: "150px", overflowY: "auto" }}>
                {
                  (!user || user.rating_scale == 2) ? GRADES2.map(grade => (
                    <Form.Check 
                      key={grade} 
                      type="radio" 
                      name="selectedGrade"
                      value={grade}
                      label={grade} 
                      checked={filters.selectedGrade === grade} 
                      onChange={handleFilterChange} 
                      className="me-3"
                    />
                  )) :
                  user.rating_scale == 1 ? GRADES1.map(grade => (
                    <Form.Check 
                      key={grade} 
                      type="radio" 
                      name="selectedGrade" 
                      value={grade}
                      label={grade} 
                      checked={filters.selectedGrade === grade} 
                      onChange={handleFilterChange} 
                      className="me-3"
                    />
                  )) : 
                  user.rating_scale == 3 && GRADES3.map(grade => (
                    <Form.Check 
                      key={grade} 
                      type="radio" 
                      name="selectedGrade"
                      value={grade}
                      label={grade} 
                      checked={filters.selectedGrade === grade} 
                      onChange={handleFilterChange} 
                      className="me-3"
                    />
                  ))}
                </div>
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
          (
            <div className="d-flex justify-content-center align-items-center" style={{minHeight: "40vh"}}>
              <Spinner animation="border" role="status"><span className="visually-hidden">Loading...</span></Spinner>
            </div>
          ) 
        : 
          media.length > 0 
            ? 
              (
                <>
                  <div className="d-flex justify-content-between align-items-center mb-3">
                    <p className="text-white-50 mb-0">{media.length} result{media.length > 1 && `s`} displayed</p>
                    <h6 className="fw-bolder text-white mb-0">Page {currentPage} of {pages}</h6>
                  </div>
                  <Row className="g-4 justify-content-center" xs={1} sm={2} md={3} lg={4} xl={5}>
                    {media.map(m => <MediaCard key={`${m.id}-${m.type}-${m.season || ''}`} media={m} />)}
                  </Row>
                  <div className="d-flex justify-content-center mt-4">
                    {currentPage > 1 && <Button variant="primary" className="me-2" onClick={() => changePage(1)}>First Page</Button>}
                    {currentPage > 1 && <Button variant="primary" className="me-2" onClick={() => changePage(currentPage - 1)}>Previous</Button>}
                    {currentPage < pages && <Button variant="primary" onClick={() => changePage(currentPage + 1)}>Next</Button>}
                  </div>
                </>
              ) 
            : 
              <p className="text-white-50 mt-5">No results found with the specified criteria.</p>
      }
    </Container>
  );
}

export default Media;