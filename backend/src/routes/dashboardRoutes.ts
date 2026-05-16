import { Router } from 'express';
import authMiddleware from '../middlewares/authMiddleware';
import roleMiddleware from '../middlewares/roleMiddleware';
import { getMetricas } from '../controllers/dashboardController';

const router = Router();

router.get('/metricas', authMiddleware, roleMiddleware('superadmin'), getMetricas);

export default router;