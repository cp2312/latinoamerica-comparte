import { Request, Response } from 'express';
import bcrypt from 'bcrypt';
import User from '../models/User';
import { AuthRequest, Rol } from '../types';

const ROLES:  Rol[]    = ['superadmin', 'admin_pais', 'editor'];
const PAISES: string[] = ['Colombia', 'Chile', 'Ecuador', 'Argentina'];

// GET /users
const getUsers = async (_req: Request, res: Response): Promise<void> => {
  try {
    const users = await User.find({}, '-password').sort({ createdAt: -1 });
    res.json(users);
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// POST /users
const createUser = async (req: Request, res: Response): Promise<void> => {
  try {
    const { nombre, correo, password, rol, pais } = req.body as {
      nombre: string;
      correo: string;
      password: string;
      rol: Rol;
      pais?: string;
    };

    if (!nombre || !correo || !password || !rol) {
      res.status(400).json({ message: 'Faltan campos requeridos' });
      return;
    }
    if (!ROLES.includes(rol)) {
      res.status(400).json({ message: 'Rol inválido' });
      return;
    }
    if (rol !== 'superadmin' && pais && !PAISES.includes(pais)) {
      res.status(400).json({ message: 'País inválido' });
      return;
    }

    const existe = await User.findOne({ correo });
    if (existe) {
      res.status(409).json({ message: 'El correo ya está registrado' });
      return;
    }

    const hash = await bcrypt.hash(password, 10);
    const user = await User.create({
      nombre,
      correo,
      password: hash,
      rol,
      pais: rol === 'superadmin' ? null : (pais ?? null),
    });

    res.status(201).json({
      _id:    user._id,
      nombre: user.nombre,
      correo: user.correo,
      rol:    user.rol,
      pais:   user.pais,
    });
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// PUT /users/:id
const updateUser = async (req: Request, res: Response): Promise<void> => {
  try {
    const { nombre, correo, password, rol, pais } = req.body as {
      nombre?:   string;
      correo?:   string;
      password?: string;
      rol?:      Rol;
      pais?:     string | null;
    };

    const update: Record<string, unknown> = {};
    if (nombre)  update.nombre = nombre;
    if (correo)  update.correo = correo;
    if (rol)     update.rol    = rol;
    if (pais !== undefined) update.pais = rol === 'superadmin' ? null : pais;
    if (password) update.password = await bcrypt.hash(password, 10);

    const user = await User.findByIdAndUpdate(
      req.params.id,
      update,
      { new: true, select: '-password' }
    );

    if (!user) {
      res.status(404).json({ message: 'Usuario no encontrado' });
      return;
    }
    res.json(user);
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// DELETE /users/:id
const deleteUser = async (req: Request, res: Response): Promise<void> => {
  try {
    const authReq = req as AuthRequest;

    if (req.params.id === authReq.user?.id) {
      res.status(400).json({ message: 'No puedes eliminarte a ti mismo' });
      return;
    }

    const user = await User.findByIdAndDelete(req.params.id);
    if (!user) {
      res.status(404).json({ message: 'Usuario no encontrado' });
      return;
    }
    res.json({ message: 'Usuario eliminado' });
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

export { getUsers, createUser, updateUser, deleteUser };