import AuthModal from "../components/modals/AuthModal";
import axios from "axios";
import { Container, Image, Nav, Navbar } from "react-bootstrap";
import MediaForm from "../components/modals/MediaForm";
import { NavLink, Outlet, useLocation } from "react-router-dom";
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
      })
      .catch(error => {
      });
  }

  return (
    <div id="background" className="min-vh-100">
      <Container id="container" className="min-vh-100 d-flex flex-column">
        <div id="header">
          <div className="text-center py-5 px-3">
            <Image src="../../public/mainstream.jpg" fluid/>
            {!!user && 
              <div className="text-center text-white py-2 fw-bold bg-secondary">Logged in under {isAdmin && <span>Admin</span>}</div>
            }
          </div>
          <Navbar className="justify-content-between bg-secondary">
            <Nav className="bg-secondary">
              <Nav.Link as={NavLink} to="/">Home</Nav.Link>
              <Nav.Link as={NavLink} to="/media">Films & Shows</Nav.Link>
              {isAdmin && <Nav.Link as={NavLink} to="/people">Actors & Directors</Nav.Link>}
            </Nav>
            <Nav className="bg-secondary justify-content-end">
              {isAdmin && <Nav.Link onClick={handleAddMediaClick}>Add Media</Nav.Link>}
              {isAdmin && <Nav.Link onClick={handleAddPersonClick}>Add Person</Nav.Link>}
              {isAuthenticated ?
                <Nav.Link onClick={handleLogoutClick}>Log out</Nav.Link>
                :
                <>
                  <Nav.Link onClick={handleLoginClick}>Log in</Nav.Link>
                  <Nav.Link onClick={handleRegisterClick}>Register</Nav.Link>
                </>
              }
            </Nav>
          </Navbar>
        </div>
        <div id="body" className="px-2 py-3 mt-0 flex-grow-1 bg-black">
          <Outlet />
        </div>
        <AuthModal show={showAuthModal} action={authAction} setShow={setShowAuthModal} />
        <MediaForm show={showMediaModal} setShow={setShowMediaModal} />
        <PersonForm show={showPersonModal} setShow={setShowPersonModal} />
      </Container>
    </div>
  );
}

export default ApplicationLayout;