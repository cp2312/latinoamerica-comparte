import { Request, Response } from 'express';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import User from '../models/User';
import Pais from '../models/Pais';

const login = async (req: Request, res: Response): Promise<void> => {
  try {
    const { correo, password }: { correo: string; password: string } = req.body;

    const user = await User.findOne({ correo });
    if (!user) {
      res.status(401).json({ message: 'Credenciales incorrectas' });
      return;
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      res.status(401).json({ message: 'Credenciales incorrectas' });
      return;
    }

    if (user.rol === 'admin_pais' && user.pais) {
      const pais = await Pais.findOne({ nombre: user.pais });
      if (!pais || pais.estado === 'inactivo') {
        res.status(403).json({
          message: `El portal de ${user.pais} está en mantenimiento. Contacta al superadmin.`,
          codigo:  'PAIS_INACTIVO',
        });
        return;
      }
    }

    const token = jwt.sign(
      { id: user._id, rol: user.rol, pais: user.pais },
      process.env.JWT_SECRET as string,
      { expiresIn: '1d' }
    );

    res.json({
      token,
      user: {
        nombre: user.nombre,
        correo: user.correo,
        rol:    user.rol,
        pais:   user.pais,
      },
    });
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

export { login };