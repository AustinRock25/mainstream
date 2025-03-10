import AdminOnlyLayout from "./layouts/AdminOnlyLayout";
import "./App.css";
import ApplicationLayout from "./layouts/ApplicationLayout";
import EditMedia from "./components/media/EditMedia";
import EditPerson from "./components/people/EditPerson";
import Home from "./components/Home";
import Media from "./components/media/Media";
import NewMedia from "./components/media/NewMedia";
import NewPerson from "./components/people/NewPerson";
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
          <Route path="/media/new" element={<NewMedia />} />
          <Route path="/media/:id/edit" element={<EditMedia />} />
          <Route path="/people/new" element={<NewPerson />} />
          <Route path="/people/:id/edit" element={<EditPerson />} />
        </Route>
        <Route path="/*" element={<NotFound />} />
      </Route>
    </Routes>
  );
}

export default App;
