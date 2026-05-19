import { Router } from 'express';
import authMiddleware from '../middlewares/authMiddleware';
import roleMiddleware from '../middlewares/roleMiddleware';
import {
  getPaises,
  createPais,
  cambiarEstadoPais,
  updatePais,
  deletePais,
} from '../controllers/paisController';

const router = Router();

// ── Pública — la app y el sitio la usan para saber qué países están activos ──
// GET /paises              → todos
// GET /paises?estado=activo → solo los activos (uso en portales públicos)
router.get('/', getPaises);

// ── Protegidas — solo superadmin ────────────────────────────────────────────
router.post(
  '/',
  authMiddleware,
  roleMiddleware('superadmin'),
  createPais
);

router.put(
  '/:id',
  authMiddleware,
  roleMiddleware('superadmin'),
  updatePais
);

// Ruta clave: activar / desactivar país (modo mantenimiento)
router.patch(
  '/:id/estado',
  authMiddleware,
  roleMiddleware('superadmin'),
  cambiarEstadoPais
);

router.delete(
  '/:id',
  authMiddleware,
  roleMiddleware('superadmin'),
  deletePais
);

export default router;