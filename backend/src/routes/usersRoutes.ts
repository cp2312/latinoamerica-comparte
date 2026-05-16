// ============================================================
// INSTRUCCIÓN: este archivo contiene 4 rutas separadas.
// Copia cada bloque en su propio archivo según se indica.
// ============================================================

// ── usersRoutes.ts ─────────────────────────────────────────
// Destino: backend/src/routes/usersRoutes.ts

import { Router } from 'express';
import authMiddleware from '../middlewares/authMiddleware';
import roleMiddleware from '../middlewares/roleMiddleware';
import { getUsers, createUser, updateUser, deleteUser } from '../controllers/usersController';

const router = Router();

router.get   ('/',    authMiddleware, roleMiddleware('superadmin'), getUsers);
router.post  ('/',    authMiddleware, roleMiddleware('superadmin'), createUser);
router.put   ('/:id', authMiddleware, roleMiddleware('superadmin'), updateUser);
router.delete('/:id', authMiddleware, roleMiddleware('superadmin'), deleteUser);

export default router;