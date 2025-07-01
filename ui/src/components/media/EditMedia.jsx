import axios from "axios";
import MediaForm from "../modals/MediaForm";
import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";

function EditMedia() {
  const params = useParams();
  const [media, setMedia] = useState({ 
    id: "",
    title: "", 
    season: "",
    score: 0, 
    score_tv: 0,
    rating: "",
    release_date: "", 
    start_date: "",
    end_date: "",
    year: "",
    poster: "", 
    runtime: "",
    episodes: "",
    completed: "",
    type: "",
    directors: [],
    cast_members: [],
    writers: [],
    creators: []
  });
  let selectedDirectors = [];
  let selectedCastMembers = [];
  let selectedWriters = [];
  let selectedCreators = [];

  useEffect(() => {
    axios.get(`/api/media/${params.id}`)
      .then(results => {
        if (!!results.data.directors) {
          for (let x = 0; x < results.data.directors.length; x++)
            selectedDirectors[x] = results.data.directors[x].director_id;
        }
        if (!!results.data.directors_tv) {
          for (let x = 0; x < results.data.directors_tv.length; x++)
            selectedDirectors[x] = results.data.directors_tv[x].director_id;
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
        if (!!results.data.writers_tv) {
          for (let x = 0; x < results.data.writers_tv.length; x++)
            selectedWriters[x] = results.data.writers_tv[x].writer_id;
        }
        if (!!results.data.creators) {
          for (let x = 0; x < results.data.creators.length; x++)
            selectedCreators[x] = results.data.creators[x].creator_id;
        }
        setMedia({
          id: results.data.id,
          title: results.data.title, 
          season: results.data.season,
          score: results.data.score, 
          score_tv: results.data.score_tv,
          rating: results.data.rating,
          release_date: results.data.release_date, 
          start_date: results.data.start_date,
          end_date: results.data.end_date,
          poster: results.data.poster, 
          runtime: results.data.runtime,
          episodes: results.data.episodes,
          type: results.data.type,
          completed: results.data.completed,
          directors: selectedDirectors,
          cast_members: selectedCastMembers,
          writers: selectedWriters,
          creators: selectedCreators
        });
        if (media.type == "show")
          setMedia({ score: results.data.score_tv })
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
