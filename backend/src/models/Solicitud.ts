import mongoose, { Document, Schema } from 'mongoose';

type EstadoSolicitud = 'pendiente' | 'gestionada' | 'respondida';

export interface ISolicitud extends Document {
  nombre:    string;
  correo:    string;
  telefono:  string;
  finalidad: string;
  pais:      string;
  estado:    EstadoSolicitud;
}

const solicitudSchema = new Schema<ISolicitud>(
  {
    nombre:    { type: String, required: true },
    correo:    { type: String, required: true },
    telefono:  { type: String, required: true },
    finalidad: { type: String, required: true },
    pais:      { type: String, required: true },
    estado: {
      type:    String,
      enum:    ['pendiente', 'gestionada', 'respondida'] as EstadoSolicitud[],
      default: 'pendiente',
    },
  },
  { timestamps: true }
);

export default mongoose.model<ISolicitud>('Solicitud', solicitudSchema);