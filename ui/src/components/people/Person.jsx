import { Button } from "react-bootstrap";
import PersonForm from "../modals/PersonForm";
import { useState } from "react";

const Person = ({person}) => {
  const [showPersonModal, setShowPersonModal] = useState(false);
  const months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  
  function handleEditPersonClick() {
    setShowPersonModal(true);
  }

  const getBirthDate = (person) => {
    if (person.birth_date != null) {
      const birthDate = new Date(person.birth_date);

      const month = months[birthDate.getMonth()];
      let day = "";

      if (birthDate.getDate() == 1 || birthDate.getDate() == 21 || birthDate.getDate() == 31)
        day = birthDate.getDate() + "st";
      else if (birthDate.getDate() == 2 || birthDate.getDate() == 22)
        day = birthDate.getDate() + "nd";
      else if (birthDate.getDate() == 3 || birthDate.getDate() == 23)
        day = birthDate.getDate() + "rd";
      else
        day = birthDate.getDate() + "th";

      return month + " " + day + ", " + birthDate.getFullYear();
    }
  }

  const getDeathDate = (person) => {
    if (person.death_date != null) {
      const deathDate = new Date(person.death_date);

      const month = months[deathDate.getMonth()];
      let day = "";

      if (deathDate.getDate() == 1 || deathDate.getDate() == 21 || deathDate.getDate() == 31)
        day = deathDate.getDate() + "st";
      else if (deathDate.getDate() == 2 || deathDate.getDate() == 22)
        day = deathDate.getDate() + "nd";
      else if (deathDate.getDate() == 3 || deathDate.getDate() == 23)
        day = deathDate.getDate() + "rd";
      else
        day = deathDate.getDate() + "th";

      return month + " " + day + ", " + deathDate.getFullYear();
    }
  }

  const getAge = (person) => {
    if (person.birth_date != null) {
      if (person.death_date == null)
        return parseInt(parseInt(new Date() - new Date(person.birth_date)) / 31557600000);
      else
        return parseInt(parseInt(new Date(person.death_date) - new Date(person.birth_date)) / 31557600000);
    }
  }

  return (
    <>
      <tr>
        <td>{person.name}</td>
        <td>{getBirthDate(person)}</td>
        <td>{getDeathDate(person)}</td>
        <td>{getAge(person)}</td>
        <td></td>
        <td className="text-center">
          <Button variant="secondary" onClick={() => handleEditPersonClick()} className="me-1">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-pen" viewBox="0 0 16 16">
              <path d="m13.498.795.149-.149a1.207 1.207 0 1 1 1.707 1.708l-.149.148a1.5 1.5 0 0 1-.059 2.059L4.854 14.854a.5.5 0 0 1-.233.131l-4 1a.5.5 0 0 1-.606-.606l1-4a.5.5 0 0 1 .131-.232l9.642-9.642a.5.5 0 0 0-.642.056L6.854 4.854a.5.5 0 1 1-.708-.708L9.44.854A1.5 1.5 0 0 1 11.5.796a1.5 1.5 0 0 1 1.998-.001m-.644.766a.5.5 0 0 0-.707 0L1.95 11.756l-.764 3.057 3.057-.764L14.44 3.854a.5.5 0 0 0 0-.708z" />
            </svg>
          </Button>
        </td>
      </tr>
      <PersonForm show={showPersonModal} setShow={setShowPersonModal} person={person} />
    </>
  );
}

export default Person;