import { Router } from 'express';
import authMiddleware from '../middlewares/authMiddleware';
import roleMiddleware from '../middlewares/roleMiddleware';
import { getMetricas, getActividad } from '../controllers/dashboardController';

const router = Router();

router.get('/metricas',  authMiddleware, roleMiddleware('superadmin'), getMetricas);
router.get('/actividad', authMiddleware, roleMiddleware('superadmin'), getActividad);

export default router;