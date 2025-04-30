const { authorizeAdmin } = require('../middleware/auth');
const controller = require("../controllers/peopleController");
const express = require("express");
const router = express.Router();
const { validatePerson } = require("../middleware/recordValidation");

router.get("/", controller.index);
router.get("/length", controller.indexLength);
router.get("/select", controller.indexSelect);
router.get("/:id", controller.show);
router.post("/", [authorizeAdmin, validatePerson], controller.create);
router.put("/:id", [authorizeAdmin], controller.update);

module.exports = router;