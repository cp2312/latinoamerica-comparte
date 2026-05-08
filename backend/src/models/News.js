const mongoose = require('mongoose');

const newsSchema = new mongoose.Schema(
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
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },

    estado: {
      type: String,
      enum: ['borrador', 'publicado'],
      default: 'borrador'
    }
  },
  {
    timestamps: true
  }
);

module.exports = mongoose.model('News', newsSchema);