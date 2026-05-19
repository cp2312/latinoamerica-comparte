import { Request, Response } from 'express';
import Pais from '../models/Pais';

type EstadoPais = 'activo' | 'inactivo';

// ─────────────────────────────────────────────────────────────────────────────
// GET /paises — lista todos los países (público, sin auth)
// Permite filtrar por estado: GET /paises?estado=activo
// ─────────────────────────────────────────────────────────────────────────────
const getPaises = async (req: Request, res: Response): Promise<void> => {
  try {
    const filtro: Record<string, unknown> = {};

    if (req.query.estado) {
      filtro.estado = req.query.estado as string;
    }

    const paises = await Pais.find(filtro).sort({ nombre: 1 });
    res.json(paises);
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// ─────────────────────────────────────────────────────────────────────────────
// POST /paises — crear país (solo superadmin)
// Body: { nombre: string }
// ─────────────────────────────────────────────────────────────────────────────
const createPais = async (req: Request, res: Response): Promise<void> => {
  try {
    const { nombre } = req.body as { nombre: string };

    if (!nombre || nombre.trim() === '') {
      res.status(400).json({ message: 'El nombre del país es requerido' });
      return;
    }

    const existe = await Pais.findOne({ nombre: nombre.trim() });
    if (existe) {
      res.status(409).json({ message: 'Ya existe un país con ese nombre' });
      return;
    }

    const pais = await Pais.create({ nombre: nombre.trim() });
    res.status(201).json(pais);
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// ─────────────────────────────────────────────────────────────────────────────
// PATCH /paises/:id/estado — activar o desactivar un país (solo superadmin)
// Body: { estado: 'activo' | 'inactivo' }
// Este es el endpoint central de la funcionalidad de mantenimiento.
// ─────────────────────────────────────────────────────────────────────────────
const cambiarEstadoPais = async (req: Request, res: Response): Promise<void> => {
  try {
    const { estado } = req.body as { estado: EstadoPais };
    const validos: EstadoPais[] = ['activo', 'inactivo'];

    if (!validos.includes(estado)) {
      res.status(400).json({ message: 'Estado inválido. Use "activo" o "inactivo"' });
      return;
    }

    const pais = await Pais.findByIdAndUpdate(
      req.params.id,
      { estado },
      { new: true }
    );

    if (!pais) {
      res.status(404).json({ message: 'País no encontrado' });
      return;
    }

    res.json({
      message: `País ${pais.nombre} ${estado === 'activo' ? 'activado' : 'desactivado'} correctamente`,
      pais,
    });
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// ─────────────────────────────────────────────────────────────────────────────
// PUT /paises/:id — editar nombre de un país (solo superadmin)
// Body: { nombre: string }
// ─────────────────────────────────────────────────────────────────────────────
const updatePais = async (req: Request, res: Response): Promise<void> => {
  try {
    const { nombre } = req.body as { nombre?: string };

    if (!nombre || nombre.trim() === '') {
      res.status(400).json({ message: 'El nombre del país es requerido' });
      return;
    }

    const duplicado = await Pais.findOne({
      nombre: nombre.trim(),
      _id:    { $ne: req.params.id },
    });
    if (duplicado) {
      res.status(409).json({ message: 'Ya existe un país con ese nombre' });
      return;
    }

    const pais = await Pais.findByIdAndUpdate(
      req.params.id,
      { nombre: nombre.trim() },
      { new: true }
    );

    if (!pais) {
      res.status(404).json({ message: 'País no encontrado' });
      return;
    }

    res.json(pais);
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// ─────────────────────────────────────────────────────────────────────────────
// DELETE /paises/:id — eliminar país (solo superadmin)
// ─────────────────────────────────────────────────────────────────────────────
const deletePais = async (req: Request, res: Response): Promise<void> => {
  try {
    const pais = await Pais.findByIdAndDelete(req.params.id);

    if (!pais) {
      res.status(404).json({ message: 'País no encontrado' });
      return;
    }

    res.json({ message: `País ${pais.nombre} eliminado` });
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

export { getPaises, createPais, cambiarEstadoPais, updatePais, deletePais };