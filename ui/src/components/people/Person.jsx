import { Button } from "react-bootstrap";
import PersonForm from "../modals/PersonForm";
import { useState } from "react";

const Person = ({person}) => {
  const [showPersonModal, setShowPersonModal] = useState(false);

  function handleEditPersonClick() {
    setShowPersonModal(true);
  }

  const formatDate = (dateValue) => {
    if (!dateValue) 
      return "";

    const dateStr = new Date(dateValue).toISOString().split('T')[0];
    const [year, month, day] = dateStr.split('-').map(Number);
    const date = new Date(Date.UTC(year, month - 1, day));
    const dayOfMonth = date.getUTCDate();
    let suffix = "th";

    if (dayOfMonth % 10 === 1 && dayOfMonth % 100 !== 11)
       suffix = "st";
    else if (dayOfMonth % 10 === 2 && dayOfMonth % 100 !== 12)
       suffix = "nd";
    else if (dayOfMonth % 10 === 3 && dayOfMonth % 100 !== 13)
       suffix = "rd";

    return `${date.toLocaleDateString("en-US", { month: "long", timeZone: "UTC" })} ${dayOfMonth}${suffix}, ${date.getUTCFullYear()}`;
  };

  const getAge = (birthDate, deathDate) => {
    if (!birthDate) 
      return "";

    const start = new Date(birthDate);
    const end = deathDate ? new Date(deathDate) : new Date();
    let age = end.getUTCFullYear() - start.getUTCFullYear();
    const m = end.getUTCMonth() - start.getUTCMonth();

    if (m < 0 || (m === 0 && end.getUTCDate() < start.getUTCDate()))
      age--;

    return Number.isNaN(age) ? "" : age;
  };

  return (
    <>
      <tr>
        <td>{person.name}</td>
        <td>{formatDate(person.birth_date)}</td>
        <td>{!!person.death_date && formatDate(person.death_date)}</td>
        <td>{getAge(person.birth_date, person.death_date)}</td>
        <td className="text-center">
          <Button variant="outline-light" size="sm" onClick={handleEditPersonClick}>Edit</Button>
        </td>
      </tr>
      <PersonForm show={showPersonModal} setShow={setShowPersonModal} person={person} />
    </>
  );
}

export default Person;