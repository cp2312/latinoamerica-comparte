import { Router } from 'express';
import authMiddleware from '../middlewares/authMiddleware';
import roleMiddleware from '../middlewares/roleMiddleware';
import { getMetricas, getMetricasPais, getActividad } from '../controllers/dashboardController';

const router = Router();

// Métricas globales: solo superadmin
router.get('/metricas',      authMiddleware, roleMiddleware('superadmin'), getMetricas);

// Métricas por país: solo admin_pais (lee el país del JWT)
router.get('/metricas-pais', authMiddleware, roleMiddleware('admin_pais'), getMetricasPais);

// Actividad: superadmin, admin_pais y editor
router.get('/actividad',     authMiddleware, roleMiddleware('superadmin', 'admin_pais', 'editor'), getActividad);

export default router;