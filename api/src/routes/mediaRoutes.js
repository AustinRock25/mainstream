import { authorizeAdmin } from "../middleware/auth.js";
import { index, indexLength, indexShows, seasonCount, indexNew, show, create, update } from "../controllers/mediaController.js";
import { Router } from "express";
const router = Router();
import { validateMedia, validateMediaUpdate } from "../middleware/recordValidation.js";

router.get("/", index);
router.get("/length", indexLength);
router.get("/shows", indexShows);
router.get("/seasons", seasonCount);
router.get("/new", indexNew);
router.get("/:id", show);
router.post("/", [authorizeAdmin, validateMedia], create);
router.put("/:id", [authorizeAdmin, validateMediaUpdate], update);

export default router;