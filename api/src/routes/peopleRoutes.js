import { authorizeAdmin } from "../middleware/auth.js";
import { index, indexLength, indexSelect, show, create, update } from "../controllers/peopleController.js";
import { Router } from "express";
const router = Router();
import { validatePerson } from "../middleware/recordValidation.js";

router.get("/", index);
router.get("/length", indexLength);
router.get("/select", indexSelect);
router.get("/:id", show);
router.post("/", [authorizeAdmin, validatePerson], create);
router.put("/:id", [authorizeAdmin, validatePerson], update);

export default router;