import { register, login, logout, verifyToken, changeScale } from "../controllers/authController.js";
import { authenticate } from "../middleware/auth.js";
import { Router } from "express";
const router = Router();
import { validateUser } from "../middleware/recordValidation.js";

router.post("/register", validateUser, register);
router.post("/login", login);
router.post("/logout", logout);
router.get("/verifyToken", authenticate, verifyToken);
router.put("/change/:id", authenticate, changeScale);

export default router;