import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { AuthRequest, JwtPayload } from '../types';

const authMiddleware = (
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  try {
    const authHeader = req.header('Authorization');

    if (!authHeader) {
      res.status(401).json({ message: 'Token requerido' });
      return;
    }

    const token = authHeader.replace('Bearer ', '');

    const decoded = jwt.verify(
      token,
      process.env.JWT_SECRET as string
    ) as JwtPayload;

    (req as AuthRequest).user = decoded;

    next();
  } catch {
    res.status(401).json({ message: 'Token inválido' });
  }
};

export default authMiddleware;