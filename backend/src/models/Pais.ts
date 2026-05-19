import mongoose, { Document, Schema } from 'mongoose';

type EstadoPais = 'activo' | 'inactivo';

// Interfaz que describe los campos del documento Pais
export interface IPais extends Document {
  nombre: string;
  estado: EstadoPais;
}

const paisSchema = new Schema<IPais>(
  {
    nombre: {
      type:     String,
      required: true,
      unique:   true,   // no puede haber dos países con el mismo nombre
      trim:     true,
    },
    estado: {
      type:    String,
      enum:    ['activo', 'inactivo'] as EstadoPais[],
      default: 'activo',
    },
  },
  { timestamps: true }
);

export default mongoose.model<IPais>('Pais', paisSchema);