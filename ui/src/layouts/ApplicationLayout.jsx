import AuthModal from "../components/modals/AuthModal";
import axios from "axios";
import { Container, Image, Nav, Navbar } from "react-bootstrap";
import MediaForm from "../components/modals/MediaForm";
import { NavLink, Outlet, useLocation, useNavigate } from "react-router-dom";
import PersonForm from "../components/modals/PersonForm";
import { unauthenticated } from "../slices/authSlice";
import { useDispatch, useSelector } from "react-redux";
import { useEffect, useState } from "react";
import { verifyToken } from "../actions/authActions";

function ApplicationLayout() {
  const [authAction, setAuthAction] = useState("");
  const dispatch = useDispatch();
  const { isAdmin, isAuthenticated, user } = useSelector(state => state.auth);
  const location = useLocation();
  const navigate = useNavigate();
  const [showAuthModal, setShowAuthModal] = useState(false);
  const [showMediaModal, setShowMediaModal] = useState(false);
  const [showPersonModal, setShowPersonModal] = useState(false);

  useEffect(() => {
    verifyToken();
  }, [location.pathname]);

  function handleRegisterClick() {
    setAuthAction("register");
    setShowAuthModal(true);
  }

  function handleLoginClick() {
    setAuthAction("login");
    setShowAuthModal(true);
  }

  function handleAddMediaClick() {
    setShowMediaModal(true);
  }

  function handleAddPersonClick() {
    setShowPersonModal(true);
  }

  function handleLogoutClick() {
    axios.post("/api/auth/logout")
    .then(response => {
      dispatch(unauthenticated());
      navigate("/");
    });
  }

  return (
    <div id="background" className="min-vh-100">
      <Container id="container" className="min-vh-100 d-flex flex-column px-0">
        <header id="header">
          <div className="text-center py-4">
            <Image src="mainstream.jpg" fluid style={{ maxHeight: "150px", borderRadius: "8px" }}/>
            {!!user &&
              <div className="text-center text-white-50 py-2 fw-bold small mt-3">Logged in as: {user.email} {isAdmin && <span>(Admin)</span>}</div>
            }
          </div>
          <Navbar expand="lg" className="justify-content-between sticky-top" bg="dark" variant="dark">
             <Container>
              <Navbar.Toggle aria-controls="basic-navbar-nav" />
              <Navbar.Collapse id="basic-navbar-nav">
                <Nav className="me-auto">
                  <Nav.Link as={NavLink} to="/">Home</Nav.Link>
                  <Nav.Link as={NavLink} to="/media">Films & Shows</Nav.Link>
                  {isAdmin && <Nav.Link as={NavLink} to="/people">Cast & Crew</Nav.Link>}
                </Nav>
                <Nav>
                  {isAdmin && <Nav.Link onClick={handleAddMediaClick}>Add Media</Nav.Link>}
                  {isAdmin && <Nav.Link onClick={handleAddPersonClick}>Add Person</Nav.Link>}
                  {isAuthenticated 
                    ?
                      <>
                        <Nav.Link onClick={handleLogoutClick}>Log Out</Nav.Link>
                      </>
                    :
                      <>
                        <Nav.Link onClick={handleLoginClick}>Log In</Nav.Link>
                        <Nav.Link onClick={handleRegisterClick}>Register</Nav.Link>
                      </>
                  }
                </Nav>
              </Navbar.Collapse>
            </Container>
          </Navbar>
        </header>
        <main id="body" className="px-3 py-4 flex-grow-1">
          <Outlet />
        </main>
        <AuthModal show={showAuthModal} action={authAction} setShow={setShowAuthModal}  />
        <MediaForm show={showMediaModal} setShow={setShowMediaModal} />
        <PersonForm show={showPersonModal} setShow={setShowPersonModal} />
      </Container>
    </div>
  );
}

export default ApplicationLayout;