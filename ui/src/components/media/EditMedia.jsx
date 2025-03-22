import axios from "axios";
import MediaForm from "../modals/MediaForm";
import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";

function EditMedia() {
  const params = useParams();
  const [media, setMedia] = useState({ 
    id: "",
    title: "", 
    score: "", 
    rating: "", 
    release_date: "",
    poster: "", 
    runtime: "", 
    min_episode_runtime: "",
    max_episode_runtime: "",
    end_date: "",
    seasons: "",
    episodes: "",
    watched: "",
    type: "",
    directors: [],
    cast_members: []
  });
  let selectedDirectors = [];
  let selectedCastMembers = [];

  useEffect(() => {
    axios.get(`/api/media/${params.id}`)
      .then(results => {
        if (results.data.type == "movie") {
          for (let x = 0; x < results.data.directors.length; x++)
            selectedDirectors[x] = results.data.directors[x].director_id;
        }
        for (let x = 0; x < results.data.cast_members.length; x++)
          selectedDirectors[x] = results.data.cast_members[x].actor_id;
        setMedia({
          id: results.data.id,
          title: results.data.title,
          score: results.data.score,
          rating: results.data.rating,
          release_date: results.data.release_date,
          poster: results.data.poster,
          runtime: results.data.runtime,
          min_episode_runtime: results.data.min_episode_runtime,
          max_episode_runtime: results.data.max_episode_runtime,
          end_date: results.data.end_date,
          seasons: results.data.seasons,
          episodes: results.data.episodes,
          watched: results.data.watched,
          type: results.data.type,
          directors: selectedDirectors,
          cast_members: selectedCastMembers
        });
      })
      .catch(error => {
        setAlert({ message: "Failed to load media.", variant: "danger" });
      })
      .finally(() => {
        setIsLoading(false);
      });
  }, []);

  return (
    <MediaForm show={true} media={{...media, id: params.id}} />
  );
}

export default EditMedia;
