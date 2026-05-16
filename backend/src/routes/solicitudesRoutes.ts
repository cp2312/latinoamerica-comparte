import { Router } from 'express';
import authMiddleware from '../middlewares/authMiddleware';
import roleMiddleware from '../middlewares/roleMiddleware';
import {
  getSolicitudes,
  getSolicitud,
  createSolicitudPublica,
  cambiarEstadoSolicitud,
  deleteSolicitud,
} from '../controllers/solicitudesController';

const router = Router();

// Pública — formulario de contacto sin login
router.post('/public', createSolicitudPublica);

// Protegidas
router.get(
  '/',
  authMiddleware,
  roleMiddleware('superadmin', 'admin_pais'),
  getSolicitudes
);
router.get(
  '/:id',
  authMiddleware,
  roleMiddleware('superadmin', 'admin_pais'),
  getSolicitud
);
router.patch(
  '/:id/estado',
  authMiddleware,
  roleMiddleware('superadmin', 'admin_pais'),
  cambiarEstadoSolicitud
);
router.delete(
  '/:id',
  authMiddleware,
  roleMiddleware('superadmin', 'admin_pais'),
  deleteSolicitud
);

export default router;