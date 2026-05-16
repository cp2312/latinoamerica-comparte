import mongoose, { Document, Schema } from 'mongoose';

export type TipoActividad = 'solicitud' | 'noticia' | 'testimonio';
export type AccionActividad =
  | 'nueva_solicitud'
  | 'estado_cambiado'
  | 'respondida'
  | 'noticia_publicada'
  | 'noticia_creada'
  | 'testimonio_aprobado'
  | 'testimonio_creado';

export interface IActividad extends Document {
  tipo:    TipoActividad;
  accion:  AccionActividad;
  texto:   string;
  pais:    string;
  usuario: string;
  fecha:   Date;
}

const actividadSchema = new Schema<IActividad>(
  {
    tipo:    { type: String, required: true },
    accion:  { type: String, required: true },
    texto:   { type: String, required: true },
    pais:    { type: String, default: '' },
    usuario: { type: String, default: '' },
    fecha:   { type: Date,   default: Date.now },
  },
  { timestamps: false }
);

export default mongoose.model<IActividad>('Actividad', actividadSchema);