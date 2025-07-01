const { authorizeAdmin } = require('../middleware/auth');
const controller = require("../controllers/mediaController");
const express = require("express");
const router = express.Router();
const { validateMedia } = require("../middleware/recordValidation");

router.get("/", controller.index);
router.get("/length", controller.indexLength);
router.get("/shows", controller.indexShows);
router.get("/seasons", controller.seasonCount);
router.get("/:id", controller.show);
router.post("/", [authorizeAdmin, validateMedia], controller.create);
router.put("/:id", [authorizeAdmin, validateMedia], controller.update);

module.exports = router;