import { Request, Response } from 'express';
import Solicitud from '../models/Solicitud';
import { AuthRequest } from '../types';

type EstadoSolicitud = 'pendiente' | 'gestionada' | 'respondida';

// GET /solicitudes — protegido
const getSolicitudes = async (req: Request, res: Response): Promise<void> => {
  try {
    const authReq = req as AuthRequest;
    const filtro: Record<string, unknown> = {};

    if (req.query.pais)   filtro.pais   = req.query.pais as string;
    if (req.query.estado) filtro.estado = req.query.estado as string;

    // admin_pais solo ve su país
    if (authReq.user?.rol === 'admin_pais' && authReq.user.pais) {
      filtro.pais = authReq.user.pais;
    }

    const items = await Solicitud.find(filtro).sort({ createdAt: -1 });
    res.json(items);
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// GET /solicitudes/:id
const getSolicitud = async (req: Request, res: Response): Promise<void> => {
  try {
    const item = await Solicitud.findById(req.params.id);
    if (!item) { res.status(404).json({ message: 'No encontrada' }); return; }
    res.json(item);
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// POST /solicitudes/public — sin auth
const createSolicitudPublica = async (req: Request, res: Response): Promise<void> => {
  try {
    const { nombre, correo, telefono, finalidad, pais } = req.body as {
      nombre:    string;
      correo:    string;
      telefono:  string;
      finalidad: string;
      pais:      string;
    };

    if (!nombre || !correo || !telefono || !finalidad || !pais) {
      res.status(400).json({ message: 'Faltan campos requeridos' });
      return;
    }

    const item = await Solicitud.create({ nombre, correo, telefono, finalidad, pais });
    res.status(201).json(item);
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// PATCH /solicitudes/:id/estado
const cambiarEstadoSolicitud = async (req: Request, res: Response): Promise<void> => {
  try {
    const { estado } = req.body as { estado: EstadoSolicitud };
    const validos: EstadoSolicitud[] = ['pendiente', 'gestionada', 'respondida'];

    if (!validos.includes(estado)) {
      res.status(400).json({ message: 'Estado inválido' });
      return;
    }
    const item = await Solicitud.findByIdAndUpdate(
      req.params.id, { estado }, { new: true }
    );
    if (!item) { res.status(404).json({ message: 'No encontrada' }); return; }
    res.json(item);
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// DELETE /solicitudes/:id
const deleteSolicitud = async (req: Request, res: Response): Promise<void> => {
  try {
    const item = await Solicitud.findByIdAndDelete(req.params.id);
    if (!item) { res.status(404).json({ message: 'No encontrada' }); return; }
    res.json({ message: 'Solicitud eliminada' });
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

export {
  getSolicitudes,
  getSolicitud,
  createSolicitudPublica,
  cambiarEstadoSolicitud,
  deleteSolicitud,
};