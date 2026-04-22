import AdminOnlyLayout from "./layouts/AdminOnlyLayout";
import "./App.css";
import ApplicationLayout from "./layouts/ApplicationLayout";
import Home from "./components/Home";
import Media from "./components/media/Media";
import NotFound from "./components/NotFound";
import People from "./components/people/People";
import { Route, Routes } from "react-router-dom";

function App() {
  return (
    <Routes>
      <Route element={<ApplicationLayout />}>
        <Route path="/" element={<Home />} />
        <Route path="/media" element={<Media />} />
        <Route element={<AdminOnlyLayout />}>
          <Route path="/people" element={<People />} />
        </Route>
        <Route path="/*" element={<NotFound />} />
      </Route>
    </Routes>
  );
}

export default App;
