import express, { Request, Response } from 'express';
import cors from 'cors';
import path from 'path';

import authRoutes        from './routes/authRoutes';
import newsRoutes        from './routes/newsRoutes';
import usersRoutes       from './routes/usersRoutes';
import testimoniosRoutes from './routes/testimoniosRoutes';
import solicitudesRoutes from './routes/solicitudesRoutes';
import dashboardRoutes   from './routes/dashboardRoutes';

const app = express();

app.use(cors());
app.use(express.json());
app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

app.get('/', (_req: Request, res: Response) => {
  res.send('API funcionando');
});

// ── Rutas ────────────────────────────────────────────────────────────────────
app.use('/auth',        authRoutes);
app.use('/news',        newsRoutes);
app.use('/users',       usersRoutes);
app.use('/testimonios', testimoniosRoutes);
app.use('/solicitudes', solicitudesRoutes);
app.use('/dashboard',   dashboardRoutes);

export default app;