import { Request } from 'express';

// Roles permitidos en la aplicación
export type Rol = 'superadmin' | 'admin_pais' | 'editor';

// Payload del JWT decodificado
export interface JwtPayload {
  id: string;
  rol: Rol;
  pais: string | null;
}

// Request autenticado (incluye el usuario decodificado del token)
export interface AuthRequest extends Request {
  user?: JwtPayload;
}