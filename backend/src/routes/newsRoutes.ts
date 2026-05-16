import { Router } from 'express';
import upload from '../config/multer';
import {
  createNews,
  getAllNews,
  updateNews,
  deleteNews
} from '../controllers/newsController';
import authMiddleware from '../middlewares/authMiddleware';
import roleMiddleware from '../middlewares/roleMiddleware';

const router = Router();

router.post(
  '/',
  authMiddleware,
  roleMiddleware('superadmin', 'admin_pais', 'editor'),
  upload.single('imagen'),
  createNews
);

router.get('/', getAllNews);

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

export default router;