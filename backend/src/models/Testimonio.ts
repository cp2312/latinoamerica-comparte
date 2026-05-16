import mongoose, { Document, Schema } from 'mongoose';

type EstadoTestimonio = 'borrador' | 'publicado' | 'despublicado';

export interface ITestimonio extends Document {
  nombre:       string;
  foto_url:     string | null;
  testimonio:   string;
  pais:         string;
  instagram_url: string | null;
  facebook_url:  string | null;
  estado:       EstadoTestimonio;
}

const testimonioSchema = new Schema<ITestimonio>(
  {
    nombre:       { type: String, required: true },
    foto_url:     { type: String, default: null },
    testimonio:   { type: String, required: true },
    pais:         { type: String, required: true },
    instagram_url:{ type: String, default: null },
    facebook_url: { type: String, default: null },
    estado: {
      type:    String,
      enum:    ['borrador', 'publicado', 'despublicado'] as EstadoTestimonio[],
      default: 'borrador',
    },
  },
  { timestamps: true }
);

export default mongoose.model<ITestimonio>('Testimonio', testimonioSchema);