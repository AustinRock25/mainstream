import { authenticated, unauthenticated } from "../slices/authSlice.js";
import axios from "axios";
import store from "../store.js";


const verifyToken = () => {
  axios.get("/api/auth/verifyToken")
    .then(response => {
      store.dispatch(authenticated(response.data));
    })
    .catch(error => {
      store.dispatch(unauthenticated());
    });
}

export { verifyToken };