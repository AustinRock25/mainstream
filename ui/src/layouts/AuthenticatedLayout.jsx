import { Outlet } from "react-router-dom";
import Unauthenticated from "../components/Unauthenticated";
import { useSelector } from "react-redux";

const AuthenticatedLayout = () => {
  const { isAuthenticated } = useSelector(state => state.auth);

  return (
    <>
      {isAuthenticated ? <Outlet /> : <Unauthenticated />}
    </>
  )
}

export default AuthenticatedLayout;