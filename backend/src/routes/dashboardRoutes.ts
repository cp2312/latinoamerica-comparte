import { Router } from 'express';
import authMiddleware from '../middlewares/authMiddleware';
import roleMiddleware from '../middlewares/roleMiddleware';
import { getMetricas, getActividad } from '../controllers/dashboardController';

const router = Router();

// Métricas: solo superadmin
router.get('/metricas',  authMiddleware, roleMiddleware('superadmin'), getMetricas);

// Actividad: superadmin, admin_pais y editor pueden consultarla
router.get('/actividad', authMiddleware, roleMiddleware('superadmin', 'admin_pais', 'editor'), getActividad);

export default router;