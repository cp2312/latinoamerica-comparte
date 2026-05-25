import { Request, Response } from 'express';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import nodemailer from 'nodemailer';

import User from '../models/User';
import Pais from '../models/Pais';


// ─────────────────────────────────────────────
// LOGIN
// ─────────────────────────────────────────────
const login = async (req: Request, res: Response): Promise<void> => {
  try {
    const { correo, password }: { correo: string; password: string } = req.body;

    const user = await User.findOne({ correo });

    if (!user) {
      res.status(401).json({
        message: 'Credenciales incorrectas',
      });
      return;
    }

    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      res.status(401).json({
        message: 'Credenciales incorrectas',
      });
      return;
    }

    // Validar país activo
    if (user.rol === 'admin_pais' && user.pais) {
      const pais = await Pais.findOne({
        nombre: user.pais,
      });

      if (!pais || pais.estado === 'inactivo') {
        res.status(403).json({
          message:
            `El portal de ${user.pais} está en mantenimiento.`,
          codigo: 'PAIS_INACTIVO',
        });
        return;
      }
    }

    const token = jwt.sign(
      {
        id: user._id,
        rol: user.rol,
        pais: user.pais,
      },
      process.env.JWT_SECRET as string,
      {
        expiresIn: '1d',
      }
    );

    res.json({
      token,
      user: {
        nombre: user.nombre,
        correo: user.correo,
        rol: user.rol,
        pais: user.pais,
      },
    });

  } catch (error) {
    res.status(500).json({
      message: (error as Error).message,
    });
  }
};


// ─────────────────────────────────────────────
// RECUPERAR CONTRASEÑA
// ─────────────────────────────────────────────
const forgotPassword = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    const { correo } = req.body;

    const user = await User.findOne({ correo });

    if (!user) {
      res.status(404).json({
        message: 'Usuario no encontrado',
      });
      return;
    }

    // Token temporal
    const resetToken = jwt.sign(
      {
        id: user._id,
      },
      process.env.JWT_SECRET as string,
      {
        expiresIn: '15m',
      }
    );
const resetLink =
  `http://localhost:5000/#/reset-password/${resetToken}`;

    // Configuración del correo
    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
      },
    });

    // Enviar correo
    await transporter.sendMail({
      from: process.env.EMAIL_USER,
      to: correo,
      subject: 'Recuperación de contraseña',
      html: `
        <h2>Recuperar contraseña</h2>

        <p>Presiona el siguiente enlace:</p>

        <a href="${resetLink}">
          Cambiar contraseña
        </a>
      `,
    });

    res.json({
      message: 'Correo enviado correctamente',
    });

  } catch (error) {
    res.status(500).json({
      message: (error as Error).message,
    });
  }
};


// ─────────────────────────────────────────────
// CAMBIAR CONTRASEÑA
// ─────────────────────────────────────────────
const resetPassword = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    const { token, password } = req.body;

    const decoded = jwt.verify(
      token,
      process.env.JWT_SECRET as string
    ) as { id: string };

    const hashedPassword = await bcrypt.hash(password, 10);

    await User.findByIdAndUpdate(decoded.id, {
      password: hashedPassword,
    });

    res.json({
      message: 'Contraseña actualizada',
    });

  } catch (error) {
    res.status(500).json({
      message: 'Token inválido o expirado',
    });
  }
};


// ─────────────────────────────────────────────
// EXPORTS
// ─────────────────────────────────────────────
export {
  login,
  forgotPassword,
  resetPassword,
};