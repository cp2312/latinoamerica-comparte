import mongoose, { Document, Schema, Types } from 'mongoose';

type EstadoNoticia = 'borrador' | 'publicado';

// Interfaz que describe los campos del documento News
export interface INews extends Document {
  titulo: string;
  contenido: string;
  imagen: string | null;
  pais: string | null;
  autor: Types.ObjectId;
  estado: EstadoNoticia;
}

const newsSchema = new Schema<INews>(
  {
    titulo: {
      type: String,
      required: true
    },
    contenido: {
      type: String,
      required: true
    },
    imagen: {
      type: String,
      default: null
    },
    pais: {
      type: String,
      default: null
    },
    autor: {
      type: Schema.Types.ObjectId,
      ref: 'User'
    },
    estado: {
      type: String,
      enum: ['borrador', 'publicado'] as EstadoNoticia[],
      default: 'borrador'
    }
  },
  {
    timestamps: true
  }
);

export default mongoose.model<INews>('News', newsSchema);