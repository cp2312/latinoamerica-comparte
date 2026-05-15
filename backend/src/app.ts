import express, { Request, Response } from 'express';
import cors from 'cors';
import path from 'path';

import authRoutes from './routes/authRoutes';
import newsRoutes from './routes/newsRoutes';
import authMiddleware from './middlewares/authMiddleware';
import roleMiddleware from './middlewares/roleMiddleware';
import { AuthRequest } from './types';

const app = express();

app.use(cors());
app.use(express.json());
app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

app.get('/', (_req: Request, res: Response) => {
  res.send('API funcionando');
});

app.use('/auth', authRoutes);
app.use('/news', newsRoutes);

app.get('/private', authMiddleware, (req: Request, res: Response) => {
  const authReq = req as AuthRequest;
  res.json({
    message: 'Ruta privada autorizada',
    user: authReq.user
  });
});

app.get(
  '/superadmin',
  authMiddleware,
  roleMiddleware('superadmin'),
  (_req: Request, res: Response) => {
    res.json({ message: 'Bienvenido Super Admin' });
  }
);

app.get(
  '/admin-pais',
  authMiddleware,
  roleMiddleware('superadmin', 'admin_pais'),
  (_req: Request, res: Response) => {
    res.json({ message: 'Bienvenido Admin País' });
  }
);

app.get(
  '/editor',
  authMiddleware,
  roleMiddleware('superadmin', 'admin_pais', 'editor'),
  (_req: Request, res: Response) => {
    res.json({ message: 'Bienvenido Editor' });
  }
);

export default app;