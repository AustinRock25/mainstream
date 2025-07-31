import { Button } from "react-bootstrap";
import PersonForm from "../modals/PersonForm";
import { useState, useMemo } from "react";

const Person = ({person}) => {
  const [showPersonModal, setShowPersonModal] = useState(false);

  function handleEditPersonClick() {
    setShowPersonModal(true);
  }

  const getCredits = useMemo(() => {
    const creditsMap = new Map();

    const processCredits = (creditList, type) => {
      if (!creditList) 
        return;
      
      creditList.forEach(credit => {
        const id = credit.id;
        if (!creditsMap.has(id)) {
          creditsMap.set(id, {
            title: credit.title,
            release_date: credit.release_date,
            start_date: credit.start_date,
            end_date: credit.end_date
          });
        } 
        else {
          const existing = creditsMap.get(id);
          if (credit.start_date && new Date(credit.start_date) < new Date(existing.start_date))
            existing.start_date = credit.start_date;

          if (credit.end_date && new Date(credit.end_date) > new Date(existing.end_date))
            existing.end_date = credit.end_date;
        }
      });
    };
    
    processCredits(person.credited_as_director, "movie");
    processCredits(person.credited_as_director_tv, "tv");
    processCredits(person.credited_as_writer, "movie");
    processCredits(person.credited_as_writer_tv, "tv");
    processCredits(person.credited_as_cast_member, "movie");
    processCredits(person.credited_as_cast_member_tv, "tv");
    processCredits(person.credited_as_creator, "tv");

    const sortedCredits = Array.from(creditsMap.values()).sort((a, b) => {
      const dateA = new Date(a.release_date || a.start_date);
      const dateB = new Date(b.release_date || b.start_date);
      return dateA - dateB;
    });

    return sortedCredits.map(credit => {
      let year;
      if (credit.end_date) {
        const startYear = new Date(credit.start_date).getFullYear();
        const endYear = new Date(credit.end_date).getFullYear();
        year = startYear === endYear ? startYear : `${startYear}–${String(endYear).slice(-2)}`;
      } 
      else
        year = new Date(credit.release_date).getFullYear();

      return `${credit.title} (${year})`;
    });
  }, [person]);


  const formatDate = (dateString) => {
    if (!dateString) 
      return "";

    const date = new Date(dateString);
    return date.toLocaleDateString("en-US", { year: "numeric", month: "long", day: "numeric", timeZone: "UTC" });
  };

  const getAge = (birthDate, deathDate) => {
    if (!birthDate) 
      return "";

    const start = new Date(birthDate);
    const end = deathDate ? new Date(deathDate) : new Date();
    let age = end.getFullYear() - start.getFullYear();
    const m = end.getMonth() - start.getMonth();
    if (m < 0 || (m === 0 && end.getDate() < start.getDate()))
      age--;

    return age;
  };

  return (
    <>
      <tr>
        <td>{person.name}</td>
        <td>{formatDate(person.birth_date)}</td>
        <td>{person.death_date ? formatDate(person.death_date) : ""}</td>
        <td>{getAge(person.birth_date, person.death_date)}</td>
        <td>
          {getCredits.map((credit, index) => (
            <div key={index} style={{fontSize: "0.85rem"}} className="text-white-50">{credit}</div>
          ))}
        </td>
        <td className="text-center">
          <Button variant="outline-light" size="sm" onClick={handleEditPersonClick}>
            Edit
          </Button>
        </td>
      </tr>
      <PersonForm show={showPersonModal} setShow={setShowPersonModal} person={person} />
    </>
  );
}

export default Person;