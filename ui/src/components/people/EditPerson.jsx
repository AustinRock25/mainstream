import api from "../api";
import PersonForm from "../modals/PersonForm";
import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";

function EditPerson() {
  const params = useParams();

  const [person, setPerson] = useState({ 
    id: "",
    name: "",
    birth_date: "",
    death_date: ""
  });

  useEffect(() => {
    api.get(`/people/${params.id}`)
    .then(results => {
      setPerson({
        id: results.data.id,
        name: results.data.name,
        birth_date: results.data.birth_date,
        death_date: results.data.death_date
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
