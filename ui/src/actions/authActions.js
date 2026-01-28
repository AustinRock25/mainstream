import { authenticated, unauthenticated } from "../slices/authSlice.js";
import api from "../api";
import store from "../store.js";

const verifyToken = () => {
  api.get("/auth/verifyToken")
  .then(response => {
    store.dispatch(authenticated(response.data));
  })
  .catch(error => {
    store.dispatch(unauthenticated());
  });
}

export { verifyToken };