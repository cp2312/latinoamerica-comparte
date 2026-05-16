import { Router } from 'express';
import authMiddleware from '../middlewares/authMiddleware';
import roleMiddleware from '../middlewares/roleMiddleware';
import {
  getTestimoniosPublicos,
  getTestimonios,
  createTestimonio,
  updateTestimonio,
  cambiarEstadoTestimonio,
  deleteTestimonio,
} from '../controllers/testimoniosController';

const router = Router();

// Pública — sin auth
router.get('/public', getTestimoniosPublicos);

// Protegidas
router.get(
  '/',
  authMiddleware,
  roleMiddleware('superadmin', 'admin_pais', 'editor'),
  getTestimonios
);
router.post(
  '/',
  authMiddleware,
  roleMiddleware('superadmin', 'admin_pais', 'editor'),
  createTestimonio
);
router.put(
  '/:id',
  authMiddleware,
  roleMiddleware('superadmin', 'admin_pais', 'editor'),
  updateTestimonio
);
router.patch(
  '/:id/estado',
  authMiddleware,
  roleMiddleware('superadmin', 'admin_pais', 'editor'),
  cambiarEstadoTestimonio
);
router.delete(
  '/:id',
  authMiddleware,
  roleMiddleware('superadmin', 'admin_pais'),
  deleteTestimonio
);

export default router;