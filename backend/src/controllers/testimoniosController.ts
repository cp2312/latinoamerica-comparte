import { Request, Response } from 'express';
import Testimonio from '../models/Testimonio';
import { AuthRequest } from '../types';

type EstadoTestimonio = 'borrador' | 'publicado' | 'despublicado';

// GET /testimonios/public — sin auth, solo publicados
const getTestimoniosPublicos = async (req: Request, res: Response): Promise<void> => {
  try {
    const filtro: Record<string, unknown> = { estado: 'publicado' };
    if (req.query.pais) filtro.pais = req.query.pais as string;

    const items = await Testimonio.find(filtro).sort({ createdAt: -1 });
    res.json(items);
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// GET /testimonios — protegido
const getTestimonios = async (req: Request, res: Response): Promise<void> => {
  try {
    const authReq = req as AuthRequest;
    const filtro: Record<string, unknown> = {};

    if (req.query.pais)   filtro.pais   = req.query.pais as string;
    if (req.query.estado) filtro.estado = req.query.estado as string;

    // admin_pais solo ve su país
    if (authReq.user?.rol === 'admin_pais' && authReq.user.pais) {
      filtro.pais = authReq.user.pais;
    }

    const items = await Testimonio.find(filtro).sort({ createdAt: -1 });
    res.json(items);
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// POST /testimonios
const createTestimonio = async (req: Request, res: Response): Promise<void> => {
  try {
    const { nombre, foto_url, testimonio, pais, instagram_url, facebook_url, estado } =
      req.body as {
        nombre:        string;
        foto_url?:     string;
        testimonio:    string;
        pais:          string;
        instagram_url?: string;
        facebook_url?:  string;
        estado?:       EstadoTestimonio;
      };

    if (!nombre || !testimonio || !pais) {
      res.status(400).json({ message: 'Faltan campos requeridos' });
      return;
    }

    const item = await Testimonio.create({
      nombre, foto_url, testimonio, pais,
      instagram_url, facebook_url,
      estado: estado ?? 'borrador',
    });
    res.status(201).json(item);
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// PUT /testimonios/:id
const updateTestimonio = async (req: Request, res: Response): Promise<void> => {
  try {
    const item = await Testimonio.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!item) { res.status(404).json({ message: 'No encontrado' }); return; }
    res.json(item);
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// PATCH /testimonios/:id/estado
const cambiarEstadoTestimonio = async (req: Request, res: Response): Promise<void> => {
  try {
    const { estado } = req.body as { estado: EstadoTestimonio };
    const validos: EstadoTestimonio[] = ['borrador', 'publicado', 'despublicado'];

    if (!validos.includes(estado)) {
      res.status(400).json({ message: 'Estado inválido' });
      return;
    }
    const item = await Testimonio.findByIdAndUpdate(
      req.params.id, { estado }, { new: true }
    );
    if (!item) { res.status(404).json({ message: 'No encontrado' }); return; }
    res.json(item);
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// DELETE /testimonios/:id
const deleteTestimonio = async (req: Request, res: Response): Promise<void> => {
  try {
    const item = await Testimonio.findByIdAndDelete(req.params.id);
    if (!item) { res.status(404).json({ message: 'No encontrado' }); return; }
    res.json({ message: 'Testimonio eliminado' });
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

export {
  getTestimoniosPublicos,
  getTestimonios,
  createTestimonio,
  updateTestimonio,
  cambiarEstadoTestimonio,
  deleteTestimonio,
};