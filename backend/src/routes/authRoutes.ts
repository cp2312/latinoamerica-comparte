import { Router } from 'express';

import {
  login,
  forgotPassword,
  resetPassword,
} from '../controllers/authController';

const router = Router();

// LOGIN
router.post('/login', login);

// RECUPERAR CONTRASEÑA
router.post(
  '/forgot-password',
  forgotPassword
);

// CAMBIAR CONTRASEÑA
router.post(
  '/reset-password',
  resetPassword
);

export default router;