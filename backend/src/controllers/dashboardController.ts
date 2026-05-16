import { Request, Response } from 'express';
import News       from '../models/News';
import Testimonio from '../models/Testimonio';
import Solicitud  from '../models/Solicitud';
import Actividad  from '../models/Actividad';

const PAISES = ['Colombia', 'Chile', 'Ecuador', 'Argentina'] as const;

// GET /dashboard/metricas — solo superadmin
const getMetricas = async (_req: Request, res: Response): Promise<void> => {
  try {
    const [
      totalNoticias,
      noticiasActivas,
      totalTestimonios,
      testimoniosPublicados,
      totalSolicitudes,
      solicitudesPendientes,
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
        totalNoticias,
        noticiasActivas,
        totalTestimonios,
        testimoniosPublicados,
        totalSolicitudes,
        solicitudesPendientes,
      },
      solicitudesPorPais,
      noticiasPorPais,
    });
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// GET /dashboard/actividad — últimas 20 acciones reales
const getActividad = async (_req: Request, res: Response): Promise<void> => {
  try {
    const actividad = await Actividad.find()
      .sort({ fecha: -1 })
      .limit(20)
      .lean();

    res.json(actividad);
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

export { getMetricas, getActividad };