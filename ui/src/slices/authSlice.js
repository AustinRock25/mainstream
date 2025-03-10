import { createSlice } from "@reduxjs/toolkit";

const authSlice = createSlice({
  initialState: {
    isAuthenticated: false,
    isAdmin: false,
    user: null
  },
  name: "auth",
  reducers: {
    authenticated: (state, action) => {
      state.isAuthenticated = true;
      state.isAdmin = action.payload.is_admin;
      state.user = action.payload;
    },
    unauthenticated: (state, action) => {
      state.isAuthenticated = false;
      state.isAdmin = false;
      state.user = null;
    }
  }
});

export const { authenticated, unauthenticated } = authSlice.actions;
export default authSlice.reducer;