import { Request, Response, NextFunction } from 'express';
import { AuthRequest, Rol } from '../types';

const roleMiddleware = (...rolesPermitidos: Rol[]) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    const authReq = req as AuthRequest;

    if (!authReq.user) {
      res.status(401).json({ message: 'Usuario no autenticado' });
      return;
    }

    if (!rolesPermitidos.includes(authReq.user.rol)) {
      res.status(403).json({ message: 'No tienes permisos para esta acción' });
      return;
    }

    next();
  };
};

export default roleMiddleware;