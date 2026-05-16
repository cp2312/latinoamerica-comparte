import { Router } from 'express';
import authMiddleware from '../middlewares/authMiddleware';
import roleMiddleware from '../middlewares/roleMiddleware';
import {
  getSolicitudes,
  getSolicitud,
  createSolicitudPublica,
  cambiarEstadoSolicitud,
  responderSolicitud,
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

// POST /:id/responder — envía correo y marca como respondida
router.post(
  '/:id/responder',
  authMiddleware,
  roleMiddleware('superadmin', 'admin_pais'),
  responderSolicitud
);

router.delete(
  '/:id',
  authMiddleware,
  roleMiddleware('superadmin', 'admin_pais'),
  deleteSolicitud
);

export default router;