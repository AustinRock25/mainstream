import { Button } from "react-bootstrap";
import PersonForm from "../modals/PersonForm";
import { useState } from "react";

const Person = ({person}) => {
  const [showPersonModal, setShowPersonModal] = useState(false);
  const months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  
  function handleEditPersonClick() {
    setShowPersonModal(true);
  }

  const getCredits = (person) => {
    let i = 0;
    let temp = new Array();
    if (!!person.credited_as_director) {
      for (let x = 0; x < person.credited_as_director.length; x++) {
        let z = 0;
        for (let y = 0; y < temp.length; y++) {
          if (temp[y].id == person.credited_as_director[x].id)
            break;
          else
            z++;
        }
        if (z == temp.length) {
          temp[i] = person.credited_as_director[x];
          i++;
        }
      }
    }
    if (!!person.credited_as_director_tv) {
      for (let x = 0; x < person.credited_as_director_tv.length; x++) {
        let z = 0;
        for (let y = 0; y < temp.length; y++) {
          if (temp[y].id == person.credited_as_director_tv[x].id) {
            if (new Date(person.credited_as_director_tv[x].start_date) < new Date(temp[y].start_date))
              temp[y].start_date = person.credited_as_director_tv[x].start_date;

            if (new Date(person.credited_as_director_tv[x].end_date) > new Date(temp[y].end_date))
              temp[y].end_date = person.credited_as_director_tv[x].end_date;

            break;
          }
          else
            z++;
        }
        if (z == temp.length) {
          temp[i] = person.credited_as_director_tv[x];
          i++;
        }
      }
    }
    if (!!person.credited_as_writer) {
      for (let x = 0; x < person.credited_as_writer.length; x++) {
        let z = 0;
        for (let y = 0; y < temp.length; y++) {
          if (temp[y].id == person.credited_as_writer[x].id)
            break;
          else
            z++;
        }
        if (z == temp.length) {
          temp[i] = person.credited_as_writer[x];
          i++;
        }
      }
    }
    if (!!person.credited_as_writer_tv) {
      for (let x = 0; x < person.credited_as_writer_tv.length; x++) {
        let z = 0;
        for (let y = 0; y < temp.length; y++) {
          if (temp[y].id == person.credited_as_writer_tv[x].id) {
            if (new Date(person.credited_as_writer_tv[x].start_date) < new Date(temp[y].start_date))
              temp[y].start_date = person.credited_as_writer_tv[x].start_date;

            if (new Date(person.credited_as_writer_tv[x].end_date) > new Date(temp[y].end_date))
              temp[y].end_date = person.credited_as_writer_tv[x].end_date;

            break;
          }
          else
            z++;
        }
        if (z == temp.length) {
          temp[i] = person.credited_as_writer_tv[x];
          i++;
        }
      }
    }
    if (!!person.credited_as_cast_member) {
      for (let x = 0; x < person.credited_as_cast_member.length; x++) {
        let z = 0;
        for (let y = 0; y < temp.length; y++) {
          if (temp[y].id == person.credited_as_cast_member[x].id)
            break;
          else
            z++;
        }
        if (z == temp.length) {
          temp[i] = person.credited_as_cast_member[x];
          i++;
        }
      }
    }
    if (!!person.credited_as_cast_member_tv) {
      for (let x = 0; x < person.credited_as_cast_member_tv.length; x++) {
        let z = 0;
        for (let y = 0; y < temp.length; y++) {
          if (temp[y].id == person.credited_as_cast_member_tv[x].id) {
            if (new Date(person.credited_as_cast_member_tv[x].start_date) < new Date(temp[y].start_date))
              temp[y].start_date = person.credited_as_cast_member_tv[x].start_date;

            if (new Date(person.credited_as_cast_member_tv[x].end_date) > new Date(temp[y].end_date))
              temp[y].end_date = person.credited_as_cast_member_tv[x].end_date;

            break;
          }
          else
            z++;
        }
        if (z == temp.length) {
          temp[i] = person.credited_as_cast_member_tv[x];
          i++;
        }
      }
    }
    if (!!person.credited_as_creator) {
      for (let x = 0; x < person.credited_as_creator.length; x++) {
        let z = 0;
        for (let y = 0; y < temp.length; y++) {
          if (temp[y].id == person.credited_as_creator[x].id) {
            if (new Date(person.credited_as_creator[x].start_date) < new Date(temp[y].start_date))
              temp[y].start_date = person.credited_as_creator[x].start_date;

            if (new Date(person.credited_as_creator[x].end_date) > new Date(temp[y].end_date))
              temp[y].end_date = person.credited_as_creator[x].end_date;

            break;
          }
          else
            z++;
        }
        if (z == temp.length) {
          temp[i] = person.credited_as_creator[x];
          i++;
        }
      }
    }

    temp.sort((a, b) => a.release_date > b.release_date || a.start_date > b.release_date || a.start_date > b.start_date || a.release_date > b.start_date ? 1 : -1);

    let text = ""
    for (let o = 0; o < temp.length; o++) {
      if (!!temp[o].end_date) {
        if (new Date(temp[o].end_date).getFullYear() == new Date(temp[o].start_date).getFullYear())
          text += `${temp[o].title} (${new Date(temp[o].start_date).getFullYear()})\n`;
        else if (new Date(temp[o].end_date).getFullYear() % 1000 == 0)
          text += `${temp[o].title} (${new Date(temp[o].start_date).getFullYear()}-${new Date(temp[o].end_date).getFullYear()})\n`;
        else if (new Date(temp[o].end_date).getFullYear() % 1000 < 10)
          text += `${temp[o].title} (${new Date(temp[o].start_date).getFullYear()}-0${new Date(temp[o].end_date).getFullYear() % 1000})\n`;
        else
          text += `${temp[o].title} (${new Date(temp[o].start_date).getFullYear()}-${new Date(temp[o].end_date).getFullYear() % 1000})\n`;
      }
      else
        text += `${temp[o].title} (${new Date(temp[o].release_date).getFullYear()})\n`;
    }
    console.log(text);
    return text;
  }

  const getBirthDate = (person) => {
    if (person.birth_date != null) {
      const birthDate = new Date(person.birth_date);

      const month = months[birthDate.getMonth()];
      let day = "";

      if (birthDate.getDate() % 10 == 1)
        day = birthDate.getDate() + "st";
      else if (birthDate.getDate() % 10 == 2)
        day = birthDate.getDate() + "nd";
      else if (birthDate.getDate() % 10 == 3)
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

  return (
    <>
      <tr>
        <td>{person.name}</td>
        <td>{getBirthDate(person)}</td>
        <td>{getDeathDate(person)}</td>
        <td>{getCredits(person)}</td>
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