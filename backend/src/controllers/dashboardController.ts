import { Request, Response } from 'express';
import News       from '../models/News';
import Testimonio from '../models/Testimonio';
import Solicitud  from '../models/Solicitud';
import Actividad  from '../models/Actividad';
import { AuthRequest } from '../types';

const PAISES = ['Colombia', 'Chile', 'Ecuador', 'Argentina'] as const;

// GET /dashboard/metricas — solo superadmin
const getMetricas = async (_req: Request, res: Response): Promise<void> => {
  try {
    const [
      totalNoticias, noticiasActivas,
      totalTestimonios, testimoniosPublicados,
      totalSolicitudes, solicitudesPendientes,
    ] = await Promise.all([
      News.countDocuments(),
      News.countDocuments({ estado: 'publicado' }),
      Testimonio.countDocuments(),
      Testimonio.countDocuments({ estado: 'publicado' }),
      Solicitud.countDocuments(),
      Solicitud.countDocuments({ estado: 'pendiente' }),
    ]);

    const solicitudesPorPais = await Promise.all(
      PAISES.map(async (pais) => ({
        pais,
        pendientes: await Solicitud.countDocuments({ pais, estado: 'pendiente' }),
        total:      await Solicitud.countDocuments({ pais }),
      }))
    );

    const noticiasPorPais = await Promise.all(
      PAISES.map(async (pais) => ({
        pais,
        activas: await News.countDocuments({ pais, estado: 'publicado' }),
        total:   await News.countDocuments({ pais }),
      }))
    );

    res.json({
      globales: {
        totalNoticias, noticiasActivas,
        totalTestimonios, testimoniosPublicados,
        totalSolicitudes, solicitudesPendientes,
      },
      solicitudesPorPais,
      noticiasPorPais,
    });
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// GET /dashboard/metricas-pais — admin_pais: métricas solo de su país
const getMetricasPais = async (req: Request, res: Response): Promise<void> => {
  try {
    const authReq = req as AuthRequest;
    // El pais viene del JWT (ya validado por roleMiddleware)
    const pais = authReq.user?.pais ?? '';

    if (!pais) {
      res.status(400).json({ message: 'Usuario sin país asignado' });
      return;
    }

    const [pendientes, noticiasActivas] = await Promise.all([
      Solicitud.countDocuments({ pais, estado: 'pendiente' }),
      News.countDocuments({ pais, estado: 'publicado' }),
    ]);

    res.json({ pais, pendientes, noticiasActivas });
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// GET /dashboard/actividad — filtra por ?pais= si viene
const getActividad = async (req: Request, res: Response): Promise<void> => {
  try {
    const filtro: Record<string, unknown> = {};

    if (req.query.pais) {
      filtro.pais = (req.query.pais as string).toLowerCase();
    }

    const actividad = await Actividad.find(filtro)
      .sort({ fecha: -1 })
      .limit(5)
      .lean();

    res.json(actividad);
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

export { getMetricas, getMetricasPais, getActividad };