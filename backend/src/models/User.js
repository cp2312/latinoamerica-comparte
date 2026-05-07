const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
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
    enum: ['superadmin', 'admin_pais', 'editor'],
    required: true
  },

  pais: {
    type: String,
    default: null
  }
});

module.exports = mongoose.model('User', userSchema);