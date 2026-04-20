import api from "../../api";
import MediaForm from "../modals/MediaForm";
import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";

function EditMedia() {
  const params = useParams();

  const [media, setMedia] = useState({ 
    id: "",
    title: "", 
    grade: 0, 
    rating: "",
    release_date: "",
    poster: "", 
    runtime: "",
    completed: "",
    type: "",
    directors: [],
    cast_members: [],
    writers: [],
    episodes: []
  });

  let selectedDirectors = [];
  let selectedCastMembers = [];
  let selectedWriters = [];

  useEffect(() => {
    api.get(`/media/${params.id}`)
      .then(results => {
        if (!!results.data.directors) {
          for (let x = 0; x < results.data.directors.length; x++)
            selectedDirectors[x] = results.data.directors[x].director_id;
        }

        if (!!results.data.cast_members) {
          for (let x = 0; x < results.data.cast_members.length; x++)
            selectedCastMembers[x] = results.data.cast_members[x].actor_id;
        }

        if (!!results.data.cast_members_tv) {
          for (let x = 0; x < results.data.cast_members_tv.length; x++)
            selectedCastMembers[x] = results.data.cast_members_tv[x].actor_id;
        }

        if (!!results.data.writers) {
          for (let x = 0; x < results.data.writers.length; x++)
            selectedWriters[x] = results.data.writers[x].writer_id;
        }

        setMedia({
          id: results.data.id,
          title: results.data.title, 
          grade: results.data.grade, 
          rating: results.data.rating,
          release_date: results.data.release_date, 
          poster: results.data.poster, 
          runtime: results.data.runtime,
          type: results.data.type,
          completed: results.data.completed,
          directors: selectedDirectors,
          cast_members: selectedCastMembers,
          writers: selectedWriters,
          episodes: results.data.episodes
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
