import { Outlet } from "react-router-dom";
import Unauthorized from "../components/Unauthorized";
import { useSelector } from "react-redux";

const AdminOnlyLayout = () => {
  const { isAdmin, isAuthenticated } = useSelector(state => state.auth);

  return (
    <>
      {isAuthenticated && isAdmin ? <Outlet /> : <Unauthorized />}
    </>
  )
}

export default AdminOnlyLayout;