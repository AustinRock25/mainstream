import { createSlice } from "@reduxjs/toolkit";

const initialRatingScale = localStorage.getItem("rating_scale") ? JSON.parse(localStorage.getItem("rating_scale")) : 16;

const authSlice = createSlice({
  initialState: {
    isAuthenticated: false,
    isAdmin: false,
    user: null,
    ratingScale: initialRatingScale
  },
  name: "auth",
  reducers: {
    authenticated: (state, action) => {
      state.isAuthenticated = true;
      state.isAdmin = action.payload.is_admin;
      state.user = action.payload;
      state.ratingScale = action.payload.rating_scale;
    },
    unauthenticated: (state, action) => {
      state.isAuthenticated = false;
      state.isAdmin = false;
      state.user = null;
    },
    setRatingScale: (state, action) => {
      state.ratingScale = action.payload;
      if (!state.isAuthenticated) {
        localStorage.setItem("rating_scale", JSON.stringify(action.payload));
      }
    }
  }
});

export const { authenticated, unauthenticated, setRatingScale } = authSlice.actions;
export default authSlice.reducer;