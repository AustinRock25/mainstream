import axios from "axios";
import PersonForm from "../modals/PersonForm";
import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";

function EditPerson() {
  const params = useParams();
  const [person, setPerson] = useState({ 
    id: "",
    name: "",
    birth_year: "",
    death_year: ""
  });

  useEffect(() => {
    axios.get(`/api/people/${params.id}`)
      .then(results => {
        setPerson({
          id: results.data.id,
          name: results.data.name,
          birth_year: results.data.birth_year,
          death_year: results.data.death_year
        });
      })
      .catch(error => {
        setAlert({ message: "Failed to load person.", variant: "danger" });
      })
      .finally(() => {
        setIsLoading(false);
      });
  }, []);

  return (
    <PersonForm show={true} person={{...person, id: params.id}} />
  );
}

export default EditPerson;
