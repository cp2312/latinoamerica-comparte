const express = require('express');
const router = express.Router();
const upload = require('../config/multer');

const {
  createNews,
  getAllNews,
  updateNews,
  deleteNews
} = require('../controllers/newsController');

const authMiddleware = require('../middlewares/authMiddleware');
const roleMiddleware = require('../middlewares/roleMiddleware');

router.post(
  '/',
  authMiddleware,
  roleMiddleware('superadmin', 'admin_pais', 'editor'),
  upload.single('imagen'),
  createNews
);

router.get(
  '/',
  getAllNews
);
router.put(
  '/:id',
  authMiddleware,
  roleMiddleware('superadmin', 'admin_pais', 'editor'),
  upload.single('imagen'),
  updateNews
);

router.delete(
  '/:id',
  authMiddleware,
  roleMiddleware('superadmin', 'admin_pais'),
  deleteNews
);

module.exports = router;