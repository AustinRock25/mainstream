const authController = require("../controllers/authController");
const { authenticate } = require("../middleware/auth");
const express = require("express");
const router = express.Router();
const { validateUser } = require("../middleware/recordValidation");

router.post("/register", validateUser, authController.register);
router.post("/login", authController.login);
router.post("/logout", authController.logout);
router.get("/verifyToken", authenticate, authController.verifyToken);
router.put("/change/:id", authenticate, authController.changeScale)

module.exports = router;