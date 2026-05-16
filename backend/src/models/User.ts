import mongoose, { Document, Schema } from 'mongoose';
import { Rol } from '../types';

// Interfaz que describe los campos del documento User
export interface IUser extends Document {
  nombre: string;
  correo: string;
  password: string;
  rol: Rol;
  pais: string | null;
}

const userSchema = new Schema<IUser>({
  nombre: {
    type: String,
    required: true
  },
  correo: {
    type: String,
    required: true,
    unique: true
  },
  password: {
    type: String,
    required: true
  },
  rol: {
    type: String,
    enum: ['superadmin', 'admin_pais', 'editor'] as Rol[],
    required: true
  },
  pais: {
    type: String,
    default: null
  }
});

export default mongoose.model<IUser>('User', userSchema);